import 'package:flutter/material.dart';

/// ============================================================
/// PAGE TRANSITIONS — Smooth, performance-optimized transitions
/// ============================================================
/// Custom page route transitions designed for low-end devices.
/// Uses lightweight transform animations to avoid jank.
/// ============================================================

/// Smooth slide-up transition (for modal-style navigation)
class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            final fadeAnim = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(position: offsetAnim, child: child),
            );
          },
        );
}

/// Smooth horizontal slide transition (for push-style navigation)
class SlideRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideRightPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnim = Tween<Offset>(
              begin: const Offset(0.25, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            final fadeAnim = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: fadeAnim,
              child: SlideTransition(position: offsetAnim, child: child),
            );
          },
        );
}

/// Fade-through transition (for tab switches)
class FadeThroughPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeThroughPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        );
}

/// Scale-fade transition (for dialog-like screens)
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  ScaleFadePageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final scaleAnim = Tween<double>(
              begin: 0.92,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            final fadeAnim = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
            ));

            return FadeTransition(
              opacity: fadeAnim,
              child: ScaleTransition(scale: scaleAnim, child: child),
            );
          },
        );
}

/// Helper extension for cleaner navigation
extension NavigationExtension on BuildContext {
  /// Navigate with a smooth slide-up transition
  Future<T?> pushSlideUp<T>(Widget page) {
    return Navigator.of(this).push(SlideUpPageRoute<T>(page: page));
  }

  /// Navigate with a horizontal slide transition
  Future<T?> pushSlideRight<T>(Widget page) {
    return Navigator.of(this).push(SlideRightPageRoute<T>(page: page));
  }

  /// Navigate with a fade-through transition
  Future<T?> pushFadeThrough<T>(Widget page) {
    return Navigator.of(this).push(FadeThroughPageRoute<T>(page: page));
  }

  /// Navigate with a scale-fade transition
  Future<T?> pushScaleFade<T>(Widget page) {
    return Navigator.of(this).push(ScaleFadePageRoute<T>(page: page));
  }
}
