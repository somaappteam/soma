import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:soma/core/services/app_logger.dart';

Future<void> main(final List<String> args) async {
  if (args.isEmpty) {
    appLogger.info('Please provide the path to the SQL file.');
    exit(1);
  }

  final sqlFile = File(args[0]);
  if (!await sqlFile.exists()) {
    appLogger.info('SQL file not found: ${args[0]}');
    exit(1);
  }

  appLogger.info('Reading SQL from ${sqlFile.path}...');
  final sql = await sqlFile.readAsString();

  appLogger.info('Connecting to database...');
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
    await connection.execute(sql);
    appLogger.info('Success!');
  } catch (e) {
    appLogger.info('Error executing SQL: $e');
    exit(1);
  } finally {
    await connection.close();
  }
}
