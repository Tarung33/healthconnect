import 'en.dart';
import 'hi.dart';
import 'kn.dart';

/// ============================================================
/// APP LOCALIZATIONS — Simple key-based localization system
/// ============================================================
/// Lightweight alternative to Flutter's built-in localization
/// to minimize APK size and complexity on low-end devices.
/// ============================================================

class AppLocalizations {
  /// Supported language codes
  static const List<String> supportedLanguages = ['en', 'hi', 'kn'];

  /// Human-readable language names (in their own script)
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'kn': 'ಕನ್ನಡ',
  };

  /// All string maps indexed by language code
  static const Map<String, Map<String, String>> _localizedStrings = {
    'en': en,
    'hi': hi,
    'kn': kn,
  };

  /// Current language code (default: English)
  static String _currentLanguage = 'en';

  /// Get the current language code
  static String get currentLanguage => _currentLanguage;

  /// Set the current language
  static void setLanguage(String languageCode) {
    if (supportedLanguages.contains(languageCode)) {
      _currentLanguage = languageCode;
    }
  }

  /// Translate a key to the current language.
  /// Falls back to English if key not found in current language.
  static String translate(String key) {
    return _localizedStrings[_currentLanguage]?[key] ??
        _localizedStrings['en']?[key] ??
        key; // Return key itself as last resort
  }
}

/// Shorthand function for translation — use t('key') anywhere
String t(String key) => AppLocalizations.translate(key);
