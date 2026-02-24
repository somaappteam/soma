import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:soma/core/services/app_logger.dart';

Future<void> main() async {
  final sqlFile =
      File('supabase/migrations/20260301113000_full_update_alignment.sql');
  if (!await sqlFile.exists()) {
    appLogger.info('SQL file not found at ${sqlFile.path}!');
    return;
  }

  appLogger.info('Reading SQL from ${sqlFile.path}...');
  final sql = await sqlFile.readAsString();

  appLogger.info('Connecting to database...');
  // Connection details from scripts/db_migration_direct.dart
  final endpoint = Endpoint(
    host: 'aws-0-eu-central-1.pooler.supabase.com',
    port: 6543,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  final connection = await Connection.open(endpoint,
      settings: ConnectionSettings(sslMode: SslMode.require));

  try {
    appLogger.info('Executing SQL...');

    // The previous script mentioned splitting by ';' if needed, but preferred one go.
    // The SQL file has BEGIN/COMMIT, so one go is best.
    await connection.execute(sql);
    appLogger.info('Migration completed successfully!');
  } catch (e) {
    appLogger.info('Error executing migration: $e');
  } finally {
    await connection.close();
  }
}
