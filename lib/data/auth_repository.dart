import 'package:flutter/foundation.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/session_tracker.dart';
import 'package:soma/data/app_analytics_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required final String email,
    required final String password,
    final String? username,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: kIsWeb ? null : 'soma://auth-callback',
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

  Future<void> resendSignupConfirmation({required final String email}) async {
    await _client.auth.resend(
      type: OtpType.signup,
      email: email,
      emailRedirectTo: kIsWeb ? null : 'soma://auth-callback',
    );
  }

  Future<AuthResponse> signIn({
    required final String email,
    required final String password,
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

  Future<bool> signInWithOAuth(final OAuthProvider provider) async {
    try {
      final launched = await _client.auth.signInWithOAuth(
        provider,
        redirectTo: kIsWeb ? null : 'soma://auth-callback',
      );
      await appAnalyticsRepository.track(
        'auth_oauth_started',
        metadata: {'provider': provider.name, 'launched': launched},
      );
      return launched;
    } catch (e) {
      await appAnalyticsRepository.track(
        'auth_oauth_failed',
        metadata: {'provider': provider.name, 'reason': e.toString()},
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

  Future<void> updatePassword(final String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  Future<void> resetPassword({required final String email}) async {
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

AuthRepository get authRepository => locator<AuthRepository>();
