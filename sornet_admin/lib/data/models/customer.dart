class CustomerServiceRecord {
  final String id;
  final String serviceName;
  final String technicianName;
  final DateTime date;
  final double amount;
  final String status; // 'Completed', 'In Progress', 'Cancelled'

  CustomerServiceRecord({
    required this.id,
    required this.serviceName,
    required this.technicianName,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class Customer {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String city;
  final bool isActive;
  final DateTime dateJoined;
  final int totalBookings;
  final int completedBookings;
  final double totalSpent;
  final List<CustomerServiceRecord> serviceHistory;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    this.isActive = true,
    required this.dateJoined,
    required this.totalBookings,
    required this.completedBookings,
    required this.totalSpent,
    required this.serviceHistory,
  });

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? city,
    bool? isActive,
    DateTime? dateJoined,
    int? totalBookings,
    int? completedBookings,
    double? totalSpent,
    List<CustomerServiceRecord>? serviceHistory,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      isActive: isActive ?? this.isActive,
      dateJoined: dateJoined ?? this.dateJoined,
      totalBookings: totalBookings ?? this.totalBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      totalSpent: totalSpent ?? this.totalSpent,
      serviceHistory: serviceHistory ?? this.serviceHistory,
    );
  }
}
