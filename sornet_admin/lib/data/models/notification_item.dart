enum NotificationType {
  technicianVerification,
  businessVerification,
  jobPosted,
  technicianRegistered,
  businessRegistered,
  systemAlert,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? targetEntityId;
  final String? targetEntityType; // 'technician', 'business', 'job', 'application'

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.targetEntityId,
    this.targetEntityType,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? targetEntityId,
    String? targetEntityType,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      targetEntityId: targetEntityId ?? this.targetEntityId,
      targetEntityType: targetEntityType ?? this.targetEntityType,
    );
  }
}
