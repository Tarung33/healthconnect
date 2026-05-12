import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../widgets/primary_button.dart';

/// ============================================================
/// LANGUAGE SELECTION SCREEN — Choose from EN / HI / PA
/// ============================================================
/// Large tiles for easy selection by rural users. Shown on
/// first launch and accessible from Profile settings.
///
/// Features:
///   • Auto-selects previously saved language
///   • Animated selection with check icon
///   • Shows native name + English subtitle
///   • Accessible large touch targets
/// ============================================================

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  String _selectedLang = 'en';
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _selectedLang = context.read<LanguageProvider>().currentLanguage;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _selectLanguage(String code) {
    setState(() => _selectedLang = code);
  }

  Future<void> _confirmSelection() async {
    await context.read<LanguageProvider>().changeLanguage(_selectedLang);

    if (!mounted) return;

    if (widget.isFromSettings) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('language_changed')),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Supported language display data
    final languages = [
      _LanguageData(code: 'en', nativeName: 'English', englishName: 'English', icon: '🇬🇧'),
      _LanguageData(code: 'hi', nativeName: 'हिंदी', englishName: 'Hindi', icon: '🇮🇳'),
      _LanguageData(code: 'pa', nativeName: 'ਪੰਜਾਬੀ', englishName: 'Punjabi', icon: '🇮🇳'),
      _LanguageData(code: 'kn', nativeName: 'ಕನ್ನಡ', englishName: 'Kannada', icon: '🇮🇳'),
    ];

    return Scaffold(
      appBar: widget.isFromSettings
          ? AppBar(title: Text(t('language')))
          : null,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ── Title ──
                Text(t('select_language'),
                  style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(t('select_language_desc'),
                  style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 40),

                // ── Language Tiles ──
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: languages.map((lang) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _LanguageTile(
                        code: lang.code,
                        nativeName: lang.nativeName,
                        englishName: lang.englishName,
                        icon: lang.icon,
                        isSelected: _selectedLang == lang.code,
                        onTap: () => _selectLanguage(lang.code),
                      ),
                    )).toList(),
                  ),
                ),

                // ── Continue Button ──
                PrimaryButton(
                  text: t('continue_btn'),
                  icon: Icons.arrow_forward,
                  onPressed: _confirmSelection,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Language metadata for display
class _LanguageData {
  final String code;
  final String nativeName;
  final String englishName;
  final String icon;

  const _LanguageData({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.icon,
  });
}

/// Large tappable language tile with animation
class _LanguageTile extends StatelessWidget {
  final String code;
  final String nativeName;
  final String englishName;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerLight,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Language icon (flag emoji or code)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.dividerLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Language names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    englishName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            // Check icon with scale animation
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
