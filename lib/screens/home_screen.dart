import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';
import '../config/app_routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/connectivity_banner.dart';
import '../widgets/dashboard_tile.dart';
import '../widgets/section_header.dart';

/// ============================================================
/// HOME SCREEN — Main dashboard after login
/// ============================================================
/// Shows greeting, connectivity status, quick actions, upcoming
/// appointments, and health tips.
/// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return t('good_morning');
    if (hour < 17) return t('good_afternoon');
    return t('good_evening');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final connectivity = context.watch<ConnectivityProvider>();
    final theme = Theme.of(context);
    final userName = auth.user?.fullName ?? 'User';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Offline Banner ──
            ConnectivityBanner(isOnline: connectivity.isOnline),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Greeting Header ──
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()} 👋',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userName,
                                style: theme.textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        // User avatar
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              userName[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ── Connectivity Chip ──
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: connectivity.isOnline
                            ? AppColors.online.withOpacity(0.1)
                            : AppColors.offline.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            connectivity.isOnline ? Icons.wifi : Icons.wifi_off,
                            size: 14,
                            color: connectivity.isOnline ? AppColors.online : AppColors.offline,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            connectivity.isOnline ? t('online') : t('offline_short'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: connectivity.isOnline ? AppColors.online : AppColors.offline,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Quick Actions Grid ──
                    SectionHeader(title: t('quick_actions')),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.1,
                      children: [
                        DashboardTile(
                          icon: Icons.video_call,
                          label: t('consult_doctor'),
                          color: AppColors.primary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.doctorConsultation),
                        ),
                        DashboardTile(
                          icon: Icons.psychology,
                          label: t('check_symptoms'),
                          color: AppColors.secondary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.symptomChecker),
                        ),
                        DashboardTile(
                          icon: Icons.folder_shared,
                          label: t('my_records'),
                          color: AppColors.accent,
                          badge: 4,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.offlineRecords),
                        ),
                        DashboardTile(
                          icon: Icons.medication,
                          label: t('medicines'),
                          color: AppColors.success,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.medicineAvailability),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // ── Upcoming Appointments ──
                    SectionHeader(
                      title: t('upcoming_appointments'),
                      actionText: t('book_appointment'),
                      onAction: () => Navigator.pushNamed(context, AppRoutes.doctorConsultation),
                    ),
                    _buildAppointmentCard(context),
                    const SizedBox(height: 8),

                    // ── Health Tips Carousel ──
                    SectionHeader(title: t('health_tips')),
                    SizedBox(
                      height: 130,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _healthTipCard('💧', 'Drink 8 glasses of water daily', AppColors.primary),
                          _healthTipCard('🏃', 'Walk 30 minutes every day', AppColors.secondary),
                          _healthTipCard('🍎', 'Eat seasonal fruits & vegetables', AppColors.accent),
                          _healthTipCard('😴', 'Get 7-8 hours of sleep', AppColors.success),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calendar_today, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. Priya Sharma',
                    style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text('General Physician • Tomorrow, 10:00 AM',
                    style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Video',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _healthTipCard(String emoji, String tip, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(tip, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
