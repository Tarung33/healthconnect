/// ============================================================
/// ADMIN ANALYTICS MODELS
/// ============================================================

class VillageStat {
  final String villageName;
  final int activeConsultations;
  final int criticalPatients;
  final double healthScore;

  VillageStat({required this.villageName, required this.activeConsultations, required this.criticalPatients, required this.healthScore});
}

class MedicineShortage {
  final String medicineName;
  final String phcName;
  final double shortageLevel; // 0.0 to 1.0 (1.0 is critical shortage)

  MedicineShortage({required this.medicineName, required this.phcName, required this.shortageLevel});
}

class EmergencyAlert {
  final String title;
  final String location;
  final String timestamp;
  final bool isResolved;

  EmergencyAlert({required this.title, required this.location, required this.timestamp, required this.isResolved});
}

class SymptomTrend {
  final String symptom;
  final int count;
  final double percentageIncrease;

  SymptomTrend({required this.symptom, required this.count, required this.percentageIncrease});
}

class AdminAnalyticsData {
  static List<VillageStat> getVillageStats() => [
    VillageStat(villageName: 'Hosahalli', activeConsultations: 12, criticalPatients: 2, healthScore: 0.8),
    VillageStat(villageName: 'Rampura', activeConsultations: 24, criticalPatients: 5, healthScore: 0.4),
    VillageStat(villageName: 'Shivapura', activeConsultations: 8, criticalPatients: 0, healthScore: 0.9),
    VillageStat(villageName: 'Kalluru', activeConsultations: 15, criticalPatients: 3, healthScore: 0.6),
  ];

  static List<MedicineShortage> getShortages() => [
    MedicineShortage(medicineName: 'ORS Sachets', phcName: 'Rampura PHC', shortageLevel: 0.95),
    MedicineShortage(medicineName: 'Paracetamol', phcName: 'Kalluru PHC', shortageLevel: 0.70),
    MedicineShortage(medicineName: 'Amoxicillin', phcName: 'Hosahalli PHC', shortageLevel: 0.40),
  ];

  static List<EmergencyAlert> getAlerts() => [
    EmergencyAlert(title: 'Cholera Outbreak Suspected', location: 'Rampura Cluster', timestamp: '10 mins ago', isResolved: false),
    EmergencyAlert(title: 'ASHA Worker SOS', location: 'Shivapura East', timestamp: '1 hr ago', isResolved: true),
  ];

  static List<SymptomTrend> getTrends() => [
    SymptomTrend(symptom: 'High Fever', count: 145, percentageIncrease: 12.5),
    SymptomTrend(symptom: 'Watery Diarrhea', count: 89, percentageIncrease: 45.0), // High jump
    SymptomTrend(symptom: 'Persistent Cough', count: 210, percentageIncrease: 2.1),
  ];
}
