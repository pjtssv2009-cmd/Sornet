class PlatformModule {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isEnabled;
  final bool isCritical;
  final String iconName;

  PlatformModule({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.isEnabled = true,
    this.isCritical = false,
    required this.iconName,
  });

  PlatformModule copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    bool? isEnabled,
    bool? isCritical,
    String? iconName,
  }) {
    return PlatformModule(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      isEnabled: isEnabled ?? this.isEnabled,
      isCritical: isCritical ?? this.isCritical,
      iconName: iconName ?? this.iconName,
    );
  }
}
