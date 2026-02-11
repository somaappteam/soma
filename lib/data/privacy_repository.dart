import 'package:supabase_flutter/supabase_flutter.dart';

class PrivacyRepository {
  final _supabase = Supabase.instance.client;

  Future<void> requestAccountDeletion() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) throw StateError('Not authenticated');

    final now = DateTime.now().toUtc().toIso8601String();
    await _supabase.from('account_deletion_requests').upsert({
      'user_id': uid,
      'status': 'pending',
      'requested_at': now,
    }, onConflict: 'user_id');
  }
}

final privacyRepository = PrivacyRepository();
