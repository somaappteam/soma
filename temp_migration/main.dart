import 'dart:io';
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final logFile = File('migration_error.log');

  try {
    final sqlFile = File(
        'c:/Users/amosl/soma app/supabase/migrations/20260301113000_full_update_alignment.sql');
    if (!await sqlFile.exists()) {
      print('SQL file not found at ${sqlFile.path}!');
      return;
    }

    print('Reading SQL from ${sqlFile.path}...');
    final sql = await sqlFile.readAsString();

    print('Connecting to database (Pooler 6543)...');
    // Using Transaction Pooler port 6543 as per original script
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
      print('Executing SQL...');
      await connection.execute(sql);
      print('Migration completed successfully!');
    } catch (e) {
      print('Error executing migration: $e');
      await logFile.writeAsString('Error executing migration: $e\n');
      rethrow;
    } finally {
      await connection.close();
    }
  } catch (e, stack) {
    print('Fatal error: $e');
    await logFile.writeAsString('Fatal error: $e\nStack: $stack\n',
        mode: FileMode.append);
    exit(1);
  }
}
