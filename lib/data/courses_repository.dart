import 'dart:async';

import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/di/locator.dart';
import 'package:soma/core/services/app_logger.dart';
import 'package:soma/data/languages.dart';
import 'package:soma/data/settings_repository.dart';
import 'package:soma/models/solo_course.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  static final Map<String, String> _languageNamesByCode = {
    for (final language in kLanguages)
      language.code.toLowerCase(): language.name,
  };

  Future<void> addCustomCourse(final SoloCourse course) async {
    final uid = currentUserId;
    if (uid == null) {
      if (!_customCourses.any((final c) => _isSameCourse(c, course))) {
        _customCourses.add(course);
      }
      _removedCourseIds.remove(course.id);
      _revision++;
      return;
    }

    try {
      final settings = await settingsRepository.getSettings();
      final customCourses = _parseCustomCourses(settings[_customCoursesKey]);
      if (!customCourses.any((final c) => _isSameCourse(c, course))) {
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
      if (!_customCourses.any((final c) => _isSameCourse(c, course))) {
        _customCourses.add(course);
      }
      _removedCourseIds.remove(course.id);
      appLogger.debug('Error saving custom course: $e');
    }

    _revision++;
  }

  Future<void> removeCourse(final String courseId) async {
    final uid = currentUserId;
    if (uid == null) {
      _removedCourseIds.add(courseId);
      _customCourses.removeWhere((final c) => c.id == courseId);
      _revision++;
      return;
    }

    try {
      final settings = await settingsRepository.getSettings();
      final customCourses = _parseCustomCourses(settings[_customCoursesKey]);
      final removedIds = _parseRemovedIds(settings[_removedCoursesKey]);
      final progress = _parseCustomProgress(settings[_customProgressKey]);

      final wasCustom = customCourses.any((final c) => c.id == courseId);
      if (wasCustom) {
        customCourses.removeWhere((final c) => c.id == courseId);
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
      _customCourses.removeWhere((final c) => c.id == courseId);
      appLogger.debug('Error removing course: $e');
    }

    _revision++;
  }

  Stream<List<SoloCourse>> getUserCoursesStream() {
    final uid = currentUserId;
    if (uid == null) {
      return Stream.fromFuture(getUserCourses());
    }

    final controller = StreamController<List<SoloCourse>>();

    // Initial fetch
    getUserCourses().then((final c) {
      if (!controller.isClosed) controller.add(c);
    });

    // Listen to user_courses (progress) AND profiles (settings/custom courses)
    final s1 = _supabase
        .from('user_courses')
        .stream(primaryKey: ['id']).eq('user_id', uid);
    final s2 =
        _supabase.from('profiles').stream(primaryKey: ['id']).eq('id', uid);

    final sub1 = s1.listen((final _) async {
      if (!controller.isClosed) controller.add(await getUserCourses());
    });
    final sub2 = s2.listen((final _) async {
      if (!controller.isClosed) controller.add(await getUserCourses());
    });

    controller.onCancel = () async {
      await sub1.cancel();
      await sub2.cancel();
    };

    return controller.stream;
  }

  /// Fetches available courses merged with user progress
  Future<List<SoloCourse>> getUserCourses() async {
    // 1. Fetch from Local DB
    List<SoloCourse> localCourses = [];
    try {
      final rows = await _dbHelper.getAllCourses();
      if (rows.isNotEmpty) {
        localCourses = rows
            .map((final r) => SoloCourse(
                  id: r['id'] as String,
                  title: r['title'] as String,
                  subtitle:
                      "${_languageLabel(r['source_lang'])} → ${_languageLabel(r['target_lang'])}",
                  iconUrl: r['icon'] as String? ?? '',
                ))
            .toList();
      }
    } catch (e) {
      appLogger.debug('Error fetching local courses: $e');
    }

    // Removed fallback: We want empty list if user has no courses.
    // if (localCourses.isEmpty) {
    //   localCourses = [..._fallbackCourses];
    // }

    final uid = currentUserId;
    // If not logged in, return only custom courses (start empty for new guests)
    if (uid == null) {
      return [..._customCourses]
          .where((final c) => !_removedCourseIds.contains(c.id))
          .toList();
    }

    try {
      final settings = await settingsRepository.getSettings();
      final customCourses = _parseCustomCourses(settings[_customCoursesKey]);
      final removedIds = _parseRemovedIds(settings[_removedCoursesKey]);
      final customProgress = _parseCustomProgress(settings[_customProgressKey]);

      final response =
          await _supabase.from('user_courses').select().eq('user_id', uid);

      final Map<String, int> xpMap = {};
      final Map<String, DateTime?> lastAccessedMap = {};
      for (final row in response) {
        final cid = row['course_id'] as String;
        final xp = row['progress_xp'] as int;
        xpMap[cid] = xp;
        final lastAccessedRaw = row['last_accessed']?.toString();
        lastAccessedMap[cid] =
            lastAccessedRaw != null ? DateTime.tryParse(lastAccessedRaw) : null;
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
          lastAccessedMap[cid] = lastAccessedRaw != null
              ? DateTime.tryParse(lastAccessedRaw)
              : null;
        }
      }

      final customIds = customCourses.map((final c) => c.id).toSet();

      // Filter localCourses to only those the user has actually started (has XP or in xpMap)
      final startedLocalCourses = localCourses.where((final c) {
        if (!xpMap.containsKey(c.id)) return false;
        final xp = xpMap[c.id] ?? 0;
        final lastAccessed = lastAccessedMap[c.id];
        return xp > 0 || lastAccessed != null;
      }).toList();

      final mergedCourses = _mergeUniqueCourses([
        ...startedLocalCourses,
        ...customCourses,
      ]);

      return mergedCourses
          .where((final c) => !removedIds.contains(c.id))
          .map((final c) {
        final isCustom = customIds.contains(c.id);
        final xp =
            isCustom ? (customProgress[c.id] ?? c.xp) : (xpMap[c.id] ?? c.xp);
        final lastAccessed = isCustom ? null : lastAccessedMap[c.id];
        return c.copyWith(xp: xp, lastAccessed: lastAccessed);
      }).toList();
    } catch (e) {
      // Fallback
      return _mergeUniqueCourses([...localCourses, ..._customCourses])
          .where((final c) => !_removedCourseIds.contains(c.id))
          .toList();
    }
  }

  List<SoloCourse> _mergeUniqueCourses(final List<SoloCourse> courses) {
    final unique = <SoloCourse>[];
    for (final course in courses) {
      if (!unique.any((final existing) => _isSameCourse(existing, course))) {
        unique.add(course);
      }
    }
    return unique;
  }

  bool _isSameCourse(final SoloCourse a, final SoloCourse b) {
    if (a.id == b.id) return true;
    final aPair = _coursePairKey(a);
    final bPair = _coursePairKey(b);
    return aPair != null && aPair == bPair;
  }

  String? _coursePairKey(final SoloCourse course) {
    final idMatch = RegExp(r'^solo_([a-z]{2,})_([a-z]{2,})(?:_\d+)?$')
        .firstMatch(course.id.toLowerCase());
    if (idMatch != null) {
      return '${idMatch.group(1)}->${idMatch.group(2)}';
    }

    final subtitleMatch =
        RegExp(r'^\s*(.*?)\s*→\s*(.*?)\s*$').firstMatch(course.subtitle);
    if (subtitleMatch != null) {
      final src = subtitleMatch.group(1)?.trim().toLowerCase();
      final dst = subtitleMatch.group(2)?.trim().toLowerCase();
      if ((src ?? '').isNotEmpty && (dst ?? '').isNotEmpty) {
        return '$src->$dst';
      }
    }

    return null;
  }

  static String _languageLabel(final dynamic value) {
    final raw = value?.toString().trim() ?? '';
    if (raw.isEmpty) return '';
    return _languageNamesByCode[raw.toLowerCase()] ?? raw;
  }

  List<SoloCourse> _parseCustomCourses(final dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((final item) => Map<String, dynamic>.from(item))
        .map((final item) {
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

  Map<String, int> _parseCustomProgress(final dynamic raw) {
    if (raw is! Map) return {};
    final map = <String, int>{};
    raw.forEach((final key, final value) {
      final id = key.toString();
      final xp = value is int ? value : int.tryParse(value?.toString() ?? '');
      if (xp != null) map[id] = xp;
    });
    return map;
  }

  Set<String> _parseRemovedIds(final dynamic raw) {
    if (raw is! List) return {};
    return raw
        .map((final e) => e.toString())
        .where((final e) => e.isNotEmpty)
        .toSet();
  }

  Map<String, dynamic> _courseToJson(final SoloCourse course) {
    return {
      'id': course.id,
      'title': course.title,
      'subtitle': course.subtitle,
      'icon_url': course.iconUrl,
    };
  }
}

CoursesRepository get coursesRepository => locator<CoursesRepository>();
