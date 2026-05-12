import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../l10n/app_localizations.dart';

/// ============================================================
/// LANGUAGE PROVIDER — Language state management
/// ============================================================
/// Notifies the widget tree when language changes so the entire
/// UI rebuilds with the new language strings.
///
/// Exposes:
///   • currentLanguage — language code (en/hi/pa)
///   • currentLocale — Locale object for Flutter delegates
///   • textDirection — LTR/RTL for Directionality widget
///   • availableLanguages — map of code → display name
/// ============================================================

class LanguageProvider extends ChangeNotifier {
  final TranslationService _translationService = TranslationService();

  /// Current language code
  String get currentLanguage => _translationService.currentLanguage;

  /// Current Flutter Locale
  Locale get currentLocale => _translationService.currentLocale;

  /// Text direction for current language (LTR / RTL)
  TextDirection get textDirection => _translationService.textDirection;

  /// Whether the current language is RTL
  bool get isRtl => _translationService.isRtl;

  /// Display name of current language in its own script
  String get currentLanguageName => _translationService.currentLanguageName;

  /// Load saved language on app start
  Future<void> loadLanguage() async {
    await _translationService.loadSavedLanguage();
    notifyListeners();
  }

  /// Auto-detect device locale and apply if supported
  Future<void> detectAndApplyDeviceLocale() async {
    await _translationService.detectAndApplyDeviceLocale();
    notifyListeners();
  }

  /// Change language — triggers full UI rebuild
  Future<void> changeLanguage(String languageCode) async {
    await _translationService.changeLanguage(languageCode);
    notifyListeners();
  }

  /// Get available languages with their display names
  Map<String, String> get availableLanguages =>
      AppLocalizations.languageNames;

  /// Get available languages with English subtitles
  Map<String, String> get languageSubtitles =>
      AppLocalizations.languageSubtitles;

  /// List of supported Locales (for MaterialApp)
  List<Locale> get supportedLocales =>
      AppLocalizations.supportedLocales.values.toList();
}
