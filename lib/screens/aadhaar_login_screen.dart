import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../config/app_colors.dart';
import '../config/app_routes.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/input_field.dart';

/// ============================================================
/// AADHAAR LOGIN SCREEN — Mock Aadhaar / ABHA ID verification
/// ============================================================
/// This is a mock UI. No real Aadhaar validation is performed.
/// Replace with actual UIDAI / ABDM API integration when ready.
/// ============================================================

class AadhaarLoginScreen extends StatefulWidget {
  const AadhaarLoginScreen({super.key});

  @override
  State<AadhaarLoginScreen> createState() => _AadhaarLoginScreenState();
}

class _AadhaarLoginScreenState extends State<AadhaarLoginScreen> {
  final _aadhaarController = TextEditingController();
  final _abhaController = TextEditingController();
  bool _useAbha = false;

  @override
  void dispose() {
    _aadhaarController.dispose();
    _abhaController.dispose();
    super.dispose();
  }

  Future<void> _verifyIdentity() async {
    final auth = context.read<AuthProvider>();
    bool success;

    if (_useAbha) {
      success = await auth.verifyAadhaar(_abhaController.text);
    } else {
      success = await auth.verifyAadhaar(_aadhaarController.text);
    }

    if (success && mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.home, (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('verification_failed')),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t('aadhaar_login')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ── Illustration ──
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.fingerprint,
                  size: 56, color: AppColors.secondary),
              ),
            ),
            const SizedBox(height: 32),

            // ── Toggle: Aadhaar / ABHA ──
            Container(
              decoration: BoxDecoration(
                color: AppColors.dividerLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _useAbha = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: !_useAbha ? AppColors.secondary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t('aadhaar_number'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: !_useAbha ? Colors.white : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _useAbha = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _useAbha ? AppColors.secondary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          t('abha_id'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _useAbha ? Colors.white : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Input Field ──
            if (!_useAbha)
              InputField(
                label: t('aadhaar_number'),
                hint: t('enter_aadhaar'),
                controller: _aadhaarController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.credit_card,
                maxLength: 14, // 12 digits + 2 spaces
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d ]')),
                  _AadhaarFormatter(),
                ],
              )
            else
              InputField(
                label: t('abha_id'),
                hint: t('enter_abha'),
                controller: _abhaController,
                prefixIcon: Icons.badge,
                maxLength: 20,
              ),

            const SizedBox(height: 12),

            // ── Security Note ──
            Row(
              children: [
                const Icon(Icons.shield, size: 18, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t('aadhaar_note'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Verify Button ──
            PrimaryButton(
              text: t('verify_identity'),
              icon: Icons.verified_user,
              isLoading: auth.isLoading,
              backgroundColor: AppColors.secondary,
              onPressed: _verifyIdentity,
            ),
          ],
        ),
      ),
    );
  }
}

/// Formats Aadhaar input as "XXXX XXXX XXXX"
class _AadhaarFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    if (digits.length > 12) return oldValue;

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
