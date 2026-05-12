import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/doctor_model.dart';
import '../services/network_quality_service.dart';
import 'offline_first_aid_screen.dart';

/// ============================================================
/// LIVE CONSULTATION SCREEN — Adaptive Telemedicine UI
/// ============================================================
/// Adapts to network quality:
/// - Good: Video Call
/// - Weak: Audio Call + Chat + Compressed Image Upload
/// - None: Offline First Aid + SMS SOS
/// ============================================================

class LiveConsultationScreen extends StatefulWidget {
  final DoctorModel doctor;

  const LiveConsultationScreen({super.key, required this.doctor});

  @override
  State<LiveConsultationScreen> createState() => _LiveConsultationScreenState();
}

class _LiveConsultationScreenState extends State<LiveConsultationScreen> {
  final NetworkQualityService _networkService = NetworkQualityService();
  NetworkQuality _quality = NetworkQuality.good;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkNetwork();
  }

  Future<void> _checkNetwork() async {
    setState(() => _isLoading = true);
    final quality = await _networkService.checkQuality();
    if (mounted) {
      setState(() {
        _quality = quality;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Connecting...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation: Dr. ${widget.doctor.name}'),
        backgroundColor: _quality == NetworkQuality.none 
            ? AppColors.error 
            : (_quality == NetworkQuality.weak ? AppColors.warning : AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recheck Connection',
            onPressed: _checkNetwork,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_quality) {
      case NetworkQuality.good:
        return _buildVideoCallUI();
      case NetworkQuality.weak:
        return _buildAudioChatUI();
      case NetworkQuality.none:
        return _buildOfflineUI();
    }
  }

  // ── 1. Good Internet: Video Call UI ──
  Widget _buildVideoCallUI() {
    return Stack(
      children: [
        // Main Remote Video Placeholder
        Container(
          color: Colors.black87,
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: Icon(Icons.videocam, color: Colors.white24, size: 100),
          ),
        ),
        // Local Video Thumbnail
        Positioned(
          top: 20,
          right: 20,
          child: Container(
            width: 100,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Center(child: Icon(Icons.person, color: Colors.white, size: 50)),
          ),
        ),
        // Network Indicator
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.signal_cellular_4_bar, color: AppColors.success, size: 16),
                SizedBox(width: 8),
                Text('HD Video', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
        // Call Controls
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _controlBtn(Icons.mic, Colors.white38),
              _controlBtn(Icons.call_end, AppColors.error, isLarge: true, onTap: () => Navigator.pop(context)),
              _controlBtn(Icons.videocam, Colors.white38),
            ],
          ),
        ),
      ],
    );
  }

  // ── 2. Weak Internet: Audio + Text Chat UI ──
  Widget _buildAudioChatUI() {
    return Column(
      children: [
        // Audio Call Header
        Container(
          padding: const EdgeInsets.all(20),
          color: AppColors.warning.withOpacity(0.1),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.warning,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Audio Call (Weak Network)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('02:45 • Encrypted', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call_end, color: AppColors.error, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        // Chat Area
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _chatBubble('Hello doctor, my throat hurts.', isUser: true),
              _chatBubble('Have you had any fever?', isUser: false),
            ],
          ),
        ),
        // Input Area
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, color: AppColors.primary),
                  tooltip: 'Upload Compressed Image',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image compressed and sent via low-bandwidth mode.')),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── 3. No Internet: Offline First Aid & SOS ──
  Widget _buildOfflineUI() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: AppColors.error),
          const SizedBox(height: 20),
          const Text(
            'No Internet Connection',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.error),
          ),
          const SizedBox(height: 10),
          const Text(
            'Cannot connect to the doctor. Please check your connection or use the offline tools below in case of an emergency.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 40),
          // Large SOS Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.sos, size: 32),
              label: const Text('Send SOS via SMS (108)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('SOS SMS triggered!')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // First Aid Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.medical_services, size: 32),
              label: const Text('Offline First Aid Guides', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OfflineFirstAidScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _controlBtn(IconData icon, Color bg, {bool isLarge = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: isLarge ? 35 : 25,
        backgroundColor: bg,
        child: Icon(icon, color: Colors.white, size: isLarge ? 32 : 24),
      ),
    );
  }

  Widget _chatBubble(String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
