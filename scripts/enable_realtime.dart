
import 'package:postgres/postgres.dart';

Future<void> main() async {
  final endpoint = Endpoint(
    host: 'db.bnbjteedohflgkarfaxk.supabase.co',
    port: 5432,
    database: 'postgres',
    username: 'postgres.bnbjteedohflgkarfaxk',
    password: 'M_SOMA_APP_2026',
  );

  try {
    final conn = await Connection.open(endpoint, settings: const ConnectionSettings(sslMode: SslMode.require));
    print('✅ Connected to Postgres');

    // 1. Check if profiles is in publication
    final checkResult = await conn.execute(
      "SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'profiles'"
    );

    if (checkResult.isEmpty) {
      print('Profiles not in supabase_realtime. Enabling...');
      await conn.execute('ALTER PUBLICATION supabase_realtime ADD TABLE profiles');
      print('✅ Realtime enabled for profiles');
    } else {
      print('✅ Realtime already enabled for profiles');
    }

    // 2. Also check friendships and messages just in case
    for (final table in ['friendships', 'messages', 'chat_messages', 'user_sessions']) {
       final res = await conn.execute(
        "SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = '$table'"
      );
      if (res.isEmpty) {
        print('Enabling Realtime for $table...');
        await conn.execute('ALTER PUBLICATION supabase_realtime ADD TABLE $table');
        print('✅ Enabled for $table');
      }
    }

    await conn.close();
  } catch (e) {
    print('❌ FAILED: $e');
  }
}
