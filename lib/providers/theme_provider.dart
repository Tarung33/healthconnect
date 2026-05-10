import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// ============================================================
/// THEME PROVIDER — Dark/Light mode state management
/// ============================================================

class ThemeProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Load saved theme preference
  Future<void> loadTheme() async {
    _isDarkMode = await _storage.isDarkMode();
    notifyListeners();
  }

  /// Toggle dark/light mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storage.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
