import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/connectivity_provider.dart';
import 'services/sync_manager_service.dart';
import 'core/error_boundary.dart';
import 'core/crash_safe_storage.dart';
import 'core/performance_utils.dart';

/// ============================================================
/// MAIN ENTRY POINT — A2Z HealthConnect
/// ============================================================
/// Initializes all providers and services before launching the
/// app. Uses MultiProvider for dependency injection.
/// Includes global error handling and performance setup.
/// ============================================================

void main() async {
  // ── Global Error Handling ──
  // Catches all uncaught async errors
  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Setup global Flutter error handler
    setupGlobalErrorHandling();

    // ── Performance Optimization ──
    ImageCacheManager.optimize(maxImages: 50, maxSizeBytes: 30 * 1024 * 1024);

    // Lock to portrait mode for consistency on low-end devices
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // ── Initialize Crash-Safe Storage ──
    await CrashSafeStorage().initialize();

    // ── Initialize Providers ──
    final themeProvider = ThemeProvider();
    final languageProvider = LanguageProvider();
    final connectivityProvider = ConnectivityProvider();

    // Load saved preferences (crash-safe)
    try {
      await themeProvider.loadTheme();
      await languageProvider.loadLanguage();
    } catch (e) {
      debugPrint('Failed to load preferences: $e');
      // App will use defaults
    }

    // Start connectivity monitoring
    connectivityProvider.startListening();

    // Initialize offline sync manager globally
    SyncManagerService();

    // ── Launch App ──
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider.value(value: connectivityProvider),
        ],
        child: const A2ZHealthConnectApp(),
      ),
    );
  }, (error, stackTrace) {
    // Catch any uncaught errors in the zone
    debugPrint('═══ UNCAUGHT ERROR ═══');
    debugPrint('Error: $error');
    debugPrint('Stack: $stackTrace');
    debugPrint('═══════════════════');
  });
}
