/// ============================================================
/// PHARMACY & DELIVERY MODELS
/// ============================================================

class PharmacyModel {
  final String id;
  final String name;
  final String distance;
  final String address;
  final bool isOpen;
  final double rating;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.distance,
    required this.address,
    this.isOpen = true,
    required this.rating,
  });

  static List<PharmacyModel> mockList() => [
    PharmacyModel(id: 'p1', name: 'Jan Aushadhi Kendra', distance: '1.2 km', address: 'Main Market Square', rating: 4.8),
    PharmacyModel(id: 'p2', name: 'Village Medical Store', distance: '0.5 km', address: 'Near Panchayat Bhawan', rating: 4.2),
    PharmacyModel(id: 'p3', name: 'PHC Pharmacy', distance: '3.0 km', address: 'Primary Health Centre', rating: 4.5),
  ];
}

class DeliveryModel {
  final String id;
  final String medicineName;
  final String status; // 'Dispatched', 'With ASHA Worker', 'Delivered'
  final String ashaWorkerName;
  final String estimatedArrival;
  final double progress; // 0.0 to 1.0

  DeliveryModel({
    required this.id,
    required this.medicineName,
    required this.status,
    required this.ashaWorkerName,
    required this.estimatedArrival,
    required this.progress,
  });

  static List<DeliveryModel> mockList() => [
    DeliveryModel(
      id: 'd1',
      medicineName: 'Metformin 500mg',
      status: 'With ASHA Worker',
      ashaWorkerName: 'Sita Devi',
      estimatedArrival: 'Today, 4:00 PM',
      progress: 0.8,
    ),
    DeliveryModel(
      id: 'd2',
      medicineName: 'Amoxicillin 250mg',
      status: 'Govt. Dispatched',
      ashaWorkerName: 'Pending assignment',
      estimatedArrival: 'Tomorrow, 11:00 AM',
      progress: 0.4,
    ),
  ];
}
