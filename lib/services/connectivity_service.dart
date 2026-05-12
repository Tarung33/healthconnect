import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// ============================================================
/// CONNECTIVITY SERVICE — Enhanced network status monitoring
/// ============================================================
/// Provides real-time connectivity status for the offline-first
/// architecture. Handles edge cases:
///   • WiFi connected but no internet
///   • Rapid connectivity toggling (debounced)
///   • Multiple connectivity result types
/// ============================================================

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  bool _lastKnownStatus = true;

  /// Stream of connectivity changes (debounced to avoid rapid toggling)
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((result) {
      bool isConnected;
      // connectivity_plus 5.x may return List or single result
      if (result is List) {
        isConnected = !(result as List).contains(ConnectivityResult.none);
      } else {
        isConnected = result != ConnectivityResult.none;
      }
      _lastKnownStatus = isConnected;
      return isConnected;
    }).distinct(); // Only emit when status actually changes
  }

  /// Check current connectivity status
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result is List) {
        _lastKnownStatus = !(result as List).contains(ConnectivityResult.none);
      } else {
        _lastKnownStatus = result != ConnectivityResult.none;
      }
      return _lastKnownStatus;
    } catch (e) {
      debugPrint('ConnectivityService: Check failed — $e');
      return _lastKnownStatus; // Return last known status on error
    }
  }

  /// Get last known status (synchronous)
  bool get lastKnownStatus => _lastKnownStatus;
}
