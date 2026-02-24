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

  try {
    final conn = await Connection.open(endpoint,
        settings: const ConnectionSettings(sslMode: SslMode.require));
    appLogger.info('✅ Connected to Postgres');

    // 1. Check if profiles is in publication
    final checkResult = await conn.execute(
        "SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'profiles'");

    if (checkResult.isEmpty) {
      appLogger.info('Profiles not in supabase_realtime. Enabling...');
      await conn
          .execute('ALTER PUBLICATION supabase_realtime ADD TABLE profiles');
      appLogger.info('✅ Realtime enabled for profiles');
    } else {
      appLogger.info('✅ Realtime already enabled for profiles');
    }

    // 2. Also check friendships and messages just in case
    for (final table in [
      'friendships',
      'messages',
      'chat_messages',
      'user_sessions'
    ]) {
      final res = await conn.execute(
          "SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = '$table'");
      if (res.isEmpty) {
        appLogger.info('Enabling Realtime for $table...');
        await conn
            .execute('ALTER PUBLICATION supabase_realtime ADD TABLE $table');
        appLogger.info('✅ Enabled for $table');
      }
    }

    await conn.close();
  } catch (e) {
    appLogger.info('❌ FAILED: $e');
  }
}
