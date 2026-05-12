import 'package:sqflite/sqflite.dart';
import '../models/emr_report_model.dart';
import '../services/database_helper.dart';

/// ============================================================
/// EMR REPOSITORY — Offline temporary storage
/// ============================================================

class EmrRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const String tableName = 'doctor_emr_reports';

  Future<void> saveReport(EmrReportModel report) async {
    final db = await _dbHelper.database;
    await db.insert(
      tableName,
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<EmrReportModel>> getReports() async {
    final db = await _dbHelper.database;
    final maps = await db.query(tableName, orderBy: 'date DESC');
    return List.generate(maps.length, (i) => EmrReportModel.fromMap(maps[i]));
  }
}
