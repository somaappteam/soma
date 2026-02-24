import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:soma/core/services/app_logger.dart';

Future<void> main() async {
  final sqlFile =
      File('supabase/migrations/20260131121000_csv_vocab_sentences.sql');
  if (!await sqlFile.exists()) {
    appLogger.info('SQL file not found!');
    return;
  }

  appLogger.info('Reading SQL from ${sqlFile.path}...');
  final sql = await sqlFile.readAsString();

  appLogger.info('Connecting to database...');
  // Connection details from user's provided pooler URL
  // postgresql://postgres.bnbjteedohflgkarfaxk:M_SOMA_APP_2026@aws-0-eu-central-1.pooler.supabase.com:6543/postgres
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
    // We execute lines one by one or as a whole if the driver supports it.
    // Since it's a script with 'begin;' and 'commit;', we should run it as a transaction or split it.
    // For simplicity, we'll try to run it in one go if possible, or split by ';'

    await connection.execute(sql);
    appLogger.info('Migration completed successfully!');
  } catch (e) {
    appLogger.info('Error executing migration: $e');
  } finally {
    await connection.close();
  }
}
