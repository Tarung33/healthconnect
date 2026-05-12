import 'translation_service.dart';

/// ============================================================
/// LOCALIZATION SERVICE — Language persistence & switching
/// ============================================================
/// Thin wrapper around TranslationService for backward
/// compatibility. New code should use TranslationService directly.
/// ============================================================

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  final TranslationService _translationService = TranslationService();

  /// Load saved language preference on app start
  Future<void> loadSavedLanguage() async {
    await _translationService.loadSavedLanguage();
  }

  /// Change language and persist
  Future<void> changeLanguage(String languageCode) async {
    await _translationService.changeLanguage(languageCode);
  }

  /// Get current language code
  String get currentLanguage => _translationService.currentLanguage;

  /// Try to auto-detect device locale
  Future<String> detectDeviceLocale() async {
    return await _translationService.detectAndApplyDeviceLocale();
  }
}
