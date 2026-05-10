/// ============================================================
/// APP CONSTANTS — Global configuration values
/// ============================================================

class AppConstants {
  AppConstants._();

  // ── App Info ──
  static const String appName = 'A2Z HealthConnect';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Healthcare at your fingertips';

  // ── API Configuration ──
  // TODO: Replace with your actual backend URL
  static const String baseUrl = 'http://localhost:3000/api';
  static const int apiTimeout = 15; // seconds

  // ── Mock User for Testing ──
  static const String mockUserName = 'Rajesh Kumar';
  static const String mockUserPhone = '+91 9876543210';
  static const String mockUserAadhaar = '1234 5678 9012';
  static const String mockUserAbhaId = '12-3456-7890-1234';
  static const String mockUserEmail = 'rajesh.kumar@email.com';
  static const String mockUserVillage = 'Hosahalli, Karnataka';

  // ── SharedPreferences Keys ──
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyUserData = 'user_data';

  // ── UI Constraints ──
  static const double minTouchTarget = 48.0; // dp — accessibility minimum
  static const double buttonHeight = 56.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double horizontalPadding = 20.0;
}
