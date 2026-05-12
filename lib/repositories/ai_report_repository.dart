import 'package:sqflite/sqflite.dart';
import '../services/database_helper.dart';

/// ============================================================
/// AI REPORT REPOSITORY — Offline AI symptom checking logs
/// ============================================================

class AiReportRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const String tableName = 'ai_reports';

  Future<void> saveReport({
    required String id,
    required String symptoms,
    required String result,
  }) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      {
        'id': id,
        'symptoms': symptoms,
        'result': result,
        'date': DateTime.now().toIso8601String(),
        'isSyncedOnline': 0, // 0 for offline until synced
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSyncStatus(String id, bool isSynced) async {
    final db = await _dbHelper.database;
    await db.update(
      tableName,
      {'isSyncedOnline': isSynced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
