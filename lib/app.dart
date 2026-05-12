import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'core/error_boundary.dart';
import 'core/page_transitions.dart';
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
import 'screens/admin_dashboard_screen.dart';

/// ============================================================
/// APP — Root MaterialApp with theming and routing
/// ============================================================
/// Listens to ThemeProvider and LanguageProvider to rebuild
/// the entire widget tree on theme/language changes.
///
/// Includes Flutter localization delegates for:
///   • Material widgets (date pickers, dialogs, etc.)
///   • Cupertino widgets (iOS-style pickers)
///   • Text directionality (LTR/RTL)
///
/// Production enhancements:
///   • Error boundaries on all routes
///   • Smooth custom page transitions
///   • Performance-optimized route generation
/// ============================================================

class A2ZHealthConnectApp extends StatelessWidget {
  const A2ZHealthConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'A2Z HealthConnect',
      debugShowCheckedModeBanner: false,

      // ── Theming ──
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,

      // ── Localization ──
      locale: langProvider.currentLocale,
      supportedLocales: langProvider.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Locale Resolution ──
      localeResolutionCallback: (locale, supportedLocales) {
        // Return the currently selected locale from provider
        return langProvider.currentLocale;
      },

      // ── Text Direction (RTL-ready) + Error Boundary ──
      builder: (context, child) {
        // Apply text scaling limits for accessibility
        final mediaQuery = MediaQuery.of(context);
        final clampedTextScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.8,
          maxScaleFactor: 1.5,
        );

        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedTextScaler),
          child: Directionality(
            textDirection: langProvider.textDirection,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },

      // ── Initial Route ──
      initialRoute: AppRoutes.splash,

      // ── Route Generation with Smooth Transitions ──
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case AppRoutes.splash:
            page = const SplashScreen();
            // Splash has no transition
            return MaterialPageRoute(builder: (_) => page);

          case AppRoutes.onboarding:
            page = const OnboardingScreen();
            return FadeThroughPageRoute(page: _wrapWithErrorBoundary(page, 'Onboarding'));

          case AppRoutes.languageSelection:
            page = const LanguageSelectionScreen();
            return SlideUpPageRoute(page: _wrapWithErrorBoundary(page, 'Language'));

          case AppRoutes.login:
            page = const LoginScreen();
            return FadeThroughPageRoute(page: _wrapWithErrorBoundary(page, 'Login'));

          case AppRoutes.aadhaarLogin:
            page = const AadhaarLoginScreen();
            return SlideRightPageRoute(page: _wrapWithErrorBoundary(page, 'Aadhaar Login'));

          case AppRoutes.home:
            page = const MainShell();
            return FadeThroughPageRoute(page: _wrapWithErrorBoundary(page, 'Home'));

          case AppRoutes.doctorConsultation:
            page = const DoctorConsultationScreen();
            return SlideRightPageRoute(page: _wrapWithErrorBoundary(page, 'Consult'));

          case AppRoutes.symptomChecker:
            page = const SymptomCheckerScreen();
            return SlideRightPageRoute(page: _wrapWithErrorBoundary(page, 'Symptoms'));

          case AppRoutes.offlineRecords:
            page = const OfflineRecordsScreen();
            return SlideRightPageRoute(page: _wrapWithErrorBoundary(page, 'Records'));

          case AppRoutes.medicineAvailability:
            page = const MedicineScreen();
            return SlideRightPageRoute(page: _wrapWithErrorBoundary(page, 'Medicines'));

          case AppRoutes.profile:
            page = const ProfileScreen();
            return SlideUpPageRoute(page: _wrapWithErrorBoundary(page, 'Profile'));

          case AppRoutes.adminDashboard:
            page = const AdminDashboardScreen();
            return ScaleFadePageRoute(page: _wrapWithErrorBoundary(page, 'Admin'));

          default:
            return MaterialPageRoute(
              builder: (_) => const _NotFoundScreen(),
            );
        }
      },
    );
  }

  /// Wrap a screen with ErrorBoundary for crash protection
  Widget _wrapWithErrorBoundary(Widget page, String screenName) {
    return ErrorBoundary(
      screenName: screenName,
      child: page,
    );
  }
}

/// 404 Not Found screen
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
