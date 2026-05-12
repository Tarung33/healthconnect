import 'package:flutter/material.dart';
import '../config/app_colors.dart';

/// ============================================================
/// OFFLINE FIRST AID SCREEN
/// ============================================================
/// Simple offline-first aid manual
/// ============================================================

class OfflineFirstAidScreen extends StatelessWidget {
  const OfflineFirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Aid Guides')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGuideCard(
            title: 'CPR (Cardiopulmonary Resuscitation)',
            description: 'Push hard and fast in the center of the chest at a rate of 100 to 120 compressions a minute.',
            icon: Icons.favorite,
            color: AppColors.error,
          ),
          _buildGuideCard(
            title: 'Severe Bleeding',
            description: 'Apply firm, direct pressure to the wound with a clean cloth. Keep the injured area elevated.',
            icon: Icons.bloodtype,
            color: AppColors.error,
          ),
          _buildGuideCard(
            title: 'Choking',
            description: 'Perform the Heimlich maneuver: 5 back blows and 5 abdominal thrusts.',
            icon: Icons.warning,
            color: AppColors.warning,
          ),
          _buildGuideCard(
            title: 'Burns',
            description: 'Cool the burn under cool (not cold) running water for at least 10 minutes. Do not apply ice.',
            icon: Icons.local_fire_department,
            color: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard({required String title, required String description, required IconData icon, required Color color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
