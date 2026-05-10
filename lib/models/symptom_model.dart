/// ============================================================
/// SYMPTOM MODEL — Represents a selectable symptom
/// ============================================================

class SymptomModel {
  final String id;
  final String key; // Localization key (e.g., 'fever', 'headache')
  final String icon;
  final String severity; // mild, moderate, severe

  const SymptomModel({
    required this.id,
    required this.key,
    this.icon = '🩺',
    this.severity = 'mild',
  });

  /// All common symptoms available for selection
  static List<SymptomModel> commonSymptoms() => [
    const SymptomModel(id: 's1', key: 'fever', icon: '🤒'),
    const SymptomModel(id: 's2', key: 'headache', icon: '🤕'),
    const SymptomModel(id: 's3', key: 'cough', icon: '😷'),
    const SymptomModel(id: 's4', key: 'cold', icon: '🤧'),
    const SymptomModel(id: 's5', key: 'body_pain', icon: '💪'),
    const SymptomModel(id: 's6', key: 'stomach_pain', icon: '🤢'),
    const SymptomModel(id: 's7', key: 'vomiting', icon: '🤮'),
    const SymptomModel(id: 's8', key: 'diarrhea', icon: '🚽'),
    const SymptomModel(id: 's9', key: 'fatigue', icon: '😴'),
    const SymptomModel(id: 's10', key: 'sore_throat', icon: '🗣️'),
    const SymptomModel(id: 's11', key: 'breathing_difficulty', icon: '😮‍💨'),
    const SymptomModel(id: 's12', key: 'chest_pain', icon: '❤️‍🩹'),
    const SymptomModel(id: 's13', key: 'skin_rash', icon: '🔴'),
    const SymptomModel(id: 's14', key: 'joint_pain', icon: '🦴'),
    const SymptomModel(id: 's15', key: 'dizziness', icon: '💫'),
    const SymptomModel(id: 's16', key: 'loss_of_appetite', icon: '🍽️'),
  ];
}
