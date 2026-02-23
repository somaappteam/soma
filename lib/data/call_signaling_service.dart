import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:soma/data/auth_repository.dart';
import 'package:soma/data/profile_store.dart';
import 'package:soma/features/social/dm_chat_screen.dart';
import 'package:soma/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  StreamSubscription? _callKitSub;
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
        .onBroadcast(event: 'call_signal', callback: (final payload) {
          debugPrint('CallSignalingService: received signal: $payload');
          _handleIncomingSignal(payload);
        })
        .subscribe((final status, final error) {
          debugPrint('CallSignalingService: channel status: $status, error: $error');
        });

    _personalChannel = channel;

    _callKitSub = FlutterCallkitIncoming.onEvent.listen((final event) {
      if (event == null) return;
      switch (event.event) {
        case Event.actionCallAccept:
          final extra = event.body['extra'] as Map?;
          final from = extra?['caller_id']?.toString();
          if (from != null) {
            sendSignal(toUserId: from, type: CallSignalType.accept);
            _eventController.add(CallSignalEvent(
              type: CallSignalType.accept,
              fromUserId: from,
              rawData: {'from': from, 'type': 'accept'},
            ));
            
            // Navigate to the chat screen if we are not already there
            final context = navigatorKey.currentContext;
            if (context != null) {
               final meId = authRepository.currentUser?.id;
               if (meId != null) {
                 Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (final _) => DmChatScreen(
                       meId: meId,
                       otherId: from,
                       otherName: 'Chat', // We might not have the name, show 'Chat'
                       initialIncomingCall: true,
                     ),
                   ),
                 );
               }
            }
          }
          break;
        case Event.actionCallDecline:
        case Event.actionCallEnded:
        case Event.actionCallTimeout:
          final extra = event.body['extra'] as Map?;
          final from = extra?['caller_id']?.toString();
          if (from != null) {
            sendSignal(toUserId: from, type: CallSignalType.decline);
            _eventController.add(CallSignalEvent(
              type: CallSignalType.decline,
              fromUserId: from,
              rawData: {'from': from, 'type': 'decline'},
            ));
          }
          break;
        default:
          break;
      }
    });
  }

  void _handleIncomingSignal(final dynamic payload) {
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
    required final String toUserId,
    required final CallSignalType type,
    final Map<String, dynamic>? extraData,
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

    if (type == CallSignalType.invite) {
      try {
        final profile = profileStore.profile;
        final myName = profile.displayName.isNotEmpty ? profile.displayName : profile.username;
        await _supabase.functions.invoke('send-call-push', body: {
          'toUserId': toUserId,
          'callerName': myName.isNotEmpty ? myName : 'Someone',
          'callerId': me,
          'circleId': extraData?['circleId'],
        });
      } catch (e) {
        debugPrint('CallSignalingService: Edge function failed: $e');
      }
    }
  }

  void _cleanup() {
    if (_personalChannel != null) {
      _supabase.removeChannel(_personalChannel!);
      _personalChannel = null;
    }
    _callKitSub?.cancel();
    _callKitSub = null;
  }

  void dispose() {
    _cleanup();
    _eventController.close();
  }
}

final callSignalingService = CallSignalingService.instance;
