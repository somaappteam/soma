import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../core/database/database_helper.dart';

class OfflineQueueItem {
  final int? id;
  final String tableName;
  final String operation; // 'UPSERT', 'RPC', 'DELETE'
  final Map<String, dynamic> data;
  final DateTime createdAt;

  OfflineQueueItem({
    this.id,
    required this.tableName,
    required this.operation,
    required this.data,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'table_name': tableName,
      'operation': operation,
      'data': jsonEncode(data),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory OfflineQueueItem.fromMap(Map<String, dynamic> map) {
    return OfflineQueueItem(
      id: map['id'] as int?,
      tableName: map['table_name'] as String,
      operation: map['operation'] as String,
      data: jsonDecode(map['data'] as String) as Map<String, dynamic>,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class OfflineQueueRepository {
  final _dbHelper = DatabaseHelper.instance;

  Future<void> enqueue({
    required String tableName,
    required String operation,
    required Map<String, dynamic> data,
  }) async {
    final db = await _dbHelper.database;
    await db.insert(
      'offline_queue',
      {
        'table_name': tableName,
        'operation': operation,
        'data': jsonEncode(data),
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<OfflineQueueItem>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query('offline_queue', orderBy: 'created_at ASC');
    return maps.map(OfflineQueueItem.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await _dbHelper.database;
    await db.delete('offline_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await _dbHelper.database;
    await db.delete('offline_queue');
  }
}

final offlineQueueRepository = OfflineQueueRepository();
