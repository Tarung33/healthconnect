import 'package:sqflite/sqflite.dart';
import '../models/sync_queue_model.dart';
import '../services/database_helper.dart';

/// ============================================================
/// SYNC QUEUE REPOSITORY — Manages pending offline API actions
/// ============================================================

class SyncQueueRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const String tableName = 'sync_queue';

  /// Add action to queue
  Future<void> enqueue(SyncQueueModel item) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all pending actions, ordered by creation time
  Future<List<SyncQueueModel>> getPendingActions() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'createdAt ASC',
    );
    return List.generate(maps.length, (i) => SyncQueueModel.fromMap(maps[i]));
  }

  /// Remove action after successful sync
  Future<void> remove(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Increment retry count on failure
  Future<void> incrementRetry(String id, int currentCount) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      {'retryCount': currentCount + 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
