import 'package:postgres/postgres.dart';
import 'package:soma/core/services/app_logger.dart';

Future<void> main() async {
  final endpoint = Endpoint(
    host: 'db.bnbjteedohflgkarfaxk.supabase.co',
    port: 5432,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  appLogger.info('Testing connection...');
  try {
    final connection = await Connection.open(endpoint,
        settings: ConnectionSettings(sslMode: SslMode.require));
    appLogger.info('Connected successfully!');
    final result = await connection.execute('SELECT version()');
    appLogger.info('PG Version: ${result.first}');
    await connection.close();
  } catch (e) {
    appLogger.info('Connection failed: $e');
  }
}
