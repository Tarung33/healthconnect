import 'dart:async';
import '../models/chat_message_model.dart';
import '../l10n/app_localizations.dart';

/// ============================================================
/// AI CHAT SERVICE — Mock backend for Medical Assistant
/// ============================================================
/// Simulates network delay, emergency detection, and generates
/// structured AI assessments.
/// ============================================================

class AiChatService {
  final List<String> _emergencyKeywords = ['chest pain', 'heart', 'heart attack', 'bleeding', 'unconscious', 'stroke', 'breath', 'breathing', 'choking', 'poison', 'एहतियात', 'छाती', 'सांस', 'खून'];

  Future<ChatMessage> sendMessage(String text) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final lowerText = text.toLowerCase();

    // 1. Emergency Detection
    bool isEmergency = false;
    for (var keyword in _emergencyKeywords) {
      if (lowerText.contains(keyword)) {
        isEmergency = true;
        break;
      }
    }

    if (isEmergency) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.ai,
        text: "This sounds like a medical emergency. Please call an ambulance or visit the nearest hospital immediately.",
        timestamp: DateTime.now(),
        isEmergency: true,
      );
    }

    // 2. Mock Analysis based on keywords
    if (lowerText.contains('fever') || lowerText.contains('बुखार') || lowerText.contains('ಬಿಸಿ') || lowerText.contains('ತಲೆನೋವು')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.ai,
        text: "Based on your symptoms, it could be a viral infection. Here is my assessment. Note: This is an AI assessment and not a medical diagnosis.",
        timestamp: DateTime.now(),
        assessment: AssessmentCard(
          probableIllness: 'Viral Fever / Common Cold',
          precautions: ['Drink plenty of warm fluids', 'Take adequate rest', 'Monitor temperature every 4 hours'],
          urgencyLevel: 'Moderate',
          consultDoctor: true,
        ),
      );
    }

    if (lowerText.contains('stomach') || lowerText.contains('pain') || lowerText.contains('पेट')) {
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        role: MessageRole.ai,
        text: "Stomach pain can be caused by various factors like indigestion or acidity. Please see the details below.",
        timestamp: DateTime.now(),
        assessment: AssessmentCard(
          probableIllness: 'Indigestion / Gastritis',
          precautions: ['Avoid spicy food', 'Drink enough water', 'Eat light meals like rice/porridge'],
          urgencyLevel: 'Low',
          consultDoctor: false,
        ),
      );
    }

    // 3. Fallback response for unknown symptoms
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: MessageRole.ai,
      text: "I am an AI assistant. Can you please provide more details about your symptoms so I can help you better? Remember I cannot provide an exact diagnosis.",
      timestamp: DateTime.now(),
    );
  }
}
