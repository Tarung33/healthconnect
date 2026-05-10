import '../models/user_model.dart';
import 'storage_service.dart';

/// ============================================================
/// AUTH SERVICE — Authentication logic (mock implementation)
/// ============================================================
/// Uses mock user data for testing. Replace the mock methods
/// with real API calls when backend is ready.
/// ============================================================

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final StorageService _storage = StorageService();

  /// ── Send OTP (mock) ──
  /// TODO: Connect to SMS gateway API
  Future<bool> sendOtp(String phoneNumber) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Mock: always succeeds
    print('[AuthService] OTP sent to $phoneNumber (mock: 123456)');
    return true;
  }

  /// ── Verify OTP (mock) ──
  /// TODO: Connect to backend /auth/verify-otp endpoint
  Future<UserModel?> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock: accept any 6-digit OTP or "123456"
    if (otp.length == 6) {
      final user = UserModel.mock();
      await _storage.setLoggedIn(true);
      print('[AuthService] OTP verified for $phoneNumber');
      return user;
    }
    return null;
  }

  /// ── Aadhaar Login (mock) ──
  /// TODO: Connect to Aadhaar verification API
  Future<UserModel?> verifyAadhaar(String aadhaarNumber) async {
    await Future.delayed(const Duration(seconds: 2));

    // Mock: accept any 12-digit number
    final cleanNumber = aadhaarNumber.replaceAll(' ', '');
    if (cleanNumber.length == 12) {
      final user = UserModel.mock();
      await _storage.setLoggedIn(true);
      print('[AuthService] Aadhaar verified: $aadhaarNumber');
      return user;
    }
    return null;
  }

  /// ── ABHA ID Login (mock) ──
  /// TODO: Connect to ABDM (Ayushman Bharat Digital Mission) API
  Future<UserModel?> verifyAbhaId(String abhaId) async {
    await Future.delayed(const Duration(seconds: 2));

    if (abhaId.isNotEmpty) {
      final user = UserModel.mock();
      await _storage.setLoggedIn(true);
      print('[AuthService] ABHA ID verified: $abhaId');
      return user;
    }
    return null;
  }

  /// ── Logout ──
  Future<void> logout() async {
    await _storage.setLoggedIn(false);
    print('[AuthService] User logged out');
  }

  /// ── Check login status ──
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }
}
