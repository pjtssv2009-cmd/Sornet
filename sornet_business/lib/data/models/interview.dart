enum InterviewStatus {
  scheduled,
  completed,
  cancelled,
  rescheduled,
}

enum InterviewType {
  phoneCall,
  videoCall,
  inPerson,
}

class Interview {
  final String id;
  final String technicianId;
  final String technicianName;
  final String technicianPhoto;
  final String technicianPhone;
  final String jobId;
  final String jobTitle;
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
    required this.technicianId,
    required this.technicianName,
    required this.technicianPhoto,
    required this.technicianPhone,
    required this.jobId,
    required this.jobTitle,
    required this.scheduledAt,
    this.durationMinutes = 30,
    required this.type,
    required this.locationOrLink,
    this.notes,
    this.status = InterviewStatus.scheduled,
    this.feedback,
    required this.createdAt,
  });

  Interview copyWith({
    String? id,
    String? technicianId,
    String? technicianName,
    String? technicianPhoto,
    String? technicianPhone,
    String? jobId,
    String? jobTitle,
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
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhoto: technicianPhoto ?? this.technicianPhoto,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'technicianId': technicianId,
        'technicianName': technicianName,
        'technicianPhoto': technicianPhoto,
        'technicianPhone': technicianPhone,
        'jobId': jobId,
        'jobTitle': jobTitle,
        'scheduledAt': scheduledAt.toIso8601String(),
        'durationMinutes': durationMinutes,
        'type': type.name,
        'locationOrLink': locationOrLink,
        'notes': notes,
        'status': status.name,
        'feedback': feedback,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Interview.fromJson(Map<String, dynamic> json) => Interview(
        id: json['id'] as String,
        technicianId: json['technicianId'] as String,
        technicianName: json['technicianName'] as String,
        technicianPhoto: json['technicianPhoto'] as String,
        technicianPhone: json['technicianPhone'] as String,
        jobId: json['jobId'] as String,
        jobTitle: json['jobTitle'] as String,
        scheduledAt: DateTime.parse(json['scheduledAt'] as String),
        durationMinutes: json['durationMinutes'] as int? ?? 30,
        type: InterviewType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => InterviewType.phoneCall,
        ),
        locationOrLink: json['locationOrLink'] as String,
        notes: json['notes'] as String?,
        status: InterviewStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => InterviewStatus.scheduled,
        ),
        feedback: json['feedback'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
