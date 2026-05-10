/// ============================================================
/// DOCTOR MODEL — Represents a doctor available for consultation
/// ============================================================

class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final int experienceYears;
  final double rating;
  final int consultationFee;
  final bool isAvailable;
  final String? imageUrl;
  final List<String> languages;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experienceYears,
    required this.rating,
    required this.consultationFee,
    this.isAvailable = true,
    this.imageUrl,
    this.languages = const ['en', 'hi'],
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experienceYears: json['experienceYears'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      consultationFee: json['consultationFee'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      imageUrl: json['imageUrl'],
      languages: List<String>.from(json['languages'] ?? ['en']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'experienceYears': experienceYears,
    'rating': rating,
    'consultationFee': consultationFee,
    'isAvailable': isAvailable,
    'imageUrl': imageUrl,
    'languages': languages,
  };

  /// Mock doctors for testing
  static List<DoctorModel> mockList() => [
    const DoctorModel(
      id: 'd1', name: 'Dr. Priya Sharma', specialization: 'General Physician',
      experienceYears: 12, rating: 4.8, consultationFee: 200,
      languages: ['en', 'hi'],
    ),
    const DoctorModel(
      id: 'd2', name: 'Dr. Ramesh Gowda', specialization: 'Pediatrician',
      experienceYears: 8, rating: 4.6, consultationFee: 300,
      languages: ['en', 'kn'],
    ),
    const DoctorModel(
      id: 'd3', name: 'Dr. Anjali Desai', specialization: 'Gynecologist',
      experienceYears: 15, rating: 4.9, consultationFee: 500,
      languages: ['en', 'hi', 'kn'],
    ),
    const DoctorModel(
      id: 'd4', name: 'Dr. Suresh Patil', specialization: 'Dermatologist',
      experienceYears: 10, rating: 4.5, consultationFee: 350,
      isAvailable: false, languages: ['en', 'kn'],
    ),
    const DoctorModel(
      id: 'd5', name: 'Dr. Kavitha Nair', specialization: 'General Physician',
      experienceYears: 6, rating: 4.7, consultationFee: 150,
      languages: ['en', 'hi'],
    ),
  ];
}
