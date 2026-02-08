
import 'dart:io';
import 'package:postgres/postgres.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Please provide the path to the SQL file.');
    exit(1);
  }

  final sqlFile = File(args[0]);
  if (!await sqlFile.exists()) {
    print('SQL file not found: ${args[0]}');
    exit(1);
  }

  print('Reading SQL from ${sqlFile.path}...');
  final sql = await sqlFile.readAsString();

  print('Connecting to database...');
  final endpoint = Endpoint(
    host: 'aws-0-eu-central-1.pooler.supabase.com',
    port: 6543,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  final connection = await Connection.open(endpoint, settings: ConnectionSettings(sslMode: SslMode.require));

  try {
    print('Executing SQL...');
    await connection.execute(sql);
    print('Success!');
  } catch (e) {
    print('Error executing SQL: $e');
    exit(1);
  } finally {
    await connection.close();
  }
}
