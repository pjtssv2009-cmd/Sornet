import 'technician.dart';

enum ApplicationStatus {
  newApplication,
  shortlisted,
  interviewScheduled,
  offerSent,
  selected, // Hired
  rejected,
}

class Application {
  final String id;
  final String jobId;
  final String jobTitle;
  final String jobLocation;
  final Technician technician;
  final DateTime appliedDate;
  final ApplicationStatus status;
  final int matchPercentage;
  final String? coverNote;
  final String? rejectionReason;
  final DateTime? statusUpdatedAt;

  Application({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.jobLocation,
    required this.technician,
    required this.appliedDate,
    this.status = ApplicationStatus.newApplication,
    this.matchPercentage = 85,
    this.coverNote,
    this.rejectionReason,
    this.statusUpdatedAt,
  });

  Application copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? jobLocation,
    Technician? technician,
    DateTime? appliedDate,
    ApplicationStatus? status,
    int? matchPercentage,
    String? coverNote,
    String? rejectionReason,
    DateTime? statusUpdatedAt,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      jobLocation: jobLocation ?? this.jobLocation,
      technician: technician ?? this.technician,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      coverNote: coverNote ?? this.coverNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'jobId': jobId,
        'jobTitle': jobTitle,
        'jobLocation': jobLocation,
        'technician': technician.toJson(),
        'appliedDate': appliedDate.toIso8601String(),
        'status': status.name,
        'matchPercentage': matchPercentage,
        'coverNote': coverNote,
        'rejectionReason': rejectionReason,
        'statusUpdatedAt': statusUpdatedAt?.toIso8601String(),
      };

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        id: json['id'] as String,
        jobId: json['jobId'] as String,
        jobTitle: json['jobTitle'] as String,
        jobLocation: json['jobLocation'] as String,
        technician: Technician.fromJson(json['technician'] as Map<String, dynamic>),
        appliedDate: DateTime.parse(json['appliedDate'] as String),
        status: ApplicationStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ApplicationStatus.newApplication,
        ),
        matchPercentage: json['matchPercentage'] as int? ?? 85,
        coverNote: json['coverNote'] as String?,
        rejectionReason: json['rejectionReason'] as String?,
        statusUpdatedAt: json['statusUpdatedAt'] != null
            ? DateTime.parse(json['statusUpdatedAt'] as String)
            : null,
      );
}
