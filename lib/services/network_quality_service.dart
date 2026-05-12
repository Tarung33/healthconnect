import 'dart:async';
import 'dart:math';

/// ============================================================
/// NETWORK QUALITY SERVICE
/// ============================================================
/// Simulates checking the quality of the internet connection.
/// Returns 'good', 'weak', or 'none'.
/// In a real app, this would use ping times or WebRTC stats.
/// ============================================================

enum NetworkQuality { good, weak, none }

class NetworkQualityService {
  static final NetworkQualityService _instance = NetworkQualityService._internal();
  factory NetworkQualityService() => _instance;
  NetworkQualityService._internal();

  /// Mock function to get current network quality.
  /// Randomly cycles through states for testing purposes,
  /// but defaults to 'good' mostly.
  Future<NetworkQuality> checkQuality() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // For demonstration, let's randomly return a quality state 
    // to test the adaptive UI. 50% good, 30% weak, 20% none.
    final rand = Random().nextInt(10);
    if (rand < 2) return NetworkQuality.none;
    if (rand < 5) return NetworkQuality.weak;
    return NetworkQuality.good;
  }
}
