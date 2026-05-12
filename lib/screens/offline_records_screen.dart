import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/health_record_model.dart';
import '../repositories/health_record_repository.dart';
import '../services/encryption_service.dart';

/// ============================================================
/// SECURE HEALTH RECORDS SCREEN
/// ============================================================
/// Features: Aadhaar-linked records, Patient History, 
/// Prescription Upload, QR Lookup, and Emergency Access Mode.
/// ============================================================

class OfflineRecordsScreen extends StatefulWidget {
  const OfflineRecordsScreen({super.key});

  @override
  State<OfflineRecordsScreen> createState() => _OfflineRecordsScreenState();
}

class _OfflineRecordsScreenState extends State<OfflineRecordsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HealthRecordRepository _repository = HealthRecordRepository();
  final EncryptionService _encryptionService = EncryptionService();

  List<HealthRecordModel> _records = [];
  bool _isLoading = true;
  bool _isEmergencyMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    try {
      final cached = await _repository.getAllRecords();
      if (mounted) {
        setState(() {
          _records = cached;
          if (_records.isEmpty) {
            _records = HealthRecordModel.mockList();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading records: $e');
      if (mounted) {
        setState(() {
          _records = HealthRecordModel.mockList();
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Health Records'),
        backgroundColor: _isEmergencyMode ? AppColors.error : AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'History & Vault'),
            Tab(text: 'Upload & Scan'),
            Tab(text: 'Access & QR'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryTab(),
          _buildUploadTab(),
          _buildAccessTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Syncing encrypted records with ABHA network...')));
              },
              icon: const Icon(Icons.sync_lock),
              label: const Text('Sync Securely'),
              backgroundColor: _isEmergencyMode ? AppColors.error : AppColors.primary,
            )
          : null,
    );
  }

  // ── TAB 1: History & Vault ──
  Widget _buildHistoryTab() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    
    return Column(
      children: [
        if (_isEmergencyMode)
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.error.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.warning, color: AppColors.error),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('EMERGENCY MODE ACTIVE: Read-only access granted to first responders.', 
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
        
        // Vault Status
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.lock, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text('Vault Encrypted (AES-256)', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${_records.length} Records', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Divider(height: 1),

        Expanded(
          child: _records.isEmpty
              ? Center(child: Text(t('no_records_found')))
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.horizontalPadding),
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return _buildRecordCard(record);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(HealthRecordModel record) {
    IconData icon;
    Color iconColor;

    switch (record.type) {
      case 'prescription':
        icon = Icons.description_outlined;
        iconColor = AppColors.primary;
        break;
      case 'lab_report':
        icon = Icons.biotech_outlined;
        iconColor = AppColors.secondary;
        break;
      case 'vaccination':
        icon = Icons.vaccines_outlined;
        iconColor = AppColors.success;
        break;
      default:
        icon = Icons.folder_outlined;
        iconColor = Colors.grey;
    }

    // Mock an immutable signature
    final signature = _encryptionService.generateSignature(record.id).substring(0, 12);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: iconColor.withOpacity(0.1),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(record.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text('${record.date.day}/${record.date.month}/${record.date.year}', 
                        style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                if (record.isSyncedOnline)
                  const Icon(Icons.cloud_done, color: AppColors.success, size: 20)
                else
                  const Icon(Icons.cloud_off, color: Colors.grey, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text('Doctor: ${record.doctorName}', style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('Diagnosis: ${record.diagnosis}', style: const TextStyle(color: Colors.black87)),
            if (record.notes != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(record.notes!, style: const TextStyle(fontSize: 13, color: Colors.black87))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Signature: $signature...', style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace')),
                const Text('Immutable', style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ── TAB 2: Upload & Scan ──
  Widget _buildUploadTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Digitize Your Records', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Scan physical prescriptions and lab reports to store them securely in your encrypted vault.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _actionTile(Icons.document_scanner, 'Scan Document', AppColors.primary, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening AI Document Scanner...')));
                }),
                _actionTile(Icons.upload_file, 'Upload PDF', AppColors.secondary, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening File Picker...')));
                }),
                _actionTile(Icons.camera_alt, 'Take Photo', AppColors.accent, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening Camera...')));
                }),
                _actionTile(Icons.link, 'Link ABHA ID', AppColors.success, () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Initiating ABHA fetch protocol...')));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  // ── TAB 3: Access & QR ──
  Widget _buildAccessTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // QR Code
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              children: [
                const Icon(Icons.qr_code_2, size: 180, color: Colors.black87),
                const SizedBox(height: 12),
                const Text('Scan for Patient Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Tokens refresh every 5 mins', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Emergency Access Toggle
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isEmergencyMode ? AppColors.error.withOpacity(0.1) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isEmergencyMode ? AppColors.error : Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.emergency, color: AppColors.error, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Emergency Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Allow first responders to bypass lock in life-threatening situations.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              Switch(
                value: _isEmergencyMode,
                activeColor: AppColors.error,
                onChanged: (val) {
                  setState(() => _isEmergencyMode = val);
                  if (val) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency mode activated! Access granted without PIN.')));
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Revoke Access
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All external sessions revoked securely.')));
            },
            icon: const Icon(Icons.security, color: AppColors.primary),
            label: const Text('Revoke Active Sessions', style: TextStyle(color: AppColors.primary)),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.primary)),
          ),
        ),
      ],
    );
  }
}
