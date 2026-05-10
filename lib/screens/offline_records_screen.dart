import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/health_record_model.dart';
import '../widgets/record_card.dart';

/// ============================================================
/// OFFLINE RECORDS SCREEN — View locally-saved health records
/// ============================================================
/// Records are categorized into tabs: All, Prescriptions,
/// Lab Reports, Vaccinations. Each shows sync status.
/// ============================================================

class OfflineRecordsScreen extends StatefulWidget {
  const OfflineRecordsScreen({super.key});

  @override
  State<OfflineRecordsScreen> createState() => _OfflineRecordsScreenState();
}

class _OfflineRecordsScreenState extends State<OfflineRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<HealthRecordModel> _records = HealthRecordModel.mockList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<HealthRecordModel> _filterByType(String? type) {
    if (type == null) return _records;
    return _records.where((r) => r.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t('health_records')),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'All (${_records.length})'),
            Tab(text: '${t('prescriptions')} (${_filterByType('prescription').length})'),
            Tab(text: '${t('lab_reports')} (${_filterByType('lab_report').length})'),
            Tab(text: '${t('vaccination')} (${_filterByType('vaccination').length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecordList(null),
          _buildRecordList('prescription'),
          _buildRecordList('lab_report'),
          _buildRecordList('vaccination'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add record screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add record feature coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(t('add_record')),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildRecordList(String? type) {
    final filtered = _filterByType(type);

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, size: 64, color: AppColors.dividerLight),
            const SizedBox(height: 16),
            Text(t('no_records'), style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return RecordCard(
          record: filtered[index],
          onTap: () {
            // TODO: Navigate to record detail screen
            _showRecordDetail(filtered[index]);
          },
        );
      },
    );
  }

  void _showRecordDetail(HealthRecordModel record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(record.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              _detailRow(Icons.person, '${t('record_doctor')}: ${record.doctorName}'),
              _detailRow(Icons.medical_information, '${t('record_diagnosis')}: ${record.diagnosis}'),
              _detailRow(Icons.calendar_today, '${t('record_date')}: ${record.date.toString().split(' ')[0]}'),
              if (record.notes != null) ...[
                const SizedBox(height: 8),
                Text('Notes:', style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(record.notes!, style: theme.textTheme.bodyMedium),
              ],
              _detailRow(
                record.isSyncedOnline ? Icons.cloud_done : Icons.cloud_off,
                record.isSyncedOnline ? 'Synced online' : t('saved_offline'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondaryLight),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
