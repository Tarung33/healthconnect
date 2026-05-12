/// ============================================================
/// CHAT MESSAGE MODEL — For AI Symptom Checker Assistant
/// ============================================================

enum MessageRole { user, ai, system }

class ChatMessage {
  final String id;
  final MessageRole role;
  final String text;
  final DateTime timestamp;
  final AssessmentCard? assessment;
  final bool isEmergency;

  ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
    this.assessment,
    this.isEmergency = false,
  });
}

class AssessmentCard {
  final String probableIllness;
  final List<String> precautions;
  final String urgencyLevel; // e.g. "Low", "Moderate", "High"
  final bool consultDoctor;

  AssessmentCard({
    required this.probableIllness,
    required this.precautions,
    required this.urgencyLevel,
    required this.consultDoctor,
  });
}
