import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/database/database_helper.dart';
import 'package:flutter/foundation.dart';

class ContentSyncService {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;

  /// Fetches content from Supabase and updates local SQLite.
  /// Call this on app startup.
  Future<void> syncEverything() async {
    final userId = _supabase.auth.currentUser?.id;
    try {
      debugPrint("SYNC: Starting content sync...");

      await _syncCourses();
      await _syncVocabulary();
      await _syncSentences();

      if (userId != null) {
        await _syncProfile(userId);
        await _syncUserProgress(userId);
        await _syncUserStats(userId);
      }

      debugPrint("SYNC: Content sync completed successfully.");
    } catch (e) {
      debugPrint("SYNC: Error syncing content: $e");
    }
  }

  Future<void> _syncCourses() async {
    try {
      final response = await _supabase.from('courses').select();
      for (final row in response) {
        await _dbHelper.upsertCourse(row);
      }
      debugPrint("SYNC: Synced ${response.length} courses.");
    } catch (e) {
      debugPrint("SYNC: Course sync failed: $e");
    }
  }

  Future<void> _syncVocabulary() async {
    try {
      final response = await _supabase.from('vocabulary').select();
      for (final row in response) {
        await _dbHelper.upsertVocabulary(row);
      }
      debugPrint("SYNC: Synced ${response.length} vocabulary items.");
    } catch (e) {
      debugPrint("SYNC: Vocabulary sync failed: $e");
    }
  }

  Future<void> _syncSentences() async {
    try {
      final response = await _supabase.from('sentences').select();
      for (final row in response) {
        await _dbHelper.upsertSentence(row);
      }
      debugPrint("SYNC: Synced ${response.length} sentences.");
    } catch (e) {
      debugPrint("SYNC: Sentence sync failed: $e");
    }
  }

  Future<void> _syncProfile(String userId) async {
    try {
      final profileResp = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (profileResp != null) {
        await _dbHelper.upsertProfile(profileResp);
        debugPrint("SYNC: Synced profile for $userId.");
      }
    } catch (e) {
      debugPrint("SYNC: Profile sync failed: $e");
    }
  }

  Future<void> _syncUserProgress(String userId) async {
    try {
      // 1. Sync User Courses Progress
      final coursesResp = await _supabase
          .from('user_courses')
          .select()
          .eq('user_id', userId);
      
      for (final row in coursesResp) {
        await _dbHelper.upsertUserCourse(row);
      }

      // 2. Sync User Learned Items (SRS)
      final srsResp = await _supabase
          .from('user_learned_items')
          .select()
          .eq('user_id', userId);
      
      for (final row in srsResp) {
        await _dbHelper.upsertUserLearnedItem(row);
      }
      
      debugPrint("SYNC: Synced user progress for $userId.");
    } catch (e) {
      debugPrint("SYNC: User progress sync failed: $e");
    }
  }

  Future<void> _syncUserStats(String userId) async {
    try {
      final statsResp = await _supabase
          .from('user_stats')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (statsResp != null) {
        await _dbHelper.upsertUserStats(statsResp);
        debugPrint("SYNC: Synced user stats for $userId.");
      }
    } catch (e) {
      debugPrint("SYNC: User stats sync failed: $e");
    }
  }
}

final contentSyncService = ContentSyncService();
