import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// ============================================================
/// CONNECTIVITY SERVICE — Network status monitoring
/// ============================================================
/// Provides real-time connectivity status for the offline-first
/// architecture. UI components listen to this to show/hide the
/// offline banner.
/// ============================================================

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      // connectivity_plus returns List<ConnectivityResult>
      return results.any((r) => r != ConnectivityResult.none);
    });
  }

  /// Check current connectivity status
  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
