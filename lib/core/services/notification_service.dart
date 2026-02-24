import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/core/services/error_reporter.dart';
import 'package:soma/features/social/dm_chat_screen.dart';
import 'package:soma/main.dart'; // for navigatorKey
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ─── FCM background message handler (top-level, required by firebase_messaging) ─
@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(final RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data['push_type'] == 'call') {
    final callerName = message.data['caller_name'] ?? 'Someone';
    final callerId = message.data['caller_id'];

    final callParams = CallKitParams(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nameCaller: callerName,
      appName: 'Soma',
      avatar: '',
      handle: 'Incoming Call',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      extra: <String, dynamic>{'caller_id': callerId},
      headers: <String, dynamic>{'apiKey': 'v1_test', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#000000',
        actionColor: '#4CAF50',
      ),
      ios: const IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callParams);
  }
}

// ─── Android notification channel ───────────────────────────────────────────
const _kChannelId = 'soma_default';
const _kChannelName = 'Soma Notifications';
const _kChannelDesc = 'Friend requests, circles, and daily reminders';
const _kReminderId = 1;

enum NotificationInitState {
  idle,
  ready,
  permissionDenied,
  tokenRegistrationFailed
}

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  final _supabase = Supabase.instance.client;

  RealtimeChannel? _realtimeChannel;
  bool _pushEnabled = true;
  final ValueNotifier<NotificationInitState> initState =
      ValueNotifier(NotificationInitState.idle);

  // ─────────────────────────── Initialization ─────────────────────────────────

  Future<void> initialize(
      {final bool pushEnabled = true,
      final String reminderTime = '20:00'}) async {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    _pushEnabled = pushEnabled;

    await _initLocalNotifications();
    await _initTimezone();
    try {
      await Firebase.initializeApp();
    } catch (e) {
      appLogger.error('Firebase initialization failed during early bootstrap',
          error: e);
    }

    _initFirebaseMessaging();
    initState.value = NotificationInitState.ready;

    if (pushEnabled) {
      await scheduleReminder(reminderTime, enabled: true);
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _plugin.initialize(settings);

    // Create Android notification channel.
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        _kChannelId,
        _kChannelName,
        description: _kChannelDesc,
        importance: Importance.high,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _initTimezone() async {
    tz.initializeTimeZones();
    try {
      final localTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTz.toString()));
    } catch (_) {
      // Fall back to UTC if timezone lookup fails.
    }
  }

  void _initFirebaseMessaging() {
    try {
      // Register top-level background handler.
      FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

      // Handle foreground FCM messages — show as local notification.
      FirebaseMessaging.onMessage.listen((final message) async {
        if (!_pushEnabled) return;

        if (message.data['push_type'] == 'call') {
          await _fcmBackgroundHandler(message);
          return;
        }

        final title =
            message.notification?.title ?? message.data['title']?.toString();
        final body =
            message.notification?.body ?? message.data['body']?.toString();
        if (title != null) showNotification(title: title, body: body ?? '');
      });

      // ─── Deep Linking (Tap Handling) ───────────────────────────────────────
      // 1. App in background/foreground, but not terminated:
      FirebaseMessaging.onMessageOpenedApp.listen((final message) {
        _handleMessageTap(message);
      });

      // 2. App was terminated and opened via FCM:
      FirebaseMessaging.instance.getInitialMessage().then((final message) {
        if (message != null) {
          _handleMessageTap(message);
        }
      });

      // Register FCM token with Supabase (best-effort).
      _registerFcmToken();
    } catch (e, st) {
      appLogger.error('NotificationService Firebase init failed',
          error: e, stackTrace: st);
      unawaited(errorReporter.capture(e, st,
          hint: 'NotificationService._initFirebaseMessaging'));
    }
  }

  void _handleMessageTap(final RemoteMessage message) {
    appLogger.debug('Handling notification tap',
        context: {'type': message.data['type']?.toString()});

    // We expect payload to contain something like: { 'type': 'dm', 'otherId': '...', 'otherName': '...' }
    final type = message.data['type'] ?? message.data['push_type'];
    if (type == 'dm' || type == 'call') {
      final otherId = message.data['otherId']?.toString() ??
          message.data['caller_id']?.toString();
      final otherName = message.data['otherName']?.toString() ??
          message.data['caller_name']?.toString();
      final isCall = type == 'call' || message.data['push_type'] == 'call';
      final meId = _supabase.auth.currentUser?.id;

      if (otherId != null && meId != null) {
        // Use GlobalKey to navigate
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (final _) => DmChatScreen(
              meId: meId,
              otherId: otherId,
              otherName: otherName ?? 'Chat',
              initialIncomingCall: isCall,
            ),
          ),
        );
      }
    }
  }

  Future<void> _registerFcmToken() async {
    try {
      // Firebase.initializeApp() is now called earlier in initialize()
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      final status = settings.authorizationStatus;

      if (status == AuthorizationStatus.denied ||
          status == AuthorizationStatus.notDetermined) {
        initState.value = NotificationInitState.permissionDenied;
        appLogger.warning('Notification permission denied');
        return;
      }

      final token = await messaging.getToken();
      if (token != null) await _upsertToken(token);

      messaging.onTokenRefresh.listen(_upsertToken);
    } catch (e, st) {
      initState.value = NotificationInitState.tokenRegistrationFailed;
      appLogger.error('FCM token registration failed',
          error: e, stackTrace: st);
      await errorReporter.capture(e, st,
          hint: 'NotificationService._registerFcmToken');
    }
  }

  Future<void> _upsertToken(final String token) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    try {
      await _supabase
          .from('profiles')
          .update({'fcm_token': token}).eq('id', uid);
      appLogger.info('FCM token saved');
    } catch (e, st) {
      appLogger.error('FCM token upsert failed', error: e, stackTrace: st);
      await errorReporter.capture(e, st,
          hint: 'NotificationService._upsertToken');
    }
  }

  /// Clears the stored FCM token on logout.
  Future<void> clearToken() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    try {
      await _supabase
          .from('profiles')
          .update({'fcm_token': null}).eq('id', uid);
      await FirebaseMessaging.instance.deleteToken();
    } catch (e, st) {
      appLogger.error('FCM token clear failed', error: e, stackTrace: st);
      await errorReporter.capture(e, st,
          hint: 'NotificationService.clearToken');
    }
  }

  // ─────────────────────────── Show local notification ────────────────────────

  Future<void> showNotification(
      {required final String title, required final String body}) async {
    if (!_pushEnabled) return;
    const androidDetails = AndroidNotificationDetails(
      _kChannelId,
      _kChannelName,
      channelDescription: _kChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
    );
  }

  // ─────────────────────────── Daily reminder ──────────────────────────────────

  /// Schedules (or cancels) a daily reminder at [timeHHmm] (e.g. `'20:00'`).
  Future<void> scheduleReminder(final String timeHHmm,
      {required final bool enabled}) async {
    await _plugin.cancel(_kReminderId);
    if (!enabled || timeHHmm.isEmpty || !_pushEnabled) return;

    final parts = timeHHmm.split(':');
    if (parts.length < 2) return;
    final hour = int.tryParse(parts[0]) ?? 20;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      _kChannelId,
      _kChannelName,
      channelDescription: _kChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    try {
      await _plugin.zonedSchedule(
        _kReminderId,
        '🧠 Time to practice!',
        'Keep your streak alive — a quick quiz is waiting.',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // repeats daily
      );
    } catch (e) {
      // Fallback to inexact if exact is not permitted
      if (e.toString().contains('exact_alarms_not_permitted')) {
        await _plugin.zonedSchedule(
          _kReminderId,
          '🧠 Time to practice!',
          'Keep your streak alive — a quick quiz is waiting.',
          scheduled,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } else {
        rethrow;
      }
    }
    appLogger.info('Daily reminder scheduled', context: {'time': timeHHmm});
  }

  // ─────────────────────────── Supabase Realtime listener ─────────────────────

  /// Listens to INSERT events on the `notifications` table for the current user.
  /// Shows a local notification for each new row.
  void startRealtimeListener() {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;
    stopRealtimeListener();

    _realtimeChannel = _supabase
        .channel('notif-listener-$uid')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: uid,
          ),
          callback: (final payload) {
            if (!_pushEnabled) return;
            final row = payload.newRecord;
            final title = row['title']?.toString() ?? 'New notification';
            final body = row['body']?.toString() ?? '';
            showNotification(title: title, body: body);
          },
        )
        .subscribe();

    appLogger.info('Realtime notification listener started',
        context: {'user_id': uid});
  }

  void stopRealtimeListener() {
    if (_realtimeChannel != null) {
      _supabase.removeChannel(_realtimeChannel!);
      _realtimeChannel = null;
    }
  }

  // ─────────────────────────── Push toggle ────────────────────────────────────

  void setPushEnabled(final bool enabled) {
    _pushEnabled = enabled;
  }

  Future<bool> openSystemNotificationSettings() async {
    return openAppSettings();
  }

  bool get hasPermissionIssue =>
      initState.value == NotificationInitState.permissionDenied ||
      initState.value == NotificationInitState.tokenRegistrationFailed;
}

final notificationService = NotificationService();
