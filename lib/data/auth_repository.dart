import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/session_tracker.dart';
import 'app_analytics_repository.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: username != null ? {'username': username} : null,
      );
      await appAnalyticsRepository.track('auth_sign_up_success');
      return response;
    } catch (e) {
      await appAnalyticsRepository.track(
        'auth_sign_up_failed',
        metadata: {'reason': e.toString()},
      );
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await appAnalyticsRepository.track('auth_sign_in_success');
      return response;
    } catch (e) {
      await appAnalyticsRepository.track(
        'auth_sign_in_failed',
        metadata: {'reason': e.toString()},
      );
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await sessionTracker.endCurrentSession();
      await _client.auth.signOut();
      await appAnalyticsRepository.track('auth_sign_out_success');
    } catch (e) {
      await appAnalyticsRepository.track(
        'auth_sign_out_failed',
        metadata: {'reason': e.toString()},
      );
      rethrow;
    }
  }


  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      await appAnalyticsRepository.track('auth_password_reset_sent');
    } catch (e) {
      await appAnalyticsRepository.track(
        'auth_password_reset_failed',
        metadata: {'reason': e.toString()},
      );
      rethrow;
    }
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
}

final authRepository = AuthRepository();
