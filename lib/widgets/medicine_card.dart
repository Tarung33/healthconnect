import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/medicine_model.dart';

/// ============================================================
/// MEDICINE CARD — Displays medicine availability info
/// ============================================================

class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Medicine Name & Availability Badge ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine.name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(medicine.genericName, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: medicine.isAvailable
                        ? AppColors.success.withOpacity(0.12)
                        : AppColors.error.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    medicine.isAvailable ? t('available') : t('unavailable'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: medicine.isAvailable ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ── Price, Store, Distance ──
            Row(
              children: [
                _infoChip(Icons.currency_rupee, '₹${medicine.price.toStringAsFixed(0)}'),
                const SizedBox(width: 12),
                _infoChip(Icons.storefront, medicine.storeName),
                const SizedBox(width: 12),
                _infoChip(Icons.location_on_outlined, medicine.distance),
              ],
            ),

            // ── Generic available badge ──
            if (medicine.hasGeneric) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified, size: 16, color: AppColors.accent),
                    const SizedBox(width: 6),
                    Text(
                      t('generic_available'),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondaryLight),
          const SizedBox(width: 4),
          Flexible(
            child: Text(text, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
