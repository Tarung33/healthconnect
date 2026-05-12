import 'package:flutter/material.dart';
import 'dart:async';
import '../config/app_colors.dart';
import '../models/emr_report_model.dart';
import '../services/voice_to_emr_service.dart';
import '../repositories/emr_repository.dart';

/// ============================================================
/// VOICE EMR SCREEN — For Doctors
/// ============================================================
/// Real-time speech to text that converts into a structured EMR.
/// ============================================================

class VoiceEmrScreen extends StatefulWidget {
  const VoiceEmrScreen({super.key});

  @override
  State<VoiceEmrScreen> createState() => _VoiceEmrScreenState();
}

class _VoiceEmrScreenState extends State<VoiceEmrScreen> {
  final VoiceToEmrService _voiceService = VoiceToEmrService();
  final EmrRepository _emrRepo = EmrRepository();

  bool _isRecording = false;
  bool _isProcessing = false;
  String _liveTranscript = '';
  StreamSubscription<String>? _transcriptSub;
  EmrReportModel? _generatedReport;

  @override
  void dispose() {
    _transcriptSub?.cancel();
    super.dispose();
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _liveTranscript = 'Listening...';
      _generatedReport = null;
    });

    _transcriptSub = _voiceService.simulateSpeechRecognition().listen((text) {
      setState(() => _liveTranscript = text);
    }, onDone: () {
      if (_isRecording) _stopRecording();
    });
  }

  Future<void> _stopRecording() async {
    _transcriptSub?.cancel();
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });

    try {
      final report = await _voiceService.processTranscript(_liveTranscript);
      setState(() {
        _generatedReport = report;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to process voice.')));
      }
    }
  }

  Future<void> _saveAndExport() async {
    if (_generatedReport != null) {
      await _emrRepo.saveReport(_generatedReport!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('EMR Saved Locally & PDF Exported!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice-to-EMR (Doctor Mode)'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Instructions ──
            const Text(
              'Dictate patient symptoms, diagnosis, and medicines. AI will automatically structure the record.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // ── Live Transcript Box ──
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _isRecording ? AppColors.error : Colors.grey.shade300, width: _isRecording ? 2 : 1),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _liveTranscript.isEmpty ? 'Tap the microphone to start...' : _liveTranscript,
                    style: TextStyle(fontSize: 18, color: _liveTranscript.isEmpty ? Colors.grey : Colors.black87),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Processing Indicator ──
            if (_isProcessing)
              Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('AI is extracting medical data...', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ],
              ),

            // ── Generated Report Card ──
            if (_generatedReport != null && !_isProcessing)
              Expanded(
                flex: 3,
                child: _buildReportCard(_generatedReport!),
              ),

            const SizedBox(height: 20),

            // ── Record Button ──
            if (_generatedReport == null && !_isProcessing)
              GestureDetector(
                onTap: _toggleRecording,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: _isRecording ? AppColors.error : AppColors.primary,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),

            // ── Action Buttons ──
            if (_generatedReport != null && !_isProcessing)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _generatedReport = null),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake'),
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _saveAndExport,
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Save & Export'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(EmrReportModel report) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Structured EMR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}), // Edit placeholder
                ],
              ),
              const Divider(),
              _detailRow('Patient:', report.patientName),
              _detailRow('Symptoms:', report.symptoms),
              _detailRow('Diagnosis:', report.diagnosis),
              const SizedBox(height: 8),
              const Text('Medicines:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              ...report.medicines.map((m) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 4),
                child: Text('• $m'),
              )),
              const SizedBox(height: 8),
              _detailRow('Advice:', report.followUpAdvice),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
