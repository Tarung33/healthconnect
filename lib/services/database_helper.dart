import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// ============================================================
/// DATABASE HELPER — Crash-safe SQLite Manager
/// ============================================================
/// Handles initialization, migrations, and access to SQLite tables
/// for offline-first architecture. Includes:
///   • Transaction-safe operations
///   • Schema versioning with migrations
///   • Automatic corruption recovery
///   • WAL mode for performance
/// ============================================================

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const int _dbVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'a2z_healthconnect.db');

    try {
      return await openDatabase(
        path,
        version: _dbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      debugPrint('DatabaseHelper: Failed to open DB — $e');
      // Try to delete corrupted DB and recreate
      try {
        await deleteDatabase(path);
        return await openDatabase(
          path,
          version: _dbVersion,
          onCreate: _onCreate,
          onConfigure: _onConfigure,
        );
      } catch (e2) {
        debugPrint('DatabaseHelper: Recovery failed — $e2');
        rethrow;
      }
    }
  }

  /// Enable WAL mode for better concurrent performance
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA journal_mode=WAL');
    await db.execute('PRAGMA synchronous=NORMAL');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.transaction((txn) async {
      // 1. Health Records Table
      await txn.execute('''
        CREATE TABLE health_records(
          id TEXT PRIMARY KEY,
          type TEXT,
          title TEXT,
          doctorName TEXT,
          diagnosis TEXT,
          date TEXT,
          isSyncedOnline INTEGER DEFAULT 0,
          notes TEXT,
          createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
          updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // 2. Sync Queue Table (for offline actions)
      await txn.execute('''
        CREATE TABLE sync_queue(
          id TEXT PRIMARY KEY,
          action TEXT,
          payload TEXT,
          createdAt TEXT,
          retryCount INTEGER DEFAULT 0,
          lastAttempt TEXT
        )
      ''');

      // 3. Medicine Cache Table
      await txn.execute('''
        CREATE TABLE medicine_cache(
          id TEXT PRIMARY KEY,
          name TEXT,
          genericName TEXT,
          price REAL,
          isAvailable INTEGER,
          storeName TEXT,
          distance TEXT,
          hasGeneric INTEGER,
          lastUpdated TEXT
        )
      ''');

      // 4. AI Symptom Reports Table
      await txn.execute('''
        CREATE TABLE ai_reports(
          id TEXT PRIMARY KEY,
          symptoms TEXT,
          result TEXT,
          date TEXT,
          isSyncedOnline INTEGER DEFAULT 0
        )
      ''');

      // 5. Doctor EMR Reports Table
      await txn.execute('''
        CREATE TABLE doctor_emr_reports(
          id TEXT PRIMARY KEY,
          patientName TEXT,
          symptoms TEXT,
          diagnosis TEXT,
          medicines TEXT,
          followUpAdvice TEXT,
          date TEXT,
          isApproved INTEGER DEFAULT 0
        )
      ''');

      // 6. Create indexes for common queries
      await txn.execute('CREATE INDEX idx_records_date ON health_records(date)');
      await txn.execute('CREATE INDEX idx_records_type ON health_records(type)');
      await txn.execute('CREATE INDEX idx_sync_retry ON sync_queue(retryCount)');
      await txn.execute('CREATE INDEX idx_medicine_name ON medicine_cache(name)');
    });
  }

  /// Handle schema migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('DatabaseHelper: Upgrading from v$oldVersion to v$newVersion');

    if (oldVersion < 2) {
      // v2: Add timestamp columns and indexes
      try {
        await db.execute('ALTER TABLE health_records ADD COLUMN createdAt TEXT DEFAULT CURRENT_TIMESTAMP');
        await db.execute('ALTER TABLE health_records ADD COLUMN updatedAt TEXT DEFAULT CURRENT_TIMESTAMP');
        await db.execute('ALTER TABLE sync_queue ADD COLUMN lastAttempt TEXT');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_records_date ON health_records(date)');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_records_type ON health_records(type)');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_sync_retry ON sync_queue(retryCount)');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_medicine_name ON medicine_cache(name)');
      } catch (e) {
        debugPrint('DatabaseHelper: Migration v2 partial failure — $e');
      }
    }
  }

  /// Clear all data safely using transactions
  Future<void> clearAllData() async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete('health_records');
        await txn.delete('sync_queue');
        await txn.delete('medicine_cache');
        await txn.delete('ai_reports');
      });
    } catch (e) {
      debugPrint('DatabaseHelper: clearAllData failed — $e');
    }
  }

  /// Get database size information
  Future<Map<String, int>> getTableCounts() async {
    try {
      final db = await database;
      final records = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM health_records')) ?? 0;
      final queue = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM sync_queue')) ?? 0;
      final medicines = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM medicine_cache')) ?? 0;
      final reports = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM ai_reports')) ?? 0;
      return {
        'health_records': records,
        'sync_queue': queue,
        'medicine_cache': medicines,
        'ai_reports': reports,
      };
    } catch (e) {
      return {};
    }
  }

  /// Close database connection
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
