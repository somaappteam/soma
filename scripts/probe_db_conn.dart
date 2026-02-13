
import 'package:postgres/postgres.dart';
import 'dart:io';

Future<void> main() async {
  final variations = [
    {
      'host': 'db.bnbjteedohflgkarfaxk.supabase.co',
      'port': 5432,
      'username': 'postgres.bnbjteedohflgkarfaxk',
    },
    {
      'host': 'db.bnbjteedohflgkarfaxk.supabase.co',
      'port': 5432,
      'username': 'postgres',
    },
    {
      'host': 'aws-0-eu-central-1.pooler.supabase.com',
      'port': 6543,
      'username': 'postgres.bnbjteedohflgkarfaxk',
    },
    {
      'host': 'aws-0-eu-central-1.pooler.supabase.com',
      'port': 5432,
      'username': 'postgres.bnbjteedohflgkarfaxk',
    }
  ];

  for (var config in variations) {
    print('Testing: $config');
    try {
      final conn = await Connection.open(
        Endpoint(
          host: config['host'] as String,
          port: config['port'] as int,
          database: 'postgres',
          username: config['username'] as String,
          password: 'M_SOMA_APP_2026',
        ),
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      print('✅ SUCCESS for $config');
      await conn.close();
      return;
    } catch (e) {
      print('❌ FAILED for $config: $e');
    }
  }
}
