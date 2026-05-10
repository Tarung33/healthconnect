import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/medicine_model.dart';
import '../widgets/medicine_card.dart';

/// ============================================================
/// MEDICINE AVAILABILITY SCREEN — Search & check medicine stock
/// ============================================================
/// TODO: Connect to /api/medicines endpoint for real-time data
/// ============================================================

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<MedicineModel> _allMedicines = MedicineModel.mockList();
  List<MedicineModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = _allMedicines;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _allMedicines;
      } else {
        _filtered = _allMedicines.where((m) =>
          m.name.toLowerCase().contains(query.toLowerCase()) ||
          m.genericName.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('medicine_availability'))),
      body: Column(
        children: [
          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: t('search_medicine'),
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

          // ── Results Count ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filtered.length} ${t('medicines').toLowerCase()} found',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── Medicine List ──
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text('No medicines found', style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: MedicineCard(medicine: _filtered[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
