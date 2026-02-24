import 'package:flutter/foundation.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/core/services/error_reporter.dart';
import 'package:soma/data/achievements_repository.dart';
import 'package:soma/data/stats_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CirclesRepository {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Stream of open circles (Lobby status)
  Stream<List<Map<String, dynamic>>> getOpenCircles() {
    return _supabase.from('circles').stream(primaryKey: ['id']).inFilter(
        'status', ['lobby', 'active']).order('created_at', ascending: false);
  }

  // NOTE: getOpenCircleParticipantCounts removed as we now specific columns in the circles table.

  /// Create a new circle
  Future<String> createCircle({
    required final String name,
    required final String fromLang,
    required final String toLang,
    required final String mode,
    required final String level,
    required final int maxPlayers,
    required final int questionsCount,
    required final int timePerQ,
    required final bool allowSpectators,
    final bool isLocked = false,
    final List<Map<String, dynamic>>? questions,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not logged in');

    if (kDebugMode) {
      appLogger.debug('Creating circle',
          context: {'questions_count': questions?.length ?? 0});
    }

    // 1. Create circle
    final response = await _supabase
        .from('circles')
        .insert({
          'host_id': uid,
          'name': name,
          'from_lang': fromLang,
          'to_lang': toLang,
          'mode': mode,
          'level': level,
          'max_players': maxPlayers,
          'questions_count': questions?.length ?? 0,
          'time_per_q': timePerQ,
          'allow_spectators': allowSpectators,
          'is_locked': isLocked,
          'status': 'lobby',
          'questions': questions ?? [],
        })
        .select()
        .single();

    final circleId = response['id'] as String;
    appLogger.info('Circle created', context: {'circle_id': circleId});

    // 2. Join as Host
    await joinCircle(circleId, role: 'host', isReady: true);

    return circleId;
  }

  /// Join a circle
  Future<void> joinCircle(final String circleId,
      {final String role = 'player', final bool isReady = false}) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not logged in');

    final circle = await getCircleDetails(circleId);
    if (circle == null) throw Exception('Circle not found');
    final isLocked = circle['is_locked'] == true;
    final hostId = circle['host_id']?.toString();
    if (isLocked && hostId != uid) {
      throw Exception('Circle is locked');
    }

    // Use upsert to handle case where participant already exists
    await _supabase.from('circle_participants').upsert({
      'circle_id': circleId,
      'user_id': uid,
      'role': role,
      'is_ready': isReady,
      'score': 0,
    }, onConflict: 'circle_id,user_id');

    try {
      final stats = await statsRepository.incrementCirclesJoined();
      await achievementsRepository.checkAfterCircle(stats: stats);
    } catch (e, st) {
      appLogger.warning('Optional stats update failed after joining circle',
          error: e, stackTrace: st);
      await errorReporter.capture(e, st,
          hint: 'CirclesRepository.joinCircle.optionalStats');
    }
  }

  /// Join from invite/link.
  ///
  /// - Invite/link users should auto-join as player when there is a free player slot.
  /// - If player slots are full, they join as spectator.
  /// - If already host/player, keep role as-is.
  Future<CircleJoinOutcome> joinCircleFromInvite(final String circleId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not logged in');

    final circle = await getCircleDetails(circleId);
    if (circle == null) throw Exception('Circle not found');
    if (circle['is_locked'] == true && circle['host_id']?.toString() != uid) {
      throw Exception('Circle is locked');
    }

    final status = (circle['status'] ?? 'lobby').toString();
    if (status == 'ended') {
      throw Exception('Circle has ended');
    }

    final existing = await _supabase
        .from('circle_participants')
        .select('role')
        .eq('circle_id', circleId)
        .eq('user_id', uid)
        .maybeSingle();

    if (existing != null) {
      final role = existing['role']?.toString();
      if (role == 'host' || role == 'player') {
        return CircleJoinOutcome(role: role ?? 'player', status: status);
      }
    }

    final maxPlayersRaw = circle['max_players'];
    final maxPlayers = maxPlayersRaw is int
        ? maxPlayersRaw
        : int.tryParse(maxPlayersRaw?.toString() ?? '') ?? 5;

    final players = await _supabase
        .from('circle_participants')
        .select('id')
        .eq('circle_id', circleId)
        .inFilter('role', ['host', 'player']);

    final playerCount = (players as List).length;
    final canJoinAsPlayer = playerCount < maxPlayers;
    final role = canJoinAsPlayer ? 'player' : 'spectator';

    await _supabase.from('circle_participants').upsert({
      'circle_id': circleId,
      'user_id': uid,
      'role': role,
      'is_ready': role == 'player' ? false : true,
      'score': 0,
    }, onConflict: 'circle_id,user_id');

    try {
      final stats = await statsRepository.incrementCirclesJoined();
      await achievementsRepository.checkAfterCircle(stats: stats);
    } catch (e, st) {
      appLogger.warning('Optional stats update failed after joining circle',
          error: e, stackTrace: st);
      await errorReporter.capture(e, st,
          hint: 'CirclesRepository.joinCircle.optionalStats');
    }

    return CircleJoinOutcome(role: role, status: status);
  }

  /// Listen to participants in a circle
  Stream<List<Map<String, dynamic>>> getParticipantsStream(
      final String circleId) {
    return _supabase
        .from('circle_participants')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .order('joined_at', ascending: true)
        .map((final rows) {
          // We might want to fetch profile details here or use a view/join logic
          // But stream join is hard.
          // For now, we return raw participant rows. UI will have to fetch/cache profiles.
          return rows;
        });
  }

  /// Leave circle (if host leaves and circle not ended, circle ends)
  Future<void> leaveCircle(final String circleId) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      // Check if user is the host and if circle is still open
      final circle = await getCircleDetails(circleId);
      final isHost = circle != null && circle['host_id'] == uid;
      final isOpen = circle != null && circle['status'] != 'ended';

      // Remove user from participants
      await _supabase
          .from('circle_participants')
          .delete()
          .eq('circle_id', circleId)
          .eq('user_id', uid);

      // If host leaves and circle is still open, end it
      if (isHost && isOpen) {
        await endCircle(circleId);
        appLogger.debug('Host left circle $circleId - circle ended.');
      }
    } catch (e) {
      appLogger.debug('Error in leaveCircle: $e');
      // Still try to remove participant even if other checks fail
      try {
        await _supabase
            .from('circle_participants')
            .delete()
            .eq('circle_id', circleId)
            .eq('user_id', uid);
      } catch (_) {}
    }
  }

  /// Update circle status (lobby, active, ended)
  Future<void> updateCircleStatus(
      final String circleId, final String status) async {
    await _supabase
        .from('circles')
        .update({'status': status}).eq('id', circleId);
  }

  Future<void> updateCircleQuestions(
      final String circleId, final List<Map<String, dynamic>> questions) async {
    await _supabase.from('circles').update({
      'questions': questions,
      'questions_count': questions.length,
    }).eq('id', circleId);
  }

  Future<void> updateCircleLock(
      final String circleId, final bool isLocked) async {
    await _supabase.from('circles').update({
      'is_locked': isLocked,
    }).eq('id', circleId);
  }

  Future<void> updateCircleMatchSettings({
    required final String circleId,
    required final String fromLang,
    required final String toLang,
    required final String mode,
    required final String level,
    required final int questionsCount,
    required final int timePerQ,
  }) async {
    await _supabase.from('circles').update({
      'from_lang': fromLang,
      'to_lang': toLang,
      'mode': mode,
      'level': level,
      'questions_count': questionsCount,
      'time_per_q': timePerQ,
    }).eq('id', circleId);
  }

  Future<void> updateCircleSettings({
    required final String circleId,
    required final int maxPlayers,
    required final int questionsCount,
    required final int timePerQ,
    required final bool allowSpectators,
  }) async {
    await _supabase.from('circles').update({
      'max_players': maxPlayers,
      'questions_count': questionsCount,
      'time_per_q': timePerQ,
      'allow_spectators': allowSpectators,
      'questions': [],
    }).eq('id', circleId);
  }

  /// Transfer host role to another participant
  Future<void> transferHost(
      {required final String circleId, required final String newHostId}) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not logged in');

    await _supabase
        .from('circles')
        .update({'host_id': newHostId}).eq('id', circleId);

    await _supabase
        .from('circle_participants')
        .update({'role': 'player'})
        .eq('circle_id', circleId)
        .eq('user_id', uid);

    await _supabase
        .from('circle_participants')
        .update({'role': 'host'})
        .eq('circle_id', circleId)
        .eq('user_id', newHostId);
  }

  /// End circle so it disappears from open lists
  Future<void> endCircle(final String circleId) async {
    try {
      appLogger.debug('Ending circle: $circleId');
      await updateCircleStatus(circleId, 'ended');
      appLogger.debug("Circle $circleId status set to 'ended'");
    } catch (e) {
      appLogger.debug('Failed to end circle $circleId: $e');
      rethrow;
    }
  }

  /// Toggle Ready Status
  Future<void> toggleReady(final String circleId, final bool isReady) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('circle_participants')
        .update({'is_ready': isReady})
        .eq('circle_id', circleId)
        .eq('user_id', uid);
  }

  /// Request to join as player (from spectator)
  Future<void> requestToJoin(final String circleId) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('circle_participants')
        .update({'role': 'pending'})
        .eq('circle_id', circleId)
        .eq('user_id', uid);
  }

  /// Approve a spectator join request
  Future<void> approveJoinRequest(
      {required final String circleId, required final String userId}) async {
    await _supabase
        .from('circle_participants')
        .update({'role': 'player', 'is_ready': false})
        .eq('circle_id', circleId)
        .eq('user_id', userId);
  }

  /// Decline a spectator join request
  Future<void> declineJoinRequest(
      {required final String circleId, required final String userId}) async {
    await _supabase
        .from('circle_participants')
        .update({'role': 'spectator'})
        .eq('circle_id', circleId)
        .eq('user_id', userId);
  }

  /// Get Circle Details
  Future<Map<String, dynamic>?> getCircleDetails(final String circleId) async {
    final data = await _supabase
        .from('circles')
        .select('*, questions')
        .eq('id', circleId)
        .maybeSingle();
    return data;
  }

  /// Stream of a specific circle's details (for status tracking)
  Stream<Map<String, dynamic>> getCircleStream(final String circleId) {
    return _supabase
        .from('circles')
        .stream(primaryKey: ['id'])
        .eq('id', circleId)
        .map((final rows) => rows.isNotEmpty ? rows.first : {});
  }

  Future<void> updateParticipantScore(
      final String circleId, final int score) async {
    final uid = currentUserId;
    if (uid == null) return;

    await _supabase
        .from('circle_participants')
        .update({'score': score})
        .eq('circle_id', circleId)
        .eq('user_id', uid);
  }

  /// Clean up "ghost" circles where the host has left but status is still open.
  Future<void> cleanupGhostCircles() async {
    try {
      // 1. Fetch all open circles (lobby/active)
      final response = await _supabase
          .from('circles')
          .select('id, host_id')
          .or('status.eq.lobby,status.eq.active');

      final circles = List<Map<String, dynamic>>.from(response);

      for (final circle in circles) {
        final circleId = circle['id'] as String;
        final hostId = circle['host_id'] as String;

        // 2. Check if host is still a participant
        final hostParticipant = await _supabase
            .from('circle_participants')
            .select('role') // minimal select
            .eq('circle_id', circleId)
            .eq('user_id', hostId)
            .maybeSingle();

        // 3. If host missing, end the circle
        if (hostParticipant == null) {
          appLogger.debug(
              'Found ghost circle $circleId (Host $hostId missing). Ending it.');
          await endCircle(circleId); // This sets status to 'ended'
        }
      }
    } catch (e) {
      appLogger.debug('Error cleaning up ghost circles: $e');
    }
  }
}

class CircleJoinOutcome {
  final String role;
  final String status;

  const CircleJoinOutcome({required this.role, required this.status});
}

CirclesRepository get circlesRepository => locator<CirclesRepository>();
