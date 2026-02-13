
import 'package:postgres/postgres.dart';
import 'dart:io';

Future<void> main() async {
  final endpoint = Endpoint(
    host: 'db.bnbjteedohflgkarfaxk.supabase.co',
    port: 5432,
    database: 'postgres',
    username: 'postgres',
    password: 'M_SOMA_APP_2026',
  );

  print('Testing connection to db.bnbjteedohflgkarfaxk.supabase.co...');
  try {
    final connection = await Connection.open(endpoint, settings: ConnectionSettings(sslMode: SslMode.require));
    print('✅ Connected successfully!');
    await connection.close();
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}
