import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:soma/core/database/database_helper.dart';
import 'package:soma/core/di/locator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  factory OfflineQueueItem.fromMap(final Map<String, dynamic> map) {
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
  final _supabase = Supabase.instance.client;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isDraining = false;

  // ─────────────────────────── Enqueue ────────────────────────────────────────

  Future<void> enqueue({
    required final String tableName,
    required final String operation,
    required final Map<String, dynamic> data,
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

  // ─────────────────────────── Read / Delete ───────────────────────────────────

  Future<List<OfflineQueueItem>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query('offline_queue', orderBy: 'created_at ASC');
    return maps.map(OfflineQueueItem.fromMap).toList();
  }

  Future<void> delete(final int id) async {
    final db = await _dbHelper.database;
    await db.delete('offline_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clear() async {
    final db = await _dbHelper.database;
    await db.delete('offline_queue');
  }

  // ─────────────────────────── Drain ──────────────────────────────────────────

  /// Replays all queued items to Supabase in order.
  /// Items that succeed are deleted; failures stay in the queue for next retry.
  Future<void> drain() async {
    if (_isDraining) return;
    _isDraining = true;
    try {
      final items = await getAll();
      if (items.isEmpty) return;
      debugPrint('OfflineQueue: draining ${items.length} item(s)…');

      for (final item in items) {
        try {
          await _replay(item);
          if (item.id != null) await delete(item.id!);
          debugPrint('OfflineQueue: replayed ${item.operation} on ${item.tableName}');
        } catch (e) {
          debugPrint('OfflineQueue: replay failed for ${item.tableName} – $e (kept in queue)');
        }
      }
    } finally {
      _isDraining = false;
    }
  }

  Future<void> _replay(final OfflineQueueItem item) async {
    switch (item.operation) {
      case 'UPSERT':
        await _supabase.from(item.tableName).upsert(item.data);
      case 'DELETE':
        final id = item.data['id'];
        if (id != null) {
          await _supabase.from(item.tableName).delete().eq('id', id);
        }
      default:
        debugPrint('OfflineQueue: unknown operation "${item.operation}" — skipping');
    }
  }

  // ─────────────────────────── Connectivity listener ──────────────────────────

  /// Subscribes to network changes. Call once from app init.
  /// Automatically drains the queue whenever the device goes back online.
  void startListening() {
    _connectivitySub?.cancel();
    _connectivitySub = Connectivity()
        .onConnectivityChanged
        .listen((final results) {
      final isOnline = results.any((final r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet);
      if (isOnline) {
        debugPrint('OfflineQueue: network back online — draining queue…');
        drain();
      }
    });

    // Also drain immediately in case we're already online at startup.
    Connectivity().checkConnectivity().then((final results) {
      final isOnline = results.any((final r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet);
      if (isOnline) drain();
    });
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}

OfflineQueueRepository get offlineQueueRepository => locator<OfflineQueueRepository>();
