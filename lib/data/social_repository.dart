import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/data/achievements_repository.dart';
import 'package:soma/data/notifications_repository.dart';
import 'package:soma/data/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SocialRepository {
  final _supabase = Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Search users by username
  Future<List<Map<String, dynamic>>> searchUsers(final String query) async {
    if (query.isEmpty) return [];

    // Simple ILIKE search on username
    final data = await _supabase
        .from('profiles')
        .select('id, username, location')
        .ilike('username', '%$query%')
        .limit(20);

    return List<Map<String, dynamic>>.from(data);
  }

  // Send Friend Request
  Future<void> sendFriendRequest(final String addresseeId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('Not logged in');

    final existingPendingId = await getOutgoingPendingRequestId(addresseeId);
    if (existingPendingId != null) {
      throw Exception('Friend request already pending');
    }

    final inserted = await _supabase
        .from('friendships')
        .insert({
          'requester_id': uid,
          'addressee_id': addresseeId,
          'status': 'pending',
        })
        .select()
        .single();
    final friendshipId = inserted['id']?.toString();

    try {
      final fromProfile = await profileRepository.fetchProfile(userId: uid);
      final fromName =
          fromProfile?.displayName ?? fromProfile?.username ?? 'Someone';

      await notificationsRepository.sendFriendRequestNotification(
        toUserId: addresseeId,
        fromUserId: uid,
        fromUserName: fromName,
        friendshipId: friendshipId,
      );
    } catch (e) {
      appLogger.debug(
          'Non-critical: Failed to send friend request notification: $e');
    }
  }

  // Accept Friend Request
  Future<void> acceptFriendRequest(final String friendshipId) async {
    await _supabase
        .from('friendships')
        .update({'status': 'accepted'}).eq('id', friendshipId);

    await achievementsRepository.checkAfterFriend();
  }

  Future<void> acceptFriendRequestFromUser(final String requesterId) async {
    final uid = currentUserId;
    if (uid == null) return;

    final row = await _supabase
        .from('friendships')
        .select('id')
        .eq('requester_id', requesterId)
        .eq('addressee_id', uid)
        .eq('status', 'pending')
        .maybeSingle();
    if (row == null) return;

    await acceptFriendRequest(row['id'].toString());
  }

  // Get My Friends (where I am requester OR addressee, and status is accepted)
  Future<List<Map<String, dynamic>>> getFriends() async {
    final uid = currentUserId;
    if (uid == null) return [];

    // This is a bit complex in Supabase simple query.
    // Usually easier to query:
    // OR(and(requester_id.eq.me, status.eq.accepted), and(addressee_id.eq.me, status.eq.accepted))

    // For simplicity, we can do two queries or one complex filter string:
    // requester_id.eq.UID,status.eq.accepted, OR addressee_id.eq.UID,status.eq.accepted

    // Let's try select with complex filter
    final response = await _supabase
        .from('friendships')
        .select(
            '*, requester:profiles!requester_id(*), addressee:profiles!addressee_id(*)')
        .or('requester_id.eq.$uid,addressee_id.eq.$uid')
        .eq('status', 'accepted');

    final List<Map<String, dynamic>> friends = [];

    for (final item in response) {
      final requester = item['requester'];
      final addressee = item['addressee'];

      if (item['requester_id'] == uid) {
        // Friend is addressee
        if (addressee != null) friends.add(addressee);
      } else {
        // Friend is requester
        if (requester != null) friends.add(requester);
      }
    }
    return friends;
  }

  Stream<List<Map<String, dynamic>>> getFriendsStream() {
    if (currentUserId == null) return const Stream.empty();

    return _supabase.from('friendships').stream(
        primaryKey: ['id']).asyncMap((final event) async => await getFriends());
  }

  Stream<List<Map<String, dynamic>>> getIncomingRequestsStream() {
    if (currentUserId == null) return const Stream.empty();

    return _supabase.from('friendships').stream(primaryKey: ['id']).asyncMap(
        (final event) async => await getIncomingRequests());
  }

  Stream<List<Map<String, dynamic>>> getOutgoingRequestsStream() {
    if (currentUserId == null) return const Stream.empty();

    return _supabase.from('friendships').stream(primaryKey: ['id']).asyncMap(
        (final event) async => await getOutgoingRequests());
  }

  Future<String?> getOutgoingPendingRequestId(final String addresseeId) async {
    final uid = currentUserId;
    if (uid == null) return null;

    final row = await _supabase
        .from('friendships')
        .select('id')
        .eq('requester_id', uid)
        .eq('addressee_id', addresseeId)
        .eq('status', 'pending')
        .maybeSingle();

    return row?['id']?.toString();
  }

  Future<void> cancelFriendRequestToUser(final String addresseeId) async {
    final friendshipId = await getOutgoingPendingRequestId(addresseeId);
    if (friendshipId == null) return;
    await cancelFriendRequest(friendshipId);
  }

  // Get Pending Requests (incoming)
  Future<List<Map<String, dynamic>>> getIncomingRequests() async {
    final uid = currentUserId;
    if (uid == null) return [];
    // status=pending AND addressee_id=me
    final response = await _supabase
        .from('friendships')
        .select('*, requester:profiles!requester_id(*)')
        .eq('addressee_id', uid)
        .eq('status', 'pending');

    return List<Map<String, dynamic>>.from(response);
  }

  // Get Pending Requests (outgoing)
  Future<List<Map<String, dynamic>>> getOutgoingRequests() async {
    final uid = currentUserId;
    if (uid == null) return [];

    final response = await _supabase
        .from('friendships')
        .select('*, addressee:profiles!addressee_id(*)')
        .eq('requester_id', uid)
        .eq('status', 'pending');

    return List<Map<String, dynamic>>.from(response);
  }

  // Decline Friend Request (incoming)
  Future<void> declineFriendRequest(final String friendshipId) async {
    await _supabase.from('friendships').delete().eq('id', friendshipId);
  }

  Future<void> declineFriendRequestFromUser(final String requesterId) async {
    final uid = currentUserId;
    if (uid == null) return;

    final row = await _supabase
        .from('friendships')
        .select('id')
        .eq('requester_id', requesterId)
        .eq('addressee_id', uid)
        .eq('status', 'pending')
        .maybeSingle();
    if (row == null) return;

    await declineFriendRequest(row['id'].toString());
  }

  // Cancel Friend Request (outgoing)
  Future<void> cancelFriendRequest(final String friendshipId) async {
    await _supabase.from('friendships').delete().eq('id', friendshipId);
  }

  // Remove Friend
  Future<void> removeFriend(final String friendUserId) async {
    final uid = currentUserId;
    if (uid == null) return;

    // Delete friendship where (requester=me AND addressee=friend) OR (requester=friend AND addressee=me)
    await _supabase.from('friendships').delete().or(
        'and(requester_id.eq.$uid,addressee_id.eq.$friendUserId),and(requester_id.eq.$friendUserId,addressee_id.eq.$uid)');
  }
}

SocialRepository get socialRepository => locator<SocialRepository>();
