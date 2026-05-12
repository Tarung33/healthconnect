import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../models/doctor_model.dart';
import '../widgets/doctor_card.dart';
import '../widgets/section_header.dart';
import 'live_consultation_screen.dart';

/// ============================================================
/// DOCTOR CONSULTATION SCREEN — Browse & book doctors
/// ============================================================
/// TODO: Replace mock data with API call to /api/doctors endpoint
/// ============================================================

class DoctorConsultationScreen extends StatefulWidget {
  const DoctorConsultationScreen({super.key});

  @override
  State<DoctorConsultationScreen> createState() => _DoctorConsultationScreenState();
}

class _DoctorConsultationScreenState extends State<DoctorConsultationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<DoctorModel> _doctors = DoctorModel.mockList();
  List<DoctorModel> _filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _filteredDoctors = _doctors;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDoctors = _doctors;
      } else {
        _filteredDoctors = _doctors.where((d) =>
          d.name.toLowerCase().contains(query.toLowerCase()) ||
          d.specialization.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  void _onBookDoctor(DoctorModel doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveConsultationScreen(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('consult_doctor'))),
      body: Column(
        children: [
          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.all(AppConstants.horizontalPadding),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDoctors,
              decoration: InputDecoration(
                hintText: '${t('search')}...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterDoctors('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // ── Doctor Count ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
            child: SectionHeader(
              title: '${t('available_doctors')} (${_filteredDoctors.length})',
            ),
          ),

          // ── Doctor List ──
          Expanded(
            child: _filteredDoctors.isEmpty
                ? Center(child: Text(t('no_doctors_found'), style: Theme.of(context).textTheme.bodyLarge))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: DoctorCard(
                          doctor: doctor,
                          onBookNow: () => _onBookDoctor(doctor),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
