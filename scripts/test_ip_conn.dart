
import 'package:postgres/postgres.dart';

Future<void> main() async {
  // EU Central 1 IP from ping
  final ip = '18.198.30.239'; 
  final endpoint = Endpoint(
    host: ip,
    port: 6543,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  print('Testing connection to IP $ip (port 6543)...');
  try {
    final connection = await Connection.open(endpoint, settings: ConnectionSettings(sslMode: SslMode.require));
    print('✅ Connected successfully to IP!');
    await connection.close();
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}
