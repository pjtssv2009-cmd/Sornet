enum ApplicationStatus {
  applied,
  reviewed,
  shortlisted,
  interviewScheduled,
  offerReceived,
  hired,
  rejected,
  withdrawn,
}

class TimelineStep {
  final String title;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;
  final bool isCurrent;

  TimelineStep({
    required this.title,
    required this.description,
    this.timestamp,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class Application {
  final String id;
  final String jobId;
  final String jobTitle;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final bool isBusinessVerified;
  final String location;
  final String city;
  final int minSalary;
  final int maxSalary;
  final String salaryPeriod;
  final String technicianType;
  final DateTime appliedDate;
  final ApplicationStatus status;
  final int expectedSalary;
  final String availability;
  final String? coverNote;
  final String? rejectionReason;
  final List<TimelineStep> timeline;

  Application({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    this.isBusinessVerified = true,
    required this.location,
    required this.city,
    required this.minSalary,
    required this.maxSalary,
    this.salaryPeriod = 'month',
    required this.technicianType,
    required this.appliedDate,
    this.status = ApplicationStatus.applied,
    required this.expectedSalary,
    required this.availability,
    this.coverNote,
    this.rejectionReason,
    required this.timeline,
  });

  Application copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? businessId,
    String? businessName,
    String? businessLogo,
    bool? isBusinessVerified,
    String? location,
    String? city,
    int? minSalary,
    int? maxSalary,
    String? salaryPeriod,
    String? technicianType,
    DateTime? appliedDate,
    ApplicationStatus? status,
    int? expectedSalary,
    String? availability,
    String? coverNote,
    String? rejectionReason,
    List<TimelineStep>? timeline,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
      isBusinessVerified: isBusinessVerified ?? this.isBusinessVerified,
      location: location ?? this.location,
      city: city ?? this.city,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      technicianType: technicianType ?? this.technicianType,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      availability: availability ?? this.availability,
      coverNote: coverNote ?? this.coverNote,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      timeline: timeline ?? this.timeline,
    );
  }
}
