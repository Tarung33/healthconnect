import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';

/// ============================================================
/// API SERVICE — HTTP client with offline fallback
/// ============================================================
/// All network requests go through this service. When offline,
/// it returns cached data or throws a clear error that the UI
/// layer can handle gracefully.
/// ============================================================

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.baseUrl;
  const Duration _timeout = Duration(seconds: AppConstants.apiTimeout);

  /// ── GET request ──
  /// TODO: Connect to your Node.js + Express backend
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl$endpoint'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Connection timed out. Please check your internet.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// ── POST request ──
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Connection timed out.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// ── PUT request ──
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw ApiException('Server error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw ApiException('Connection timed out.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
