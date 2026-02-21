import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('soma_local.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 7,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _createUserTables(db);
    }
    if (oldVersion < 4) {
      try {
        await db.execute('ALTER TABLE sentences ADD COLUMN created_at TEXT');
      } catch (_) {}
    }
    if (oldVersion < 5) {
      await _createOfflineQueueTable(db);
    }
    if (oldVersion < 6) {
      // Recreate vocabulary and sentences tables for new schema
      await db.execute('DROP TABLE IF EXISTS vocabulary');
      await db.execute('DROP TABLE IF EXISTS sentences');
      await _createContentTables(db);
    }
    if (oldVersion < 7) {
      // Add SM-2 ease_factor column. Default 2.5 matches SM-2 spec.
      try {
        await db.execute(
          'ALTER TABLE user_learned_items ADD COLUMN ease_factor REAL DEFAULT 2.5',
        );
      } catch (_) {}
    }
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';

    // Courses Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS courses (
        id $idType,
        title $textType,
        source_lang $textType,
        target_lang $textType,
        icon $textType
      )
    ''');

    await _createContentTables(db);
    await _createUserTables(db);
    await _createOfflineQueueTable(db);
  }

  Future<void> _createContentTables(Database db) async {
    // Vocabulary Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS vocabulary (
        vocabulary_id TEXT PRIMARY KEY,
        concept_id INTEGER,
        lang_code TEXT,
        word TEXT,
        article TEXT,
        pronunciation TEXT,
        level TEXT,
        created_at TEXT
      )
    ''');

    // Sentences Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS sentences (
        sentence_id TEXT PRIMARY KEY,
        concept_id INTEGER,
        lang_code TEXT,
        sentence TEXT,
        pronunciation TEXT,
        level TEXT,
        created_at TEXT
      )
    ''');
  }

  Future<void> _createUserTables(Database db) async {
    // SRS Progress Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_learned_items (
        user_id TEXT,
        course_id TEXT,
        concept_id INTEGER,
        interval_days INTEGER,
        ease_factor REAL DEFAULT 2.5,
        due_at TEXT,
        PRIMARY KEY (user_id, course_id, concept_id)
      )
    ''');

    // User Course Progress Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_courses (
        user_id TEXT,
        course_id TEXT,
        progress_xp INTEGER,
        last_accessed TEXT,
        PRIMARY KEY (user_id, course_id)
      )
    ''');

    // User Stats Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_stats (
        user_id TEXT PRIMARY KEY,
        total_wins INTEGER,
        streak_days INTEGER,
        longest_streak INTEGER,
        last_active_date TEXT,
        total_quizzes INTEGER,
        total_correct INTEGER,
        total_questions INTEGER,
        perfect_quizzes INTEGER,
        circles_joined INTEGER,
        updated_at TEXT
      )
    ''');

    // Profiles Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS profiles (
        id TEXT PRIMARY KEY,
        display_name TEXT,
        username TEXT,
        bio TEXT,
        location TEXT,
        daily_goal_minutes INTEGER,
        total_xp INTEGER,
        avatar_url TEXT,
        updated_at TEXT
      )
    ''');
  }

  Future<void> _createOfflineQueueTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS offline_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        table_name TEXT NOT NULL,
        operation TEXT NOT NULL,
        data TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  // --- Content Sync Methods ---
  
  Future<void> upsertCourse(Map<String, dynamic> course) async {
    final db = await instance.database;
    await db.insert(
      'courses',
      {
        'id': course['id'],
        'title': course['title'],
        'source_lang': course['source_lang'],
        'target_lang': course['target_lang'],
        'icon': course['icon_url'] ?? '',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertVocabulary(Map<String, dynamic> vocab) async {
    final db = await instance.database;
    await db.insert(
      'vocabulary',
      {
        'vocabulary_id': vocab['vocabulary_id'].toString(),
        'concept_id': vocab['concept_id'],
        'lang_code': vocab['lang_code'], // Was 'lang'
        'word': vocab['word'],
        'article': vocab['article'],
        'pronunciation': vocab['pronunciation'], // Replaced romanization/pinyin/transliteration
        'level': vocab['level'],
        'created_at': vocab['created_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertSentence(Map<String, dynamic> sentence) async {
    final db = await instance.database;
    await db.insert(
      'sentences',
      {
        'sentence_id': sentence['sentence_id'].toString(),
        'concept_id': sentence['concept_id'],
        'lang_code': sentence['lang_code'],
        'sentence': sentence['sentence'],
        'pronunciation': sentence['pronunciation'], // Replaced romanization/pinyin/transliteration
        'level': sentence['level'],
        'created_at': sentence['created_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllCourses() async {
    final db = await instance.database;
    return await db.query('courses');
  }

  Future<List<Map<String, dynamic>>> getVocabularyByLang(String langCode) async {
    final db = await instance.database;
    return await db.query('vocabulary', where: 'lang_code = ?', whereArgs: [langCode]);
  }

  Future<List<Map<String, dynamic>>> getSentencesByLang(String langCode) async {
    final db = await instance.database;
    return await db.query('sentences', where: 'lang_code = ?', whereArgs: [langCode]);
  }

  Future<void> upsertUserLearnedItem(Map<String, dynamic> item) async {
    final db = await instance.database;
    await db.insert(
      'user_learned_items',
      {
        'user_id': item['user_id'],
        'course_id': item['course_id'],
        'concept_id': item['concept_id'],
        'interval_days': item['interval_days'],
        'ease_factor': item['ease_factor'] ?? 2.5,
        'due_at': item['due_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> upsertUserCourse(Map<String, dynamic> course) async {
    final db = await instance.database;
    await db.insert(
      'user_courses',
      {
        'user_id': course['user_id'],
        'course_id': course['course_id'],
        'progress_xp': course['progress_xp'],
        'last_accessed': course['last_accessed'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserLearnedItems(String userId, String courseId) async {
    final db = await instance.database;
    return await db.query(
      'user_learned_items',
      where: 'user_id = ? AND course_id = ?',
      whereArgs: [userId, courseId],
    );
  }

  Future<List<Map<String, dynamic>>> getUserCourses(String userId) async {
    final db = await instance.database;
    return await db.query(
      'user_courses',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> upsertUserStats(Map<String, dynamic> stats) async {
    final db = await instance.database;
    await db.insert(
      'user_stats',
      {
        'user_id': stats['user_id'],
        'total_wins': stats['total_wins'],
        'streak_days': stats['streak_days'],
        'longest_streak': stats['longest_streak'],
        'last_active_date': stats['last_active_date'],
        'total_quizzes': stats['total_quizzes'],
        'total_correct': stats['total_correct'],
        'total_questions': stats['total_questions'],
        'perfect_quizzes': stats['perfect_quizzes'],
        'circles_joined': stats['circles_joined'],
        'updated_at': stats['updated_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserStats(String userId) async {
    final db = await instance.database;
    final results = await db.query(
      'user_stats',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (results.isEmpty) return null;
    return results.first;
  }

  Future<void> upsertProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    await db.insert(
      'profiles',
      {
        'id': profile['id'],
        'display_name': profile['display_name'],
        'username': profile['username'],
        'bio': profile['bio'],
        'location': profile['location'],
        'daily_goal_minutes': profile['daily_goal_minutes'],
        'total_xp': profile['total_xp'],
        'avatar_url': profile['avatar_url'],
        'updated_at': profile['updated_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final db = await instance.database;
    final results = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (results.isEmpty) return null;
    return results.first;
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
