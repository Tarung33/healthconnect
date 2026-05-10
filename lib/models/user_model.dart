/// ============================================================
/// USER MODEL — Represents a registered user
/// ============================================================

class UserModel {
  final String id;
  final String fullName;
  final String phone;
  final String? email;
  final String? aadhaarNumber;
  final String? abhaId;
  final String? village;
  final String? profileImageUrl;
  final String preferredLanguage;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.aadhaarNumber,
    this.abhaId,
    this.village,
    this.profileImageUrl,
    this.preferredLanguage = 'en',
    required this.createdAt,
  });

  /// Create from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      aadhaarNumber: json['aadhaarNumber'],
      abhaId: json['abhaId'],
      village: json['village'],
      profileImageUrl: json['profileImageUrl'],
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  /// Convert to JSON (for API / local storage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'aadhaarNumber': aadhaarNumber,
      'abhaId': abhaId,
      'village': village,
      'profileImageUrl': profileImageUrl,
      'preferredLanguage': preferredLanguage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a mock user for testing
  factory UserModel.mock() {
    return UserModel(
      id: 'mock_user_001',
      fullName: 'Rajesh Kumar',
      phone: '+91 9876543210',
      email: 'rajesh.kumar@email.com',
      aadhaarNumber: '1234 5678 9012',
      abhaId: '12-3456-7890-1234',
      village: 'Hosahalli, Karnataka',
      preferredLanguage: 'en',
      createdAt: DateTime(2025, 1, 15),
    );
  }

  /// Copy with modified fields
  UserModel copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? village,
    String? preferredLanguage,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      aadhaarNumber: aadhaarNumber,
      abhaId: abhaId,
      village: village ?? this.village,
      profileImageUrl: profileImageUrl,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt,
    );
  }
}
