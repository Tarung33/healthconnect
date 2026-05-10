import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/health_record_model.dart';
import 'package:intl/intl.dart';

/// ============================================================
/// RECORD CARD — Displays a health record with sync status
/// ============================================================

class RecordCard extends StatelessWidget {
  final HealthRecordModel record;
  final VoidCallback? onTap;

  const RecordCard({super.key, required this.record, this.onTap});

  IconData get _typeIcon {
    switch (record.type) {
      case 'prescription': return Icons.receipt_long;
      case 'lab_report': return Icons.science;
      case 'vaccination': return Icons.vaccines;
      default: return Icons.description;
    }
  }

  Color get _typeColor {
    switch (record.type) {
      case 'prescription': return AppColors.primary;
      case 'lab_report': return AppColors.secondary;
      case 'vaccination': return AppColors.accent;
      default: return AppColors.textSecondaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ── Type Icon ──
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_typeIcon, color: _typeColor, size: 24),
              ),
              const SizedBox(width: 14),

              // ── Record Info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${record.doctorName} • ${record.diagnosis}',
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(record.date),
                      style: theme.textTheme.labelSmall,
                    ),
                  ],
                ),
              ),

              // ── Sync Status ──
              Icon(
                record.isSyncedOnline ? Icons.cloud_done : Icons.cloud_off,
                size: 20,
                color: record.isSyncedOnline ? AppColors.success : AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
