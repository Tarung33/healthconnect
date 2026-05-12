import 'dart:async';
import 'package:flutter/foundation.dart';

/// ============================================================
/// RETRY SYSTEM — Exponential backoff retry for network calls
/// ============================================================
/// Handles unreliable rural networks with configurable retry
/// logic. Uses exponential backoff to avoid server overload.
/// ============================================================

class RetrySystem {
  /// Execute an async operation with retry logic.
  ///
  /// [operation] — The async function to execute.
  /// [maxRetries] — Maximum number of retry attempts (default: 3).
  /// [initialDelay] — Initial delay before first retry (default: 1s).
  /// [maxDelay] — Maximum delay between retries (default: 30s).
  /// [shouldRetry] — Optional predicate to decide if an error should trigger retry.
  /// [onRetry] — Optional callback on each retry attempt.
  static Future<T> execute<T>({
    required Future<T> Function() operation,
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    Duration maxDelay = const Duration(seconds: 30),
    bool Function(Exception)? shouldRetry,
    void Function(int attempt, Exception error, Duration nextDelay)? onRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        return await operation();
      } on Exception catch (e) {
        attempt++;

        // Check if we should retry
        if (attempt >= maxRetries) {
          debugPrint('RetrySystem: Max retries ($maxRetries) reached. Giving up.');
          rethrow;
        }

        // Check if this error type should be retried
        if (shouldRetry != null && !shouldRetry(e)) {
          debugPrint('RetrySystem: Error not retryable: $e');
          rethrow;
        }

        // Notify retry callback
        onRetry?.call(attempt, e, delay);
        debugPrint('RetrySystem: Attempt $attempt failed ($e). Retrying in ${delay.inMilliseconds}ms...');

        // Wait with exponential backoff
        await Future.delayed(delay);

        // Calculate next delay (exponential backoff with cap)
        delay = Duration(
          milliseconds: (delay.inMilliseconds * 2).clamp(0, maxDelay.inMilliseconds),
        );
      }
    }
  }

  /// Execute with a simple timeout wrapper
  static Future<T> withTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 15),
    int maxRetries = 2,
  }) {
    return execute(
      maxRetries: maxRetries,
      operation: () => operation().timeout(timeout),
    );
  }
}

/// Mixin for adding retry capability to services
mixin RetryMixin {
  Future<T> retryOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
  }) {
    return RetrySystem.execute(
      operation: operation,
      maxRetries: maxRetries,
    );
  }
}

/// Result wrapper for operations that can fail gracefully
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result.success(this.data)
      : error = null,
        isSuccess = true;

  const Result.failure(this.error)
      : data = null,
        isSuccess = false;

  /// Map success value to a new type
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      return Result.success(transform(data as T));
    }
    return Result.failure(error);
  }

  /// Execute callback on success
  void onSuccess(void Function(T data) callback) {
    if (isSuccess && data != null) {
      callback(data as T);
    }
  }

  /// Execute callback on failure
  void onFailure(void Function(String error) callback) {
    if (!isSuccess && error != null) {
      callback(error!);
    }
  }
}
