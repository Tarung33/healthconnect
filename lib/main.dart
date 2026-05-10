import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/connectivity_provider.dart';

/// ============================================================
/// MAIN ENTRY POINT — A2Z HealthConnect
/// ============================================================
/// Initializes all providers and services before launching the
/// app. Uses MultiProvider for dependency injection.
/// ============================================================

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

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

  // ── Initialize Providers ──
  final themeProvider = ThemeProvider();
  final languageProvider = LanguageProvider();
  final connectivityProvider = ConnectivityProvider();

  // Load saved preferences
  await themeProvider.loadTheme();
  await languageProvider.loadLanguage();

  // Start connectivity monitoring
  connectivityProvider.startListening();

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
}
