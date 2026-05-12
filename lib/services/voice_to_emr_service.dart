import 'dart:async';
import 'dart:math';
import '../models/emr_report_model.dart';

/// ============================================================
/// VOICE TO EMR SERVICE — NLP & STT Placeholder
/// ============================================================
/// Mocks the process of taking noisy clinic audio and extracting
/// structured medical data.
/// ============================================================

class VoiceToEmrService {
  /// Simulates continuous speech-to-text transcript building
  Stream<String> simulateSpeechRecognition() async* {
    final script = [
      "Patient complains of ",
      "severe headache ",
      "and mild fever ",
      "since yesterday. ",
      "Diagnosed with ",
      "viral infection. ",
      "Prescribed ",
      "Paracetamol 500mg ",
      "twice a day ",
      "and advised rest. ",
      "Come back after 3 days if fever persists."
    ];

    String transcript = "";
    for (var phrase in script) {
      await Future.delayed(Duration(milliseconds: 600 + Random().nextInt(400)));
      transcript += phrase;
      yield transcript;
    }
  }

  /// Processes the final transcript into a structured EMR via NLP
  Future<EmrReportModel> processTranscript(String transcript) async {
    // Simulate NLP processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple mock keyword extraction logic
    String symptoms = "Headache, Mild Fever";
    String diagnosis = "Viral Infection";
    List<String> medicines = ["Paracetamol 500mg (BD)"];
    String advice = "Rest. Follow up in 3 days if fever persists.";

    return EmrReportModel(
      id: 'emr_${DateTime.now().millisecondsSinceEpoch}',
      patientName: 'John Doe',
      symptoms: symptoms,
      diagnosis: diagnosis,
      medicines: medicines,
      followUpAdvice: advice,
      date: DateTime.now(),
    );
  }
}
