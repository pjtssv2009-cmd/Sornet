enum ActivityType {
  newTechnician,
  technicianVerified,
  businessVerificationSubmitted,
  businessVerified,
  newJobPosted,
  applicationReceived,
  hiredTechnician,
  systemUpdate,
}

class ActivityLog {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime timestamp;
  final String? entityId;
  final String? entityType;

  ActivityLog({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.entityId,
    this.entityType,
  });
}
