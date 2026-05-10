import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'doctor_consultation_screen.dart';
import 'symptom_checker_screen.dart';
import 'offline_records_screen.dart';
import 'profile_screen.dart';

/// ============================================================
/// MAIN SHELL — Bottom Navigation Bar wrapper
/// ============================================================
/// Contains 5 tabs: Home, Consult, AI Check, Records, Profile.
/// Large touch targets for rural user accessibility.
/// ============================================================

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Screens managed by the bottom nav
  final List<Widget> _screens = const [
    HomeScreen(),
    DoctorConsultationScreen(),
    SymptomCheckerScreen(),
    OfflineRecordsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: t('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.medical_services_outlined),
            activeIcon: const Icon(Icons.medical_services),
            label: t('nav_consult'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.psychology_outlined),
            activeIcon: const Icon(Icons.psychology),
            label: t('nav_ai_check'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder_outlined),
            activeIcon: const Icon(Icons.folder),
            label: t('nav_records'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: t('nav_profile'),
          ),
        ],
      ),
    );
  }
}
