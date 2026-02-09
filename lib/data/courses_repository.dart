import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/solo_course.dart';

import '../core/database/database_helper.dart';
import 'settings_repository.dart';
import 'package:flutter/foundation.dart';

class CoursesRepository {
  final _supabase = Supabase.instance.client;
  final _dbHelper = DatabaseHelper.instance;

  static const String _customCoursesKey = 'custom_courses';
  static const String _customProgressKey = 'custom_course_progress';
  static const String _removedCoursesKey = 'removed_course_ids';

  int _revision = 0;
  int get revision => _revision;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  final List<SoloCourse> _customCourses = [];
  final Set<String> _removedCourseIds = {};

  Future<void> addCustomCourse(SoloCourse course) async {
    final uid = currentUserId;
    if (uid == null) {
      if (!_customCourses.any((c) => c.id == course.id)) {
        _customCourses.add(course);
      }
      _removedCourseIds.remove(course.id);
      _revision++;
      return;
    }

    try {
      final settings = await settingsRepository.getSettings();
      final customCourses = _parseCustomCourses(settings[_customCoursesKey]);
      if (!customCourses.any((c) => c.id == course.id)) {
        customCourses.add(course);
      }

      final removedIds = _parseRemovedIds(settings[_removedCoursesKey]);
      removedIds.remove(course.id);

      final progress = _parseCustomProgress(settings[_customProgressKey]);
      progress.putIfAbsent(course.id, () => course.xp);

      await settingsRepository.updateSettings({
        _customCoursesKey: customCourses.map(_courseToJson).toList(),
        _customProgressKey: progress,
        _removedCoursesKey: removedIds.toList(),
      });
    } catch (e) {
      if (!_customCourses.any((c) => c.id == course.id)) {
        _customCourses.add(course);
      }
      _removedCourseIds.remove(course.id);
      debugPrint("Error saving custom course: $e");
    }

    _revision++;
  }

  Future<void> removeCourse(String courseId) async {
    final uid = currentUserId;
    if (uid == null) {
      _removedCourseIds.add(courseId);
      _customCourses.removeWhere((c) => c.id == courseId);
      _revision++;
      return;
    }

    try {
      final settings = await settingsRepository.getSettings();
      final customCourses = _parseCustomCourses(settings[_customCoursesKey]);
      final removedIds = _parseRemovedIds(settings[_removedCoursesKey]);
      final progress = _parseCustomProgress(settings[_customProgressKey]);

      final wasCustom = customCourses.any((c) => c.id == courseId);
      if (wasCustom) {
        customCourses.removeWhere((c) => c.id == courseId);
        progress.remove(courseId);
      } else {
        removedIds.add(courseId);
      }

      await settingsRepository.updateSettings({
        _customCoursesKey: customCourses.map(_courseToJson).toList(),
        _customProgressKey: progress,
        _removedCoursesKey: removedIds.toList(),
      });
    } catch (e) {
      _removedCourseIds.add(courseId);
      _customCourses.removeWhere((c) => c.id == courseId);
      debugPrint("Error removing course: $e");
    }

    _revision++;
  }

  /// Fetches available courses merged with user progress
  Future<List<SoloCourse>> getUserCourses() async {
    // 1. Fetch from Local DB
    List<SoloCourse> localCourses = [];
    try {
      final rows = await _dbHelper.getAllCourses();
      if (rows.isNotEmpty) {
        localCourses = rows.map((r) => SoloCourse(
          id: r['id'] as String,
          title: r['title'] as String,
          subtitle: "${r['source_lang'] ?? ''} → ${r['target_lang'] ?? ''}",
          iconUrl: r['icon'] as String? ?? '',
        )).toList();
      }
    } catch (e) {
      debugPrint("Error fetching local courses: $e");
    }

    // Removed fallback: We want empty list if user has no courses.
    // if (localCourses.isEmpty) {
    //   localCourses = [..._fallbackCourses];
    // }

    final uid = currentUserId;
    // If not logged in, return only custom courses (start empty for new guests)
    if (uid == null) {
      return [..._customCourses]
          .where((c) => !_removedCourseIds.contains(c.id))
          .toList();
    }

    try {
      final settings = await settingsRepository.getSettings();
      final customCourses = _parseCustomCourses(settings[_customCoursesKey]);
      final removedIds = _parseRemovedIds(settings[_removedCoursesKey]);
      final customProgress = _parseCustomProgress(settings[_customProgressKey]);

      final response = await _supabase
          .from('user_courses')
          .select()
          .eq('user_id', uid);
      
      final Map<String, int> xpMap = {};
      final Map<String, DateTime?> lastAccessedMap = {};
      for (final row in response) {
        final cid = row['course_id'] as String;
        final xp = row['progress_xp'] as int;
        xpMap[cid] = xp;
        final lastAccessedRaw = row['last_accessed']?.toString();
        lastAccessedMap[cid] = lastAccessedRaw != null ? DateTime.tryParse(lastAccessedRaw) : null;
        // Cache progress in SQLite
        await _dbHelper.upsertUserCourse({
          'user_id': uid,
          'course_id': cid,
          'progress_xp': xp,
          'last_accessed': row['last_accessed'],
        });
      }

      // Merge with any local-only progress if needed
      final localProgress = await _dbHelper.getUserCourses(uid);
      for (final row in localProgress) {
        final cid = row['course_id'] as String;
        if (!xpMap.containsKey(cid)) {
          xpMap[cid] = row['progress_xp'] as int;
          final lastAccessedRaw = row['last_accessed']?.toString();
          lastAccessedMap[cid] = lastAccessedRaw != null ? DateTime.tryParse(lastAccessedRaw) : null;
        }
      }

      final customIds = customCourses.map((c) => c.id).toSet();
      
      // Filter localCourses to only those the user has actually started (has XP or in xpMap)
      final startedLocalCourses = localCourses.where((c) => xpMap.containsKey(c.id)).toList();

      return [...startedLocalCourses, ...customCourses]
          .where((c) => !removedIds.contains(c.id))
          .map((c) {
            final isCustom = customIds.contains(c.id);
            final xp = isCustom ? (customProgress[c.id] ?? c.xp) : (xpMap[c.id] ?? c.xp);
            final lastAccessed = isCustom ? null : lastAccessedMap[c.id];
            return c.copyWith(xp: xp, lastAccessed: lastAccessed);
          })
          .toList();

    } catch (e) {
      // Fallback
      return [...localCourses, ..._customCourses]
          .where((c) => !_removedCourseIds.contains(c.id))
          .toList();
    }
  }

  List<SoloCourse> _parseCustomCourses(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map((item) {
          final id = item['id']?.toString() ?? '';
          if (id.isEmpty) return null;
          final title = item['title']?.toString() ?? 'Custom Course';
          final subtitle = item['subtitle']?.toString() ?? '';
          final iconUrl = (item['icon_url'] ?? item['icon'])?.toString() ?? '';
          return SoloCourse(
            id: id,
            title: title,
            subtitle: subtitle,
            iconUrl: iconUrl,
          );
        })
        .whereType<SoloCourse>()
        .toList();
  }

  Map<String, int> _parseCustomProgress(dynamic raw) {
    if (raw is! Map) return {};
    final map = <String, int>{};
    raw.forEach((key, value) {
      final id = key.toString();
      final xp = value is int ? value : int.tryParse(value?.toString() ?? '');
      if (xp != null) map[id] = xp;
    });
    return map;
  }

  Set<String> _parseRemovedIds(dynamic raw) {
    if (raw is! List) return {};
    return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toSet();
  }

  Map<String, dynamic> _courseToJson(SoloCourse course) {
    return {
      'id': course.id,
      'title': course.title,
      'subtitle': course.subtitle,
      'icon_url': course.iconUrl,
    };
  }
}

final coursesRepository = CoursesRepository();
