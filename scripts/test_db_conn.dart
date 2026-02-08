
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final endpoint = Endpoint(
    host: 'db.bnbjteedohflgkarfaxk.supabase.co',
    port: 5432,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  print('Testing connection...');
  try {
    final connection = await Connection.open(endpoint, settings: ConnectionSettings(sslMode: SslMode.require));
    print('Connected successfully!');
    final result = await connection.execute('SELECT version()');
    print('PG Version: ${result.first}');
    await connection.close();
  } catch (e) {
    print('Connection failed: $e');
  }
}
