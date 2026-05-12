import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../core/retry_system.dart';

/// ============================================================
/// API SERVICE — HTTP client with retry & offline fallback
/// ============================================================
/// All network requests go through this service. Includes:
///   • Exponential backoff retry for failed requests
///   • Timeout handling for slow rural networks
///   • Structured error responses via Result type
///   • Request/response logging in debug mode
/// ============================================================

class ApiService with RetryMixin {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = AppConstants.baseUrl;
  final Duration _timeout = const Duration(seconds: AppConstants.apiTimeout);

  /// Standard headers for all requests
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-App-Version': AppConstants.appVersion,
      };

  /// ── GET request with retry ──
  Future<Map<String, dynamic>> get(String endpoint) async {
    return RetrySystem.execute(
      maxRetries: 3,
      initialDelay: const Duration(seconds: 1),
      operation: () async {
        _logRequest('GET', endpoint);
        final response = await http
            .get(Uri.parse('$_baseUrl$endpoint'), headers: _headers)
            .timeout(_timeout);
        return _handleResponse(response);
      },
      onRetry: (attempt, error, delay) {
        debugPrint('API GET $endpoint: Retry $attempt after ${delay.inSeconds}s');
      },
    );
  }

  /// ── POST request with retry ──
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    return RetrySystem.execute(
      maxRetries: 2,
      operation: () async {
        _logRequest('POST', endpoint, body: body);
        final response = await http
            .post(
              Uri.parse('$_baseUrl$endpoint'),
              headers: _headers,
              body: json.encode(body),
            )
            .timeout(_timeout);
        return _handleResponse(response);
      },
    );
  }

  /// ── PUT request with retry ──
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    return RetrySystem.execute(
      maxRetries: 2,
      operation: () async {
        _logRequest('PUT', endpoint, body: body);
        final response = await http
            .put(
              Uri.parse('$_baseUrl$endpoint'),
              headers: _headers,
              body: json.encode(body),
            )
            .timeout(_timeout);
        return _handleResponse(response);
      },
    );
  }

  /// ── DELETE request ──
  Future<Map<String, dynamic>> delete(String endpoint) async {
    return RetrySystem.execute(
      maxRetries: 1,
      operation: () async {
        _logRequest('DELETE', endpoint);
        final response = await http
            .delete(Uri.parse('$_baseUrl$endpoint'), headers: _headers)
            .timeout(_timeout);
        return _handleResponse(response);
      },
    );
  }

  /// ── Safe GET returning Result ──
  Future<Result<Map<String, dynamic>>> safeGet(String endpoint) async {
    try {
      final data = await get(endpoint);
      return Result.success(data);
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  /// ── Safe POST returning Result ──
  Future<Result<Map<String, dynamic>>> safePost(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final data = await post(endpoint, body);
      return Result.success(data);
    } on ApiException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unexpected error: $e');
    }
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    _logResponse(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw ApiException('Session expired. Please login again.', code: 401);
    } else if (response.statusCode == 403) {
      throw ApiException('Access denied.', code: 403);
    } else if (response.statusCode == 404) {
      throw ApiException('Resource not found.', code: 404);
    } else if (response.statusCode == 429) {
      throw ApiException('Too many requests. Please wait.', code: 429);
    } else if (response.statusCode >= 500) {
      throw ApiException('Server error. Please try again later.', code: response.statusCode);
    } else {
      throw ApiException('Request failed: ${response.statusCode}', code: response.statusCode);
    }
  }

  void _logRequest(String method, String endpoint, {Map<String, dynamic>? body}) {
    debugPrint('→ $method $_baseUrl$endpoint');
    if (body != null) debugPrint('  Body: ${json.encode(body).substring(0, 200.clamp(0, json.encode(body).length))}');
  }

  void _logResponse(http.Response response) {
    debugPrint('← ${response.statusCode} (${response.contentLength} bytes)');
  }
}

/// Custom exception for API errors with status code
class ApiException implements Exception {
  final String message;
  final int? code;
  ApiException(this.message, {this.code});

  @override
  String toString() => message;

  bool get isNetworkError => code == null;
  bool get isAuthError => code == 401 || code == 403;
  bool get isServerError => code != null && code! >= 500;
  bool get isRetryable => isNetworkError || isServerError || code == 429;
}
