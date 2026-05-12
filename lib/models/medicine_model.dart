/// ============================================================
/// MEDICINE MODEL — Represents medicine availability data
/// ============================================================

class MedicineModel {
  final String id;
  final String name;
  final String genericName;
  final double price;
  final bool isAvailable;
  final bool hasGeneric;
  final String storeName;
  final String distance;
  final String? manufacturer;
  final int stockPercentage; // 0 to 100

  const MedicineModel({
    required this.id,
    required this.name,
    required this.genericName,
    required this.price,
    this.isAvailable = true,
    this.hasGeneric = false,
    required this.storeName,
    required this.distance,
    this.manufacturer,
    this.stockPercentage = 100, // Default for backwards compatibility
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      genericName: json['genericName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? true,
      hasGeneric: json['hasGeneric'] ?? false,
      storeName: json['storeName'] ?? '',
      distance: json['distance'] ?? '',
      manufacturer: json['manufacturer'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'genericName': genericName,
    'price': price, 'isAvailable': isAvailable, 'hasGeneric': hasGeneric,
    'storeName': storeName, 'distance': distance, 'manufacturer': manufacturer,
  };

  /// Mock medicines for testing
  static List<MedicineModel> mockList() => [
    const MedicineModel(id: 'm1', name: 'Paracetamol 500mg', genericName: 'Acetaminophen',
      price: 25.0, storeName: 'Jan Aushadhi Kendra', distance: '1.2 km', hasGeneric: true, manufacturer: 'Cipla', stockPercentage: 85),
    const MedicineModel(id: 'm2', name: 'Amoxicillin 250mg', genericName: 'Amoxicillin',
      price: 85.0, storeName: 'Village Medical Store', distance: '0.5 km', manufacturer: 'Sun Pharma', stockPercentage: 40),
    const MedicineModel(id: 'm3', name: 'Cetirizine 10mg', genericName: 'Cetirizine HCl',
      price: 15.0, storeName: 'Jan Aushadhi Kendra', distance: '1.2 km', hasGeneric: true, manufacturer: 'Dr. Reddy\'s', stockPercentage: 10),
    const MedicineModel(id: 'm4', name: 'Metformin 500mg', genericName: 'Metformin HCl',
      price: 45.0, storeName: 'PHC Pharmacy', distance: '3.0 km', hasGeneric: true, manufacturer: 'USV', stockPercentage: 60),
    const MedicineModel(id: 'm5', name: 'ORS Sachets', genericName: 'Oral Rehydration Salts',
      price: 12.0, isAvailable: false, storeName: 'Village Medical Store', distance: '0.5 km', stockPercentage: 0),
  ];
}
