enum NotificationType {
  newApplication,
  technicianShortlisted,
  interviewReminder,
  offerAccepted,
  offerRejected,
  jobExpiring,
  technicianRecommendation,
  adminVerificationUpdate,
  generalAlert,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? referenceId; // jobId, applicantId, interviewId, offerId
  final String? actionRoute;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.referenceId,
    this.actionRoute,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? referenceId,
    String? actionRoute,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      referenceId: referenceId ?? this.referenceId,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'message': message,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'referenceId': referenceId,
        'actionRoute': actionRoute,
      };

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        id: json['id'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        type: NotificationType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => NotificationType.generalAlert,
        ),
        timestamp: DateTime.parse(json['timestamp'] as String),
        isRead: json['isRead'] as bool? ?? false,
        referenceId: json['referenceId'] as String?,
        actionRoute: json['actionRoute'] as String?,
      );
}
