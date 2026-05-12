import 'package:sqflite/sqflite.dart';
import '../models/health_record_model.dart';
import '../services/database_helper.dart';

/// ============================================================
/// HEALTH RECORD REPOSITORY — Offline-first storage
/// ============================================================

class HealthRecordRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const String tableName = 'health_records';

  /// Get all records ordered by date descending
  Future<List<HealthRecordModel>> getAllRecords() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'date DESC',
    );

    if (maps.isEmpty) {
      // For demo purposes, if DB is empty, populate with mock data
      final mocks = HealthRecordModel.mockList();
      for (var mock in mocks) {
        await insertRecord(mock);
      }
      return mocks;
    }

    return List.generate(maps.length, (i) {
      return HealthRecordModel.fromJson({
        ...maps[i],
        'isSyncedOnline': maps[i]['isSyncedOnline'] == 1,
      });
    });
  }

  /// Insert a new record
  Future<void> insertRecord(HealthRecordModel record) async {
    final db = await _dbHelper.database;
    final data = record.toJson();
    data['isSyncedOnline'] = data['isSyncedOnline'] ? 1 : 0;
    
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update sync status
  Future<void> updateSyncStatus(String id, bool isSynced) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      {'isSyncedOnline': isSynced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get unsynced records
  Future<List<HealthRecordModel>> getUnsyncedRecords() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'isSyncedOnline = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (i) {
      return HealthRecordModel.fromJson({
        ...maps[i],
        'isSyncedOnline': false,
      });
    });
  }
}
