import 'dart:async';
import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';

/// ============================================================
/// CONNECTIVITY PROVIDER — Online/offline state for the UI
/// ============================================================

class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _service = ConnectivityService();
  bool _isOnline = true;
  StreamSubscription<bool>? _subscription;

  bool get isOnline => _isOnline;

  /// Start listening to connectivity changes
  void startListening() {
    _checkInitialStatus();
    _subscription = _service.onConnectivityChanged.listen((isOnline) {
      _isOnline = isOnline;
      notifyListeners();
    });
  }

  Future<void> _checkInitialStatus() async {
    _isOnline = await _service.isConnected();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
