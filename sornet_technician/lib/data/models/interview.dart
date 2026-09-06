enum InterviewStatus {
  scheduled,
  completed,
  cancelled,
  rescheduled;

  String get label {
    switch (this) {
      case InterviewStatus.scheduled:
        return 'Scheduled';
      case InterviewStatus.completed:
        return 'Completed';
      case InterviewStatus.rescheduled:
        return 'Rescheduled';
      case InterviewStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get badgeColorValue {
    switch (this) {
      case InterviewStatus.scheduled:
        return 0xFF155EEF;
      case InterviewStatus.completed:
        return 0xFF12B76A;
      case InterviewStatus.rescheduled:
        return 0xFFF79009;
      case InterviewStatus.cancelled:
        return 0xFFF04438;
    }
  }
}

enum InterviewType {
  phoneCall,
  videoCall,
  inPerson;

  static const InterviewType phone = InterviewType.phoneCall;
  static const InterviewType video = InterviewType.videoCall;

  String get label {
    switch (this) {
      case InterviewType.phoneCall:
        return 'Phone Interview';
      case InterviewType.videoCall:
        return 'Video Call';
      case InterviewType.inPerson:
        return 'In-Person Venue';
    }
  }
}

class Interview {
  final String id;
  final String applicationId;
  final String jobId;
  final String jobTitle;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final bool isBusinessVerified;
  final String contactPerson;
  final String contactPhone;
  final DateTime scheduledAt;
  final int durationMinutes;
  final InterviewType type;
  final String locationOrLink;
  final String? notes;
  final InterviewStatus status;
  final String? feedback;
  final DateTime createdAt;

  Interview({
    required this.id,
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    this.isBusinessVerified = true,
    required this.contactPerson,
    required this.contactPhone,
    required this.scheduledAt,
    this.durationMinutes = 30,
    required this.type,
    required this.locationOrLink,
    this.notes,
    this.status = InterviewStatus.scheduled,
    this.feedback,
    required this.createdAt,
  });

  String? get meetingLink =>
      type == InterviewType.videoCall ? locationOrLink : null;
  String? get meetingPassword => 'SORNET2026';
  String? get locationAddress =>
      type == InterviewType.inPerson ? locationOrLink : null;
  String? get interviewerName => contactPerson;
  String? get interviewerRole => 'Technical Hiring Manager';
  String? get instructions => notes;
  String? get feedbackNotes => feedback;

  Interview copyWith({
    String? id,
    String? applicationId,
    String? jobId,
    String? jobTitle,
    String? businessId,
    String? businessName,
    String? businessLogo,
    bool? isBusinessVerified,
    String? contactPerson,
    String? contactPhone,
    DateTime? scheduledAt,
    int? durationMinutes,
    InterviewType? type,
    String? locationOrLink,
    String? notes,
    InterviewStatus? status,
    String? feedback,
    DateTime? createdAt,
  }) {
    return Interview(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
      isBusinessVerified: isBusinessVerified ?? this.isBusinessVerified,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      locationOrLink: locationOrLink ?? this.locationOrLink,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      feedback: feedback ?? this.feedback,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
