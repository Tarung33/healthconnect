import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/language_selection_screen.dart';
import 'screens/login_screen.dart';
import 'screens/aadhaar_login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/doctor_consultation_screen.dart';
import 'screens/symptom_checker_screen.dart';
import 'screens/offline_records_screen.dart';
import 'screens/medicine_screen.dart';
import 'screens/profile_screen.dart';

/// ============================================================
/// APP — Root MaterialApp with theming and routing
/// ============================================================
/// Listens to ThemeProvider and LanguageProvider to rebuild
/// the entire widget tree on theme/language changes.
/// ============================================================

class A2ZHealthConnectApp extends StatelessWidget {
  const A2ZHealthConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    // Watch language to rebuild on language change
    context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'A2Z HealthConnect',
      debugShowCheckedModeBanner: false,

      // ── Theming ──
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,

      // ── Initial Route ──
      initialRoute: AppRoutes.splash,

      // ── Named Routes ──
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.languageSelection: (context) => const LanguageSelectionScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.aadhaarLogin: (context) => const AadhaarLoginScreen(),
        AppRoutes.home: (context) => const MainShell(),
        AppRoutes.doctorConsultation: (context) => const DoctorConsultationScreen(),
        AppRoutes.symptomChecker: (context) => const SymptomCheckerScreen(),
        AppRoutes.offlineRecords: (context) => const OfflineRecordsScreen(),
        AppRoutes.medicineAvailability: (context) => const MedicineScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}
