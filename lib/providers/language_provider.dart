import 'package:flutter/material.dart';
import '../services/localization_service.dart';
import '../l10n/app_localizations.dart';

/// ============================================================
/// LANGUAGE PROVIDER — Language state management
/// ============================================================
/// Notifies the widget tree when language changes so the entire
/// UI rebuilds with the new language strings.
/// ============================================================

class LanguageProvider extends ChangeNotifier {
  final LocalizationService _locService = LocalizationService();

  String get currentLanguage => _locService.currentLanguage;

  /// Load saved language on app start
  Future<void> loadLanguage() async {
    await _locService.loadSavedLanguage();
    notifyListeners();
  }

  /// Change language — triggers full UI rebuild
  Future<void> changeLanguage(String languageCode) async {
    await _locService.changeLanguage(languageCode);
    notifyListeners();
  }

  /// Get available languages with their display names
  Map<String, String> get availableLanguages => AppLocalizations.languageNames;
}
