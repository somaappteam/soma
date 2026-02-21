import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/di/locator.dart';

class ExchangeAnalyticsRepository {
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
      await _supabase.from('exchange_events').insert(payload);
    } catch (e) {
      debugPrint('[exchange_analytics_fallback] $event $metadata ($e)');
    }
  }
}

ExchangeAnalyticsRepository get exchangeAnalyticsRepository => locator<ExchangeAnalyticsRepository>();
