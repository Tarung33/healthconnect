import 'package:flutter/material.dart';

/// ============================================================
/// ACCESSIBILITY HELPERS — WCAG-compliant accessibility tools
/// ============================================================

/// Wrapper that adds semantic labels and accessibility info
class AccessibleWidget extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final bool isButton;
  final bool isHeader;
  final VoidCallback? onTap;

  const AccessibleWidget({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.isButton = false,
    this.isHeader = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      onTap: onTap,
      child: child,
    );
  }
}

/// Large touch target wrapper — ensures 48dp minimum
class AccessibleTouchTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String semanticLabel;
  final double minSize;

  const AccessibleTouchTarget({
    super.key,
    required this.child,
    required this.onTap,
    required this.semanticLabel,
    this.minSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Focus-aware text field with screen reader support
class AccessibleTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final int? maxLength;

  const AccessibleTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: labelText,
      textField: true,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        maxLength: maxLength,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: '', // Hide counter for cleaner UI
        ),
      ),
    );
  }
}

/// High-contrast mode detector
class HighContrastDetector {
  static bool isHighContrast(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }

  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  static bool isLargeText(BuildContext context) {
    return textScaleFactor(context) > 1.3;
  }
}

/// Accessibility-aware color chooser
class AccessibleColors {
  static Color contrastText(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  static bool meetsContrastRatio(Color foreground, Color background, {double minRatio = 4.5}) {
    final fgLum = foreground.computeLuminance() + 0.05;
    final bgLum = background.computeLuminance() + 0.05;
    final ratio = fgLum > bgLum ? fgLum / bgLum : bgLum / fgLum;
    return ratio >= minRatio;
  }
}
