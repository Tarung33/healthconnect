import 'dart:convert';

/// ============================================================
/// EMR REPORT MODEL
/// ============================================================
/// Represents a structured Electronic Medical Record generated
/// from doctor's voice.
/// ============================================================

class EmrReportModel {
  final String id;
  final String patientName;
  final String symptoms;
  final String diagnosis;
  final List<String> medicines;
  final String followUpAdvice;
  final DateTime date;
  final bool isApproved;

  EmrReportModel({
    required this.id,
    this.patientName = 'Unknown Patient',
    required this.symptoms,
    required this.diagnosis,
    required this.medicines,
    required this.followUpAdvice,
    required this.date,
    this.isApproved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'medicines': jsonEncode(medicines),
      'followUpAdvice': followUpAdvice,
      'date': date.toIso8601String(),
      'isApproved': isApproved ? 1 : 0,
    };
  }

  factory EmrReportModel.fromMap(Map<String, dynamic> map) {
    return EmrReportModel(
      id: map['id'],
      patientName: map['patientName'] ?? 'Unknown Patient',
      symptoms: map['symptoms'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      medicines: List<String>.from(jsonDecode(map['medicines'] ?? '[]')),
      followUpAdvice: map['followUpAdvice'] ?? '',
      date: DateTime.parse(map['date']),
      isApproved: map['isApproved'] == 1,
    );
  }
}
