import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../models/admin_analytics_model.dart';

/// ============================================================
/// ADMIN DASHBOARD SCREEN (Rural Healthcare Analytics)
/// ============================================================
/// Used by government officials / primary health authorities
/// to monitor district health, epidemics, and shortages.
/// ============================================================

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<VillageStat> _villageStats = AdminAnalyticsData.getVillageStats();
  final List<MedicineShortage> _shortages = AdminAnalyticsData.getShortages();
  final List<EmergencyAlert> _alerts = AdminAnalyticsData.getAlerts();
  final List<SymptomTrend> _trends = AdminAnalyticsData.getTrends();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('District Health Analytics'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── OVERVIEW CARDS ──
            Row(
              children: [
                Expanded(child: _buildMetricCard('Active\nConsults', '59', Icons.video_call, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('Critical\nCases', '10', Icons.warning, Colors.red)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('Available\nDoctors', '14/20', Icons.medical_services, Colors.green)),
              ],
            ),
            const SizedBox(height: 24),

            // ── EMERGENCY ALERTS ──
            if (_alerts.any((a) => !a.isResolved)) ...[
              const Text('⚠️ Active Emergency Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 8),
              ..._alerts.where((a) => !a.isResolved).map((alert) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.red.shade50, border: Border.all(color: Colors.red.shade200), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.emergency, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          Text('${alert.location} • ${alert.timestamp}', style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: const Size(60, 32)),
                      child: const Text('Action'),
                    )
                  ],
                ),
              )),
              const SizedBox(height: 24),
            ],

            // ── AI SYMPTOM TRENDS ──
            const Text('📈 AI Symptom Trends (Last 7 Days)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _trends.map((trend) {
                    final isSpike = trend.percentageIncrease > 20;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(trend.symptom, style: const TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: trend.count / 300, // normalized max
                                    backgroundColor: Colors.grey.shade200,
                                    color: isSpike ? Colors.orange : Colors.indigo,
                                    minHeight: 8,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(trend.count.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_upward, size: 14, color: isSpike ? Colors.red : Colors.grey),
                                Text('${trend.percentageIncrease}%', style: TextStyle(color: isSpike ? Colors.red : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── VILLAGE HEALTH HEATMAP (MOCK) ──
            const Text('🗺️ Village Health Index', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: _villageStats.map((stat) {
                    Color healthColor;
                    if (stat.healthScore > 0.7) healthColor = Colors.green;
                    else if (stat.healthScore > 0.4) healthColor = Colors.orange;
                    else healthColor = Colors.red;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: healthColor),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(stat.villageName, style: const TextStyle(fontWeight: FontWeight.w600))),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${stat.activeConsultations} Consults', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              if (stat.criticalPatients > 0)
                                Text('${stat.criticalPatients} Critical', style: const TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── MEDICINE SHORTAGE MAP ──
            const Text('💊 Critical Medicine Shortages', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _shortages.length,
                separatorBuilder: (c, i) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final shortage = _shortages[index];
                  final isCritical = shortage.shortageLevel > 0.8;
                  return ListTile(
                    leading: Icon(Icons.medication, color: isCritical ? Colors.red : Colors.orange),
                    title: Text(shortage.medicineName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(shortage.phcName),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCritical ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('${(shortage.shortageLevel * 100).toInt()}% Deficit', 
                        style: TextStyle(color: isCritical ? Colors.red : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
