import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExchangeAnalyticsRepository {
  final _supabase = Supabase.instance.client;

  Future<void> track(final String event,
      {final Map<String, dynamic>? metadata}) async {
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
      appLogger.debug('[exchange_analytics_fallback] $event $metadata ($e)');
    }
  }
}

ExchangeAnalyticsRepository get exchangeAnalyticsRepository =>
    locator<ExchangeAnalyticsRepository>();
