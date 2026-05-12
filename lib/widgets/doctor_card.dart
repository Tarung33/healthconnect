import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/doctor_model.dart';

/// ============================================================
/// DOCTOR CARD — Displays doctor info in a list
/// ============================================================

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback? onBookNow;

  const DoctorCard({super.key, required this.doctor, this.onBookNow});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor Name & Availability ──
            Row(
              children: [
                // Avatar circle with initials
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    doctor.name.split(' ').map((n) => n[0]).take(2).join(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(doctor.specialization, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                // Availability indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: doctor.isAvailable
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    doctor.isAvailable ? '● ${t('online')}' : '● ${t('offline_short')}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: doctor.isAvailable ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Stats Row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem(Icons.work_outline, '${doctor.experienceYears} ${t('years')}'),
                _statItem(Icons.star, '${doctor.rating}'),
                _statItem(Icons.currency_rupee, '₹${doctor.consultationFee}'),
              ],
            ),

            if (doctor.isAvailable) ...[
              const SizedBox(height: 14),
              // ── Action Buttons ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onBookNow,
                      icon: const Icon(Icons.videocam, size: 20),
                      label: Text(t('video_call')),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onBookNow,
                      icon: const Icon(Icons.phone, size: 20),
                      label: Text(t('voice_call')),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondaryLight),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
