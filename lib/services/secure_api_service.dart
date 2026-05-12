import 'dart:async';

/// ============================================================
/// SECURE API SERVICE — Token & Session Management
/// ============================================================
/// Mocks token-based authentication and secure API communication.
/// Handles ABHA token exchanges and session expiry.
/// ============================================================

class SecureApiService {
  static final SecureApiService _instance = SecureApiService._internal();
  factory SecureApiService() => _instance;
  SecureApiService._internal();

  String? _sessionToken;
  DateTime? _tokenExpiry;

  bool get isAuthenticated => _sessionToken != null && _tokenExpiry != null && DateTime.now().isBefore(_tokenExpiry!);

  /// Simulates authenticating with Aadhaar / Health ID
  Future<bool> authenticateWithAadhaar(String aadhaarNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network call
    
    if (otp == '123456') { // Mock valid OTP
      _sessionToken = 'ABHA_SECURE_TOKEN_${DateTime.now().millisecondsSinceEpoch}';
      _tokenExpiry = DateTime.now().add(const Duration(hours: 1));
      return true;
    }
    return false;
  }

  /// Simulates an API call that requires a valid session
  Future<Map<String, dynamic>> secureGet(String endpoint) async {
    if (!isAuthenticated) {
      throw Exception('Unauthorized: Session expired or invalid token');
    }
    await Future.delayed(const Duration(milliseconds: 500));
    return {'status': 'success', 'data': 'Secure payload from $endpoint'};
  }

  void endSession() {
    _sessionToken = null;
    _tokenExpiry = null;
  }
}
