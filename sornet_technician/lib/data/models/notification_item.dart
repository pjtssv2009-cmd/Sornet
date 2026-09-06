enum NotificationType {
  jobMatch,
  applicationSubmitted,
  applicationViewed,
  shortlisted,
  interviewScheduled,
  interviewReminder,
  offerReceived,
  offerAccepted,
  jobStarted,
  jobCompleted,
  newRating,
  verificationUpdate,
  profileReminder,
  // Aliases for easy handling
  applicationStatus,
  interviewInvite,
  jobOffer,
  verification,
  jobAlert,
  message,
  system;
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? targetId; // Job ID, Interview ID, Offer ID, Application ID

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.targetId,
  });

  String get body => message;
  DateTime get createdAt => timestamp;
  String? get referenceId => targetId;

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? targetId,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      targetId: targetId ?? this.targetId,
    );
  }
}
