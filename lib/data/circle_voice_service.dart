import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_repository.dart';

class VoicePresence {
  final String userId;
  final String name;
  final bool muted;
  final bool speaking;
  final DateTime updatedAt;

  const VoicePresence({
    required this.userId,
    required this.name,
    required this.muted,
    required this.speaking,
    required this.updatedAt,
  });
}

class CircleVoiceService {
  CircleVoiceService._();

  static final CircleVoiceService instance = CircleVoiceService._();

  final SupabaseClient _client = Supabase.instance.client;
  final Map<String, VoicePresence> _presenceByUser = {};
  final StreamController<Map<String, VoicePresence>> _controller =
      StreamController<Map<String, VoicePresence>>.broadcast();

  RealtimeChannel? _channel;
  String? _circleId;
  String? _userId;
  String _name = 'User';
  bool _muted = false;
  bool _speaking = false;

  Stream<Map<String, VoicePresence>> get stream => _controller.stream;
  bool get muted => _muted;
  bool get speaking => _speaking;

  VoicePresence? get me {
    final uid = _userId;
    if (uid == null) return null;
    return _presenceByUser[uid];
  }

  VoicePresence? voiceFor(String userId) => _presenceByUser[userId];

  Future<void> connect({required String circleId, required String name}) async {
    final uid = authRepository.currentUser?.id;
    if (uid == null) return;

    if (_channel != null && _circleId == circleId) {
      _name = name;
      _userId = uid;
      _track();
      return;
    }

    await disconnectIfCircle(_circleId);

    _circleId = circleId;
    _userId = uid;
    _name = name;

    _channel = _client.channel(
      'circle_voice:$circleId',
      opts: RealtimeChannelConfig(
        key: uid,
        enabled: true,
      ),
    );

    _channel!
        .onPresenceSync((payload) => _syncPresence())
        .onPresenceJoin((payload) => _syncPresence())
        .onPresenceLeave((payload) => _syncPresence());

    _channel!.subscribe();
    _track();
  }

  void _track() {
    final uid = _userId;
    if (uid == null || _channel == null) return;

    _channel!.track({
      'user_id': uid,
      'name': _name,
      'muted': _muted,
      'speaking': _speaking,
      'updated_at': DateTime.now().toIso8601String(),
    });

    _presenceByUser[uid] = VoicePresence(
      userId: uid,
      name: _name,
      muted: _muted,
      speaking: _speaking,
      updatedAt: DateTime.now(),
    );
    _controller.add(Map<String, VoicePresence>.from(_presenceByUser));
  }

  void _syncPresence() {
    final channel = _channel;
    if (channel == null) return;

    final raw = channel.presenceState();
    final Map<String, VoicePresence> next = {};

    for (final state in raw) {
      if (state.presences.isEmpty) continue;
      final latest = state.presences.last.payload;
      final payload = Map<String, dynamic>.from(latest);

      final userId = (payload['user_id'] ?? state.key).toString();
      final name = payload['name']?.toString() ?? 'User';
      final muted = payload['muted'] == true;
      final speaking = payload['speaking'] == true;
      final updatedAtRaw = payload['updated_at']?.toString();
      final updatedAt = updatedAtRaw != null
          ? DateTime.tryParse(updatedAtRaw) ?? DateTime.now()
          : DateTime.now();

      next[userId] = VoicePresence(
        userId: userId,
        name: name,
        muted: muted,
        speaking: speaking,
        updatedAt: updatedAt,
      );
    }

    _presenceByUser
      ..clear()
      ..addAll(next);

    _controller.add(Map<String, VoicePresence>.from(_presenceByUser));
  }

  void toggleMuted() {
    setMuted(!_muted);
  }

  void setMuted(bool muted) {
    _muted = muted;
    if (_muted) {
      _speaking = false;
    }
    _track();
  }

  void setSpeaking(bool speaking) {
    if (_muted) {
      if (_speaking) {
        _speaking = false;
        _track();
      }
      return;
    }
    if (_speaking == speaking) return;
    _speaking = speaking;
    _track();
  }

  Future<void> disconnectIfCircle(String? circleId) async {
    if (_channel == null || circleId == null) return;
    if (_circleId != circleId) return;

    await _client.removeChannel(_channel!);
    _channel = null;
    _circleId = null;
    _presenceByUser.clear();
    _controller.add({});
  }
}

final circleVoiceService = CircleVoiceService.instance;
