import 'dart:io';

import 'package:soma/core/services/app_logger.dart';
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'https://bnbjteedohflgkarfaxk.supabase.co';
const String serviceRoleKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJuYmp0ZWVkb2hmbGdrYXJmYXhrIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2OTcwMDI2NCwiZXhwIjoyMDg1Mjc2MjY0fQ.jTZOgpQ7Fy1HlUT0YldRAtr6Bvwti_Al1hfaP5Bz0Nc';

Future<void> main() async {
  final client = SupabaseClient(supabaseUrl, serviceRoleKey);
  final buffer = StringBuffer();

  void log(final String msg) {
    appLogger.info(msg);
    buffer.writeln(msg);
  }

  log('--- COMPREHENSIVE SCHEMA AUDIT ---');

  // Circles
  log('\n[Circles]');
  try {
    final res = await client.from('circles').select().limit(1).maybeSingle();
    if (res != null) {
      final keys = (res).keys.toList();
      log('Existing columns: $keys');
      final expected = [
        'from_lang',
        'to_lang',
        'mode',
        'level',
        'questions_count',
        'is_locked'
      ];
      for (var col in expected) {
        if (keys.contains(col)) {
          log('✅ $col present');
        } else {
          log('❌ $col MISSING');
        }
      }
    } else {
      log('Table records empty, trying selective selection...');
      final probes = [
        'from_lang',
        'to_lang',
        'mode',
        'level',
        'questions_count',
        'is_locked'
      ];
      for (var col in probes) {
        try {
          await client.from('circles').select(col).limit(1);
          log('✅ $col present');
        } catch (e) {
          log('❌ $col MISSING');
        }
      }
    }
  } catch (e) {
    log('Error auditing circles: $e');
  }

  // Participants
  log('\n[Circle Participants]');
  try {
    final res = await client
        .from('circle_participants')
        .select()
        .limit(1)
        .maybeSingle();
    final keys = (res != null) ? (res).keys.toList() : [];
    final expected = ['role', 'is_ready', 'score', 'joined_at'];
    if (keys.isNotEmpty) {
      for (var col in expected) {
        if (keys.contains(col)) {
          log('✅ $col present');
        } else {
          log('❌ $col MISSING');
        }
      }
    } else {
      for (var col in expected) {
        try {
          await client.from('circle_participants').select(col).limit(1);
          log('✅ $col present');
        } catch (e) {
          log('❌ $col MISSING');
        }
      }
    }
  } catch (e) {
    log('Error: $e');
  }

  // New tables
  final tables = ['chat_messages', 'live_quiz_questions', 'live_quiz_answers'];
  for (var t in tables) {
    log('\n[$t]');
    try {
      await client.from(t).select().limit(1);
      log('✅ Table exists');
    } catch (e) {
      log('❌ Table MISSING: $e');
    }
  }

  log('\n--- END AUDIT ---');
  await File('audit_results.txt').writeAsString(buffer.toString());
}
