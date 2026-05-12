import 'package:flutter/material.dart';
import 'en.dart';
import 'hi.dart';
import 'kn.dart';
import 'pa.dart';

/// ============================================================
/// APP LOCALIZATIONS — Complete multilingual translation system
/// ============================================================
/// Lightweight key-based localization system supporting:
///   • English (en), Hindi (hi), Punjabi (pa)
///   • Dynamic language switching without app restart
///   • Parameterized translations with interpolation
///   • RTL readiness for future language expansion
///   • Fallback chain: current → English → raw key
/// ============================================================

class AppLocalizations {
  AppLocalizations._();

  /// Supported language codes
  static const List<String> supportedLanguages = ['en', 'hi', 'pa', 'kn'];

  /// Human-readable language names (in their own script)
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'pa': 'ਪੰਜਾਬੀ',
    'kn': 'ಕನ್ನಡ',
  };

  /// English subtitles for each language (used in language selector)
  static const Map<String, String> languageSubtitles = {
    'en': 'English',
    'hi': 'Hindi',
    'pa': 'Punjabi',
    'kn': 'Kannada',
  };

  /// Locale objects for each supported language
  static const Map<String, Locale> supportedLocales = {
    'en': Locale('en', 'IN'),
    'hi': Locale('hi', 'IN'),
    'pa': Locale('pa', 'IN'),
    'kn': Locale('kn', 'IN'),
  };

  /// Whether the language is RTL
  /// Currently all supported languages are LTR.
  /// Ready for future RTL language support (e.g., Urdu).
  static const Map<String, TextDirection> textDirections = {
    'en': TextDirection.ltr,
    'hi': TextDirection.ltr,
    'pa': TextDirection.ltr,
    'kn': TextDirection.ltr,
  };

  /// All string maps indexed by language code
  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': en,
    'hi': hi,
    'pa': pa,
    'kn': kn,
  };

  /// Current language code (default: English)
  static String _currentLanguage = 'en';

  /// Get the current language code
  static String get currentLanguage => _currentLanguage;

  /// Get the current Locale
  static Locale get currentLocale =>
      supportedLocales[_currentLanguage] ?? const Locale('en', 'IN');

  /// Get the text direction for the current language
  static TextDirection get currentTextDirection =>
      textDirections[_currentLanguage] ?? TextDirection.ltr;

  /// Whether the current language reads right-to-left
  static bool get isRtl => currentTextDirection == TextDirection.rtl;

  /// Set the current language
  static void setLanguage(String languageCode) {
    if (supportedLanguages.contains(languageCode)) {
      _currentLanguage = languageCode;
    }
  }

  /// Check if a language is supported
  static bool isSupported(String languageCode) =>
      supportedLanguages.contains(languageCode);

  /// Get all translation keys (useful for debugging / validation)
  static Set<String> get allKeys => _localizedStrings['en']?.keys.toSet() ?? {};

  /// Get count of translations for a given language
  static int translationCount(String languageCode) =>
      _localizedStrings[languageCode]?.length ?? 0;

  /// Check for missing translations in a given language vs English
  static List<String> missingKeys(String languageCode) {
    final enKeys = _localizedStrings['en']?.keys.toSet() ?? {};
    final langKeys = _localizedStrings[languageCode]?.keys.toSet() ?? {};
    return enKeys.difference(langKeys).toList();
  }

  /// Translate a key to the current language.
  /// Falls back to English if key not found in current language.
  /// Returns the key itself as last resort.
  static String translate(String key) {
    return _localizedStrings[_currentLanguage]?[key] ??
        _localizedStrings['en']?[key] ??
        key; // Return key itself as last resort
  }

  /// Translate with named parameter interpolation.
  /// Usage: translateWithParams('greeting', {'name': 'Rajesh'})
  /// The translation string should contain {name} as placeholder.
  static String translateWithParams(String key, Map<String, String> params) {
    String result = translate(key);
    params.forEach((paramKey, paramValue) {
      result = result.replaceAll('{$paramKey}', paramValue);
    });
    return result;
  }

  /// Translate with a count for pluralization.
  /// Uses simple English-style plural: count == 1 → singular, else → plural.
  /// Keys should be defined as 'key_one' and 'key_other'.
  static String translatePlural(String key, int count) {
    final suffix = count == 1 ? '_one' : '_other';
    final pluralKey = '$key$suffix';
    // Try plural form first, fall back to base key
    final result = _localizedStrings[_currentLanguage]?[pluralKey] ??
        _localizedStrings['en']?[pluralKey] ??
        translate(key);
    return result.replaceAll('{count}', count.toString());
  }

  /// Get a translation for a specific language (not the current one)
  static String translateFor(String key, String languageCode) {
    return _localizedStrings[languageCode]?[key] ??
        _localizedStrings['en']?[key] ??
        key;
  }
}

/// Shorthand function for translation — use t('key') anywhere
String t(String key) => AppLocalizations.translate(key);

/// Shorthand for parameterized translation
String tp(String key, Map<String, String> params) =>
    AppLocalizations.translateWithParams(key, params);

/// Shorthand for plural translation
String tn(String key, int count) =>
    AppLocalizations.translatePlural(key, count);
