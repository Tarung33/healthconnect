import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';
import '../config/app_routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../screens/language_selection_screen.dart';

/// ============================================================
/// PROFILE SCREEN — User info, settings, and logout
/// ============================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final theme = Theme.of(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: Text(t('profile'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── User Avatar & Info ──
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Text(
                (user?.fullName ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.fullName ?? 'User',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              user?.phone ?? '',
              style: theme.textTheme.bodyMedium,
            ),
            if (user?.village != null) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 4),
                  Text(user!.village!, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
            const SizedBox(height: 24),

            // ── Info Cards ──
            if (user?.aadhaarNumber != null)
              _infoCard(context, Icons.credit_card, t('aadhaar_number'), user!.aadhaarNumber!),
            if (user?.abhaId != null)
              _infoCard(context, Icons.badge, t('abha_id'), user!.abhaId!),
            if (user?.email != null)
              _infoCard(context, Icons.email_outlined, t('email'), user!.email!),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // ── Settings ──

            // Dark Mode Toggle
            _settingsTile(
              context,
              icon: Icons.dark_mode_outlined,
              title: t('dark_mode'),
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
                activeColor: AppColors.primary,
              ),
            ),

            // Language
            _settingsTile(
              context,
              icon: Icons.language,
              title: t('language'),
              subtitle: AppLocalizations.languageNames[langProvider.currentLanguage] ?? 'English',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LanguageSelectionScreen(isFromSettings: true),
                  ),
                );
              },
            ),

            // Notifications
            _settingsTile(
              context,
              icon: Icons.notifications_outlined,
              title: t('notifications'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications settings coming soon')),
                );
              },
            ),

            // Help & Support
            _settingsTile(
              context,
              icon: Icons.help_outline,
              title: t('help_support'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Help & Support coming soon')),
                );
              },
            ),

            // About
            _settingsTile(
              context,
              icon: Icons.info_outline,
              title: t('about'),
              subtitle: '${t('version')} ${AppConstants.appVersion}',
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // ── Logout Button ──
            SizedBox(
              width: double.infinity,
              height: AppConstants.buttonHeight,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.login, (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: Text(t('logout'),
                  style: const TextStyle(color: AppColors.error, fontSize: 18)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, IconData icon, String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
