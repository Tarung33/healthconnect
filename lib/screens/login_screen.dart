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
/// LOGIN SCREEN — Phone + OTP based login/register
/// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoginMode = true;
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.length != 10) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.sendOtp('+91${_phoneController.text}');

    if (success && mounted) {
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${t('otp_sent')} (Mock OTP: 123456)'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.verifyOtp(
      '+91${_phoneController.text}',
      _otpController.text,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Invalid OTP'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ── Header ──
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.health_and_safety,
                    size: 44, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(t('app_name'),
                  style: Theme.of(context).textTheme.headlineMedium),
              ),
              const SizedBox(height: 40),

              // ── Login / Register Toggle ──
              Container(
                decoration: BoxDecoration(
                  color: AppColors.dividerLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isLoginMode = true;
                          _otpSent = false;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isLoginMode ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            t('login'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isLoginMode ? Colors.white : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isLoginMode = false;
                          _otpSent = false;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !_isLoginMode ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            t('register'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: !_isLoginMode ? Colors.white : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Phone Number ──
              InputField(
                label: t('phone_number'),
                hint: t('enter_phone'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),

              // ── OTP Field (shown after sending) ──
              if (_otpSent) ...[
                InputField(
                  label: t('enter_otp'),
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.lock_outline,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 24),
              ],

              // ── Action Button ──
              PrimaryButton(
                text: _otpSent ? t('verify_otp') : t('send_otp'),
                isLoading: auth.isLoading,
                onPressed: _otpSent ? _verifyOtp : _sendOtp,
              ),
              const SizedBox(height: 24),

              // ── Divider ──
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(t('or'), style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              // ── Aadhaar Login Button ──
              PrimaryButton(
                text: t('login_with_aadhaar'),
                isOutlined: true,
                icon: Icons.fingerprint,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.aadhaarLogin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
