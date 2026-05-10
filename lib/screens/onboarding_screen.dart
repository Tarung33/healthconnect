import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';
import '../widgets/primary_button.dart';

/// ============================================================
/// ONBOARDING SCREEN — 3-page intro for first-time users
/// ============================================================

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding page data
  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.video_call_rounded,
      titleKey: 'onboarding_title_1',
      descKey: 'onboarding_desc_1',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.psychology_rounded,
      titleKey: 'onboarding_title_2',
      descKey: 'onboarding_desc_2',
      color: AppColors.secondary,
    ),
    _OnboardingPage(
      icon: Icons.cloud_off_rounded,
      titleKey: 'onboarding_title_3',
      descKey: 'onboarding_desc_3',
      color: AppColors.accent,
    ),
  ];

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await StorageService().setOnboardingComplete(true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.languageSelection);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip Button ──
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(t('skip'), style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),

            // ── Page View ──
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Illustration Icon ──
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 72, color: page.color),
                        ),
                        const SizedBox(height: 40),

                        // ── Title ──
                        Text(
                          t(page.titleKey),
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // ── Description ──
                        Text(
                          t(page.descKey),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Page Indicator ──
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.dividerLight,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 32),

            // ── Next / Get Started Button ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
              ),
              child: PrimaryButton(
                text: isLastPage ? t('get_started') : t('next'),
                icon: isLastPage ? Icons.arrow_forward : null,
                onPressed: _nextPage,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Data class for an onboarding page
class _OnboardingPage {
  final IconData icon;
  final String titleKey;
  final String descKey;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.color,
  });
}
