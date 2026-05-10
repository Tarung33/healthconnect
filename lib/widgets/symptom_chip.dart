import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/symptom_model.dart';

/// ============================================================
/// SYMPTOM CHIP — Selectable symptom tag with emoji icon
/// ============================================================

class SymptomChip extends StatelessWidget {
  final SymptomModel symptom;
  final bool isSelected;
  final VoidCallback onTap;

  const SymptomChip({
    super.key,
    required this.symptom,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.15)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(symptom.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              t(symptom.key),
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : null,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
               const Icon(Icons.check_circle, size: 18, color: AppColors.primary),
            ],
          ],
        ),
      ),
    );
  }
}
