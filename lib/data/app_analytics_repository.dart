import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppAnalyticsRepository {
  final _supabase = Supabase.instance.client;

  Future<void> track(String event, {Map<String, dynamic>? metadata}) async {
    final uid = _supabase.auth.currentUser?.id;
    final payload = {
      'event_name': event,
      'user_id': uid,
      'metadata': metadata ?? <String, dynamic>{},
      'created_at': DateTime.now().toIso8601String(),
    };

    try {
      await _supabase.from('app_events').insert(payload);
    } catch (e) {
      debugPrint('[app_analytics_fallback] $event $metadata ($e)');
    }
  }
}

final appAnalyticsRepository = AppAnalyticsRepository();
