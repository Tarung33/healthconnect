import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/medicine_model.dart';
import '../models/pharmacy_delivery_models.dart';
import '../repositories/medicine_repository.dart';

/// ============================================================
/// MEDICINE TRACKING SYSTEM
/// ============================================================
/// Features: Stock search, Pharmacy tracking, ASHA worker 
/// dispatch tracking, Shortage alerts, and Requests.
/// ============================================================

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MedicineRepository _repository = MedicineRepository();
  
  // Data
  List<MedicineModel> _allMedicines = [];
  List<MedicineModel> _filtered = [];
  final List<PharmacyModel> _pharmacies = PharmacyModel.mockList();
  final List<DeliveryModel> _deliveries = DeliveryModel.mockList();
  
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final cached = await _repository.getCachedMedicines();
    // Simulate lightweight syncing
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _allMedicines = cached;
        _filtered = cached;
        _isLoading = false;
      });
    }
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _allMedicines;
      } else {
        _filtered = _allMedicines.where((m) =>
          m.name.toLowerCase().contains(query.toLowerCase()) ||
          m.genericName.toLowerCase().contains(query.toLowerCase()) ||
          m.storeName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Tracking'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Search & Stock'),
            Tab(text: 'Track Deliveries'),
            Tab(text: 'Alerts & Requests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStockTab(),
          _buildDeliveriesTab(),
          _buildAlertsTab(),
        ],
      ),
    );
  }

  // ── TAB 1: Search & Stock ──
  Widget _buildStockTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Search Bar ──
        Padding(
          padding: const EdgeInsets.all(AppConstants.horizontalPadding),
          child: TextField(
            controller: _searchController,
            onChanged: _search,
            decoration: InputDecoration(
              hintText: 'Search medicines or pharmacies...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _search('');
                      },
                    )
                  : null,
            ),
          ),
        ),

        // ── Nearby Pharmacies (Horizontal List) ──
        if (_searchController.text.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
            child: const Text('Nearby Pharmacies', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
              itemCount: _pharmacies.length,
              itemBuilder: (context, index) {
                final p = _pharmacies[index];
                return Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(child: Text('${p.distance} • ${p.address}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                          const SizedBox(width: 4),
                          Text(p.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Text(p.isOpen ? 'Open Now' : 'Closed', style: TextStyle(fontSize: 12, color: p.isOpen ? AppColors.success : AppColors.error, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
        ],

        // ── Medicine Stock List ──
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filtered.isEmpty
                  ? Center(child: Text(t('no_medicines_found')))
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final med = _filtered[index];
                        return _buildMedicineStockCard(med);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildMedicineStockCard(MedicineModel med) {
    Color stockColor;
    if (med.stockPercentage > 50) stockColor = AppColors.success;
    else if (med.stockPercentage > 15) stockColor = AppColors.warning;
    else stockColor = AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.medication, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(med.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(med.genericName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Text('₹${med.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.storefront, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(med.storeName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                const Spacer(),
                Text('${med.distance} away', style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            // Stock Percentage Bar
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: med.stockPercentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    color: stockColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${med.stockPercentage}% Stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: stockColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── TAB 2: Track Deliveries ──
  Widget _buildDeliveriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      itemCount: _deliveries.length,
      itemBuilder: (context, index) {
        final delivery = _deliveries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(delivery.medicineName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(delivery.status, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.local_shipping, color: Colors.grey, size: 20),
                    const SizedBox(width: 8),
                    const Text('Govt. Dispatch ➔ ASHA Worker', style: TextStyle(color: Colors.black87, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: delivery.progress,
                  backgroundColor: Colors.grey.shade200,
                  color: AppColors.primary,
                  minHeight: 6,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Assigned To', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(delivery.ashaWorkerName, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Est. Arrival', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(delivery.estimatedArrival, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── TAB 3: Alerts & Requests ──
  Widget _buildAlertsTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.horizontalPadding),
      children: [
        // Shortage Alert
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning, color: AppColors.error),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Severe Shortage Alert', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('ORS Sachets are currently out of stock in your primary health centre. Govt dispatch is delayed by 2 days.', style: TextStyle(color: Colors.black87, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Request Form
        const Text('Request Medicine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('If you need a medicine not available locally, request it through your ASHA worker.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Medicine Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Quantity Needed',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request sent to ASHA worker network!')));
            },
            icon: const Icon(Icons.send),
            label: const Text('Submit Request'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
