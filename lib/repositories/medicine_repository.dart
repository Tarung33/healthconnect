import 'package:sqflite/sqflite.dart';
import '../models/medicine_model.dart';
import '../services/database_helper.dart';

/// ============================================================
/// MEDICINE REPOSITORY — Offline medicine cache
/// ============================================================

class MedicineRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  static const String tableName = 'medicine_cache';

  Future<void> cacheMedicines(List<MedicineModel> medicines) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    
    // Clear old cache and insert new
    batch.delete(tableName);
    
    for (var med in medicines) {
      batch.insert(
        tableName,
        {
          'id': med.id,
          'name': med.name,
          'genericName': med.genericName,
          'price': med.price,
          'isAvailable': med.isAvailable ? 1 : 0,
          'storeName': med.storeName,
          'distance': med.distance,
          'hasGeneric': med.hasGeneric ? 1 : 0,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
      );
    }
    
    await batch.commit(noResult: true);
  }

  Future<List<MedicineModel>> getCachedMedicines() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return MedicineModel.mockList(); // Fallback to mock if empty
    }

    return List.generate(maps.length, (i) {
      return MedicineModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        genericName: maps[i]['genericName'],
        price: maps[i]['price'],
        isAvailable: maps[i]['isAvailable'] == 1,
        storeName: maps[i]['storeName'],
        distance: maps[i]['distance'],
        hasGeneric: maps[i]['hasGeneric'] == 1,
      );
    });
  }
}
