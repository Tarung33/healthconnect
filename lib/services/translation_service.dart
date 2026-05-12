import 'package:flutter/material.dart';
import 'storage_service.dart';
import '../l10n/app_localizations.dart';

/// ============================================================
/// TRANSLATION SERVICE — Reusable translation utility
/// ============================================================
/// Provides a complete translation API with:
///   • Language switching with persistence
///   • Device locale detection
///   • Translation helpers (parameterized, plural)
///   • RTL support detection
///   • Locale-aware formatting hints
///   • Offline-first — all translations are embedded
/// ============================================================

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final StorageService _storage = StorageService();

  // ── Core Getters ──

  /// Current language code (e.g., 'en', 'hi', 'pa')
  String get currentLanguage => AppLocalizations.currentLanguage;

  /// Current locale (e.g., Locale('hi', 'IN'))
  Locale get currentLocale => AppLocalizations.currentLocale;

  /// Human-readable name of the current language in its script
  String get currentLanguageName =>
      AppLocalizations.languageNames[currentLanguage] ?? 'English';

  /// Text direction for the current language
  TextDirection get textDirection => AppLocalizations.currentTextDirection;

  /// Whether the current language is RTL
  bool get isRtl => AppLocalizations.isRtl;

  /// All available languages with display names
  Map<String, String> get availableLanguages => AppLocalizations.languageNames;

  /// Language subtitles (English names)
  Map<String, String> get languageSubtitles =>
      AppLocalizations.languageSubtitles;

  // ── Lifecycle ──

  /// Initialize — load saved language preference.
  /// Called once at app startup.
  Future<void> initialize() async {
    final savedLang = await _storage.getLanguage();
    AppLocalizations.setLanguage(savedLang);
  }

  /// Load saved language preference (alias for initialize)
  Future<void> loadSavedLanguage() async {
    await initialize();
  }

  /// Try to detect and apply device locale if no language was previously saved.
  /// Returns the detected/applied language code.
  Future<String> detectAndApplyDeviceLocale() async {
    final savedLang = await _storage.getLanguage();

    // If user already selected a language, respect it
    if (savedLang != 'en') {
      AppLocalizations.setLanguage(savedLang);
      return savedLang;
    }

    // Try to detect from device locale
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final deviceLangCode = deviceLocale.languageCode;

    if (AppLocalizations.isSupported(deviceLangCode)) {
      AppLocalizations.setLanguage(deviceLangCode);
      await _storage.setLanguage(deviceLangCode);
      return deviceLangCode;
    }

    return 'en';
  }

  // ── Language Switching ──

  /// Change language and persist the selection.
  /// Does NOT require app restart — the widget tree rebuilds
  /// via LanguageProvider.notifyListeners().
  Future<void> changeLanguage(String languageCode) async {
    if (!AppLocalizations.isSupported(languageCode)) return;
    AppLocalizations.setLanguage(languageCode);
    await _storage.setLanguage(languageCode);
  }

  // ── Translation API ──

  /// Simple key-based translation
  String translate(String key) => AppLocalizations.translate(key);

  /// Translation with named parameters
  /// Example: translateParams('welcome_user', {'name': 'Rajesh'})
  String translateParams(String key, Map<String, String> params) =>
      AppLocalizations.translateWithParams(key, params);

  /// Plural-aware translation
  /// Example: translatePlural('items', 5)
  String translatePlural(String key, int count) =>
      AppLocalizations.translatePlural(key, count);

  /// Get translation for a specific language (useful for comparisons)
  String translateFor(String key, String languageCode) =>
      AppLocalizations.translateFor(key, languageCode);

  // ── Validation & Debug ──

  /// Get list of keys missing from a language (compared to English)
  List<String> getMissingKeys(String languageCode) =>
      AppLocalizations.missingKeys(languageCode);

  /// Get total translation count for a language
  int getTranslationCount(String languageCode) =>
      AppLocalizations.translationCount(languageCode);

  /// Check translation completeness as a percentage
  double getCompleteness(String languageCode) {
    final total = AppLocalizations.translationCount('en');
    if (total == 0) return 100.0;
    final langCount = AppLocalizations.translationCount(languageCode);
    return (langCount / total * 100).clamp(0.0, 100.0);
  }
}
