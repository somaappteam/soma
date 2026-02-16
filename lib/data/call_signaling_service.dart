import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_repository.dart';

enum CallSignalType { invite, accept, decline, busy, connected, end }

class CallSignalEvent {
  final CallSignalType type;
  final String fromUserId;
  final Map<String, dynamic> rawData;

  CallSignalEvent({
    required this.type,
    required this.fromUserId,
    required this.rawData,
  });
}

class CallSignalingService {
  CallSignalingService._();
  static final CallSignalingService instance = CallSignalingService._();

  final _supabase = Supabase.instance.client;
  RealtimeChannel? _personalChannel;
  final _eventController = StreamController<CallSignalEvent>.broadcast();

  Stream<CallSignalEvent> get events => _eventController.stream;

  void initialize() {
    final uid = authRepository.currentUser?.id;
    if (uid == null) return;

    _cleanup();

    final channel = _supabase.channel(
      'personal_signal:$uid',
      opts: const RealtimeChannelConfig(enabled: true),
    );

    channel
        .onBroadcast(event: 'call_signal', callback: (payload) {
          debugPrint('CallSignalingService: received signal: $payload');
          _handleIncomingSignal(payload);
        })
        .subscribe((status, error) {
          debugPrint('CallSignalingService: channel status: $status, error: $error');
        });

    _personalChannel = channel;
  }

  void _handleIncomingSignal(dynamic payload) {
    if (payload is! Map) return;
    final data = payload['payload'] is Map 
        ? Map<String, dynamic>.from(payload['payload'] as Map)
        : Map<String, dynamic>.from(payload);

    final from = data['from']?.toString();
    final typeStr = data['type']?.toString();
    if (from == null || typeStr == null) return;

    CallSignalType? type;
    switch (typeStr) {
      case 'invite': type = CallSignalType.invite; break;
      case 'accept': type = CallSignalType.accept; break;
      case 'decline': type = CallSignalType.decline; break;
      case 'busy': type = CallSignalType.busy; break;
      case 'connected': type = CallSignalType.connected; break;
      case 'end': type = CallSignalType.end; break;
    }

    if (type != null) {
      _eventController.add(CallSignalEvent(
        type: type,
        fromUserId: from,
        rawData: data,
      ));
    }
  }

  Future<void> sendSignal({
    required String toUserId,
    required CallSignalType type,
    Map<String, dynamic>? extraData,
  }) async {
    final me = authRepository.currentUser?.id;
    if (me == null) return;

    final channelId = 'personal_signal:$toUserId';
    final channel = _supabase.channel(channelId);
    
    // We don't need to subscribe to send a broadcast message to others
    debugPrint('CallSignalingService: sending ${type.name} to $toUserId');
    await channel.sendBroadcastMessage(
      event: 'call_signal',
      payload: {
        'type': type.name,
        'from': me,
        ...?extraData,
      },
    );
  }

  void _cleanup() {
    if (_personalChannel != null) {
      _supabase.removeChannel(_personalChannel!);
      _personalChannel = null;
    }
  }

  void dispose() {
    _cleanup();
    _eventController.close();
  }
}

final callSignalingService = CallSignalingService.instance;
