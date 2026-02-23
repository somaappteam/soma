import 'package:soma/core/di/locator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserReportRepository {
  final _supabase = Supabase.instance.client;

  Future<bool> hasReported(final String reportedUserId) async {
    final reporterId = _supabase.auth.currentUser?.id;
    if (reporterId == null || reportedUserId.isEmpty) return false;

    final row = await _supabase
        .from('user_reports')
        .select('id')
        .eq('reporter_id', reporterId)
        .eq('reported_user_id', reportedUserId)
        .maybeSingle();

    return row != null;
  }

  Future<void> reportUser(final String reportedUserId) async {
    final reporterId = _supabase.auth.currentUser?.id;
    if (reporterId == null || reportedUserId.isEmpty) {
      throw StateError('Cannot report user without an authenticated reporter.');
    }

    await _supabase.from('user_reports').upsert({
      'reporter_id': reporterId,
      'reported_user_id': reportedUserId,
    }, onConflict: 'reporter_id,reported_user_id');
  }

  Future<void> removeReport(final String reportedUserId) async {
    final reporterId = _supabase.auth.currentUser?.id;
    if (reporterId == null || reportedUserId.isEmpty) {
      throw StateError('Cannot remove report without an authenticated reporter.');
    }

    await _supabase
        .from('user_reports')
        .delete()
        .eq('reporter_id', reporterId)
        .eq('reported_user_id', reportedUserId);
  }
}

UserReportRepository get userReportRepository => locator<UserReportRepository>();
