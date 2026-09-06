class ServiceCategory {
  final String id;
  final String name;
  final String icon; // Icon name string
  final String description;
  final bool isActive;
  final int technicianCount;
  final int jobsCount;
  final List<String> subcategories;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.isActive = true,
    this.technicianCount = 0,
    this.jobsCount = 0,
    this.subcategories = const [],
  });

  ServiceCategory copyWith({
    String? id,
    String? name,
    String? icon,
    String? description,
    bool? isActive,
    int? technicianCount,
    int? jobsCount,
    List<String>? subcategories,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      technicianCount: technicianCount ?? this.technicianCount,
      jobsCount: jobsCount ?? this.jobsCount,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}
