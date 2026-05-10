/// ============================================================
/// HEALTH RECORD MODEL — Offline-stored health records
/// ============================================================

class HealthRecordModel {
  final String id;
  final String type; // prescription, lab_report, vaccination
  final String title;
  final String doctorName;
  final String diagnosis;
  final DateTime date;
  final bool isSyncedOnline;
  final String? notes;

  const HealthRecordModel({
    required this.id,
    required this.type,
    required this.title,
    required this.doctorName,
    required this.diagnosis,
    required this.date,
    this.isSyncedOnline = false,
    this.notes,
  });

  factory HealthRecordModel.fromJson(Map<String, dynamic> json) {
    return HealthRecordModel(
      id: json['id'] ?? '',
      type: json['type'] ?? 'prescription',
      title: json['title'] ?? '',
      doctorName: json['doctorName'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isSyncedOnline: json['isSyncedOnline'] ?? false,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type, 'title': title,
    'doctorName': doctorName, 'diagnosis': diagnosis,
    'date': date.toIso8601String(), 'isSyncedOnline': isSyncedOnline,
    'notes': notes,
  };

  /// Mock records for testing
  static List<HealthRecordModel> mockList() => [
    HealthRecordModel(id: 'r1', type: 'prescription', title: 'Fever Treatment',
      doctorName: 'Dr. Priya Sharma', diagnosis: 'Viral Fever',
      date: DateTime(2025, 12, 15), isSyncedOnline: true,
      notes: 'Paracetamol 500mg, 3 times daily for 5 days'),
    HealthRecordModel(id: 'r2', type: 'lab_report', title: 'Blood Test Report',
      doctorName: 'Dr. Ramesh Gowda', diagnosis: 'Routine Checkup',
      date: DateTime(2025, 11, 20), isSyncedOnline: true),
    HealthRecordModel(id: 'r3', type: 'vaccination', title: 'COVID-19 Booster',
      doctorName: 'PHC Hosahalli', diagnosis: 'Vaccination',
      date: DateTime(2025, 10, 5), isSyncedOnline: false),
    HealthRecordModel(id: 'r4', type: 'prescription', title: 'Skin Allergy',
      doctorName: 'Dr. Suresh Patil', diagnosis: 'Allergic Dermatitis',
      date: DateTime(2025, 9, 12), isSyncedOnline: false,
      notes: 'Cetirizine 10mg at night, calamine lotion'),
  ];
}
