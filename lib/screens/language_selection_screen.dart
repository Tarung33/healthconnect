import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../widgets/primary_button.dart';

/// ============================================================
/// LANGUAGE SELECTION SCREEN — Choose from EN / HI / KN
/// ============================================================
/// Large tiles for easy selection by rural users. Shown on
/// first launch and accessible from Profile settings.
/// ============================================================

class LanguageSelectionScreen extends StatefulWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLang = 'en';

  @override
  void initState() {
    super.initState();
    _selectedLang = context.read<LanguageProvider>().currentLanguage;
  }

  void _selectLanguage(String code) {
    setState(() => _selectedLang = code);
  }

  Future<void> _confirmSelection() async {
    await context.read<LanguageProvider>().changeLanguage(_selectedLang);

    if (!mounted) return;

    if (widget.isFromSettings) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromSettings
          ? AppBar(title: Text(t('language')))
          : null,
      body: SafeArea(
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
              _LanguageTile(
                code: 'en',
                name: 'English',
                nativeName: 'English',
                isSelected: _selectedLang == 'en',
                onTap: () => _selectLanguage('en'),
              ),
              const SizedBox(height: 16),
              _LanguageTile(
                code: 'hi',
                name: 'Hindi',
                nativeName: 'हिंदी',
                isSelected: _selectedLang == 'hi',
                onTap: () => _selectLanguage('hi'),
              ),
              const SizedBox(height: 16),
              _LanguageTile(
                code: 'kn',
                name: 'Kannada',
                nativeName: 'ಕನ್ನಡ',
                isSelected: _selectedLang == 'kn',
                onTap: () => _selectLanguage('kn'),
              ),

              const Spacer(),

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
    );
  }
}

/// Large tappable language tile
class _LanguageTile extends StatelessWidget {
  final String code;
  final String name;
  final String nativeName;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
        ),
        child: Row(
          children: [
            // Language icon
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
                  code.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : AppColors.textSecondaryLight,
                  ),
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
                  Text(name, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            // Check icon
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary, size: 28),
          ],
        ),
      ),
    );
  }
}
