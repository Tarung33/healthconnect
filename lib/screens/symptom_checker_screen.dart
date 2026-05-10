import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/symptom_model.dart';
import '../widgets/symptom_chip.dart';
import '../widgets/primary_button.dart';

/// ============================================================
/// AI SYMPTOM CHECKER SCREEN — Select symptoms, get AI guidance
/// ============================================================
/// TODO: Connect to AI backend endpoint /api/symptom-check
/// Currently shows mock AI assessment based on symptom count.
/// ============================================================

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final List<SymptomModel> _allSymptoms = SymptomModel.commonSymptoms();
  final Set<String> _selectedIds = {};
  bool _showResult = false;
  bool _isAnalyzing = false;

  void _toggleSymptom(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
      _showResult = false; // Reset result when selection changes
    });
  }

  Future<void> _analyzeSymptoms() async {
    if (_selectedIds.isEmpty) return;

    setState(() => _isAnalyzing = true);

    // TODO: Send selected symptoms to AI backend
    // final response = await ApiService().post('/symptom-check', {
    //   'symptoms': _selectedIds.toList(),
    //   'language': AppLocalizations.currentLanguage,
    // });

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _showResult = true;
      });
    }
  }

  /// Generate mock AI result based on selected symptoms
  String _getMockResult() {
    final count = _selectedIds.length;
    if (count >= 4) {
      return 'Based on your symptoms, this could indicate a viral infection. '
          'Please consult a doctor within 24 hours. Stay hydrated and rest. '
          'If you experience breathing difficulty, seek immediate medical attention.';
    } else if (count >= 2) {
      return 'Your symptoms suggest a common cold or mild infection. '
          'Take rest, drink warm fluids, and monitor for 2-3 days. '
          'If symptoms worsen, please consult a doctor.';
    } else {
      return 'Your symptom appears mild. Monitor for changes over the next '
          '24-48 hours. Maintain good hygiene and stay hydrated. '
          'Consult a doctor if the condition persists.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedSymptoms = _allSymptoms.where((s) => _selectedIds.contains(s.id)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(t('symptom_checker'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ── Description ──
            Text(t('symptom_checker_desc'), style: theme.textTheme.bodyLarge),
            const SizedBox(height: 20),

            // ── Common Symptoms Grid ──
            Text(t('common_symptoms'), style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _allSymptoms.map((symptom) {
                return SymptomChip(
                  symptom: symptom,
                  isSelected: _selectedIds.contains(symptom.id),
                  onTap: () => _toggleSymptom(symptom.id),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ── Selected Symptoms Summary ──
            if (selectedSymptoms.isNotEmpty) ...[
              Text(
                '${t('selected_symptoms')} (${selectedSymptoms.length})',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                ),
                child: Text(
                  selectedSymptoms.map((s) => '${s.icon} ${t(s.key)}').join(', '),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),

              // ── Analyze Button ──
              PrimaryButton(
                text: t('check_now'),
                icon: Icons.psychology,
                isLoading: _isAnalyzing,
                backgroundColor: AppColors.secondary,
                onPressed: _analyzeSymptoms,
              ),
            ],

            // ── AI Result ──
            if (_showResult) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondary.withOpacity(0.08),
                      AppColors.primary.withOpacity(0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology, color: AppColors.secondary, size: 24),
                        const SizedBox(width: 8),
                        Text(t('ai_result'), style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.secondary,
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(_getMockResult(), style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                    const SizedBox(height: 16),
                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 20, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t('ai_disclaimer'),
                              style: TextStyle(fontSize: 13, color: AppColors.warning, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
