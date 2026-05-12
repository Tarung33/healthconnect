import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ============================================================
/// CRASH-SAFE STORAGE — Resilient local persistence
/// ============================================================
/// Wraps SharedPreferences with crash-safety mechanisms:
///   • Try/catch on every operation to prevent crash propagation
///   • Write-ahead log pattern for critical data
///   • Automatic corruption detection & recovery
///   • Cached instance to reduce I/O overhead
/// ============================================================

class CrashSafeStorage {
  static final CrashSafeStorage _instance = CrashSafeStorage._internal();
  factory CrashSafeStorage() => _instance;
  CrashSafeStorage._internal();

  /// Cached SharedPreferences instance — avoids repeated async init
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  /// Initialize the storage (call once in main)
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      debugPrint('CrashSafeStorage: Initialized successfully');
    } catch (e) {
      debugPrint('CrashSafeStorage: Failed to initialize — $e');
      _isInitialized = false;
    }
  }

  /// Get the SharedPreferences instance safely
  Future<SharedPreferences?> get _safePrefs async {
    if (_isInitialized && _prefs != null) return _prefs;
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      return _prefs;
    } catch (e) {
      debugPrint('CrashSafeStorage: Cannot access prefs — $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════
  // STRING OPERATIONS
  // ═══════════════════════════════════════════════════

  Future<bool> setString(String key, String value) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return false;
      return await prefs.setString(key, value);
    } catch (e) {
      debugPrint('CrashSafeStorage: setString($key) failed — $e');
      return false;
    }
  }

  Future<String?> getString(String key, {String? fallback}) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return fallback;
      return prefs.getString(key) ?? fallback;
    } catch (e) {
      debugPrint('CrashSafeStorage: getString($key) failed — $e');
      return fallback;
    }
  }

  // ═══════════════════════════════════════════════════
  // BOOL OPERATIONS
  // ═══════════════════════════════════════════════════

  Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return false;
      return await prefs.setBool(key, value);
    } catch (e) {
      debugPrint('CrashSafeStorage: setBool($key) failed — $e');
      return false;
    }
  }

  Future<bool> getBool(String key, {bool fallback = false}) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return fallback;
      return prefs.getBool(key) ?? fallback;
    } catch (e) {
      debugPrint('CrashSafeStorage: getBool($key) failed — $e');
      return fallback;
    }
  }

  // ═══════════════════════════════════════════════════
  // INT OPERATIONS
  // ═══════════════════════════════════════════════════

  Future<bool> setInt(String key, int value) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return false;
      return await prefs.setInt(key, value);
    } catch (e) {
      debugPrint('CrashSafeStorage: setInt($key) failed — $e');
      return false;
    }
  }

  Future<int> getInt(String key, {int fallback = 0}) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return fallback;
      return prefs.getInt(key) ?? fallback;
    } catch (e) {
      debugPrint('CrashSafeStorage: getInt($key) failed — $e');
      return fallback;
    }
  }

  // ═══════════════════════════════════════════════════
  // JSON OPERATIONS — for complex data
  // ═══════════════════════════════════════════════════

  /// Save a Map as JSON string with corruption protection
  Future<bool> setJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonStr = json.encode(data);

      // Write-ahead: save backup first
      final backupKey = '_backup_$key';
      final prefs = await _safePrefs;
      if (prefs == null) return false;

      // Save backup of existing data
      final existing = prefs.getString(key);
      if (existing != null) {
        await prefs.setString(backupKey, existing);
      }

      // Write new data
      final success = await prefs.setString(key, jsonStr);

      // Clear backup on success
      if (success) {
        await prefs.remove(backupKey);
      }

      return success;
    } catch (e) {
      debugPrint('CrashSafeStorage: setJson($key) failed — $e');
      return false;
    }
  }

  /// Read a JSON map with automatic corruption recovery
  Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return null;

      final jsonStr = prefs.getString(key);
      if (jsonStr == null) return null;

      try {
        return json.decode(jsonStr) as Map<String, dynamic>;
      } catch (_) {
        // Data corrupted — try backup
        debugPrint('CrashSafeStorage: Corrupted data for $key, trying backup');
        final backup = prefs.getString('_backup_$key');
        if (backup != null) {
          try {
            final recovered = json.decode(backup) as Map<String, dynamic>;
            // Restore from backup
            await prefs.setString(key, backup);
            debugPrint('CrashSafeStorage: Recovered $key from backup');
            return recovered;
          } catch (_) {
            debugPrint('CrashSafeStorage: Backup also corrupted for $key');
          }
        }
        return null;
      }
    } catch (e) {
      debugPrint('CrashSafeStorage: getJson($key) failed — $e');
      return null;
    }
  }

  // ═══════════════════════════════════════════════════
  // UTILITY OPERATIONS
  // ═══════════════════════════════════════════════════

  /// Remove a key safely
  Future<bool> remove(String key) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return false;
      return await prefs.remove(key);
    } catch (e) {
      debugPrint('CrashSafeStorage: remove($key) failed — $e');
      return false;
    }
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return false;
      return prefs.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Clear all data safely
  Future<bool> clearAll() async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) return false;
      return await prefs.clear();
    } catch (e) {
      debugPrint('CrashSafeStorage: clearAll failed — $e');
      return false;
    }
  }

  /// Get storage health status
  Future<Map<String, dynamic>> getHealthStatus() async {
    try {
      final prefs = await _safePrefs;
      if (prefs == null) {
        return {'status': 'unavailable', 'keyCount': 0};
      }
      return {
        'status': 'healthy',
        'keyCount': prefs.getKeys().length,
        'isInitialized': _isInitialized,
      };
    } catch (e) {
      return {'status': 'error', 'error': e.toString()};
    }
  }
}
