import 'storage_service.dart';
import '../l10n/app_localizations.dart';

/// ============================================================
/// LOCALIZATION SERVICE — Language persistence & switching
/// ============================================================

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  final StorageService _storage = StorageService();

  /// Load saved language preference on app start
  Future<void> loadSavedLanguage() async {
    final langCode = await _storage.getLanguage();
    AppLocalizations.setLanguage(langCode);
  }

  /// Change language and persist
  Future<void> changeLanguage(String languageCode) async {
    AppLocalizations.setLanguage(languageCode);
    await _storage.setLanguage(languageCode);
  }

  /// Get current language code
  String get currentLanguage => AppLocalizations.currentLanguage;
}
