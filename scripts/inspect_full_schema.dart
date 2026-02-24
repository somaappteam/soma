import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:soma/core/services/app_logger.dart';

Future<void> main() async {
  final endpoint = Endpoint(
    host: 'aws-0-us-west-1.pooler.supabase.com',
    port: 6543,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  final conn = await Connection.open(endpoint,
      settings: const ConnectionSettings(sslMode: SslMode.require));

  appLogger.info('--- SUPABASE SCHEMA DUMP ---');

  final tables = [
    'profiles',
    'friendships',
    'messages',
    'circles',
    'circle_participants',
    'vocabulary',
    'sentences',
    'user_courses',
    'courses',
    'user_learned_items',
    'chat_messages',
    'user_stats',
    'achievements',
    'user_achievements',
    'notifications',
    'user_sessions',
    'leaderboard',
    'concepts'
  ];

  final result = await conn
      .execute('SELECT table_name, column_name, data_type, is_nullable '
          'FROM information_schema.columns '
          "WHERE table_schema = 'public' "
          'ORDER BY table_name, ordinal_position');

  final buffer = StringBuffer();
  buffer.writeln('--- FULL SCHEMA INSPECTION ---');

  for (final row in result) {
    final tableName = row[0] as String;
    final columnName = row[1] as String;
    final dataType = row[2] as String;

    if (tables.contains(tableName)) {
      final line = '[$tableName] $columnName ($dataType)';
      appLogger.info(line);
      buffer.writeln(line);
    }
  }

  await conn.close();
  await File('full_schema_dump.txt').writeAsString(buffer.toString());
  appLogger.info('\nDump saved to full_schema_dump.txt');
}
