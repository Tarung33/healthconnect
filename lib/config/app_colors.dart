import 'package:flutter/material.dart';

/// ============================================================
/// APP COLORS — Government Healthcare Inspired Palette
/// ============================================================
/// Professional blue/teal palette inspired by Indian government
/// healthcare portals (NHA, Ayushman Bharat). Designed for high
/// contrast and readability on low-end screens.
/// ============================================================

class AppColors {
  AppColors._(); // Prevent instantiation

  // ── Primary: Government Blue ──
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color primaryDark = Color(0xFF0D47A1);

  // ── Secondary: Healthcare Teal ──
  static const Color secondary = Color(0xFF00897B);
  static const Color secondaryLight = Color(0xFF4DB6AC);
  static const Color secondaryDark = Color(0xFF00695C);

  // ── Accent: Warm Amber (CTAs & highlights) ──
  static const Color accent = Color(0xFFFF8F00);
  static const Color accentLight = Color(0xFFFFB300);

  // ── Semantic Colors ──
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF1565C0);

  // ── Light Theme Surface Colors ──
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // ── Dark Theme Surface Colors ──
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF424242);

  // ── Text Colors ──
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // ── Connectivity Indicator ──
  static const Color online = Color(0xFF2E7D32);
  static const Color offline = Color(0xFFC62828);
}
