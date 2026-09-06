enum ApplicationStatus {
  applied,
  shortlisted,
  interview,
  selected,
  rejected,
  withdrawn;

  String get label {
    switch (this) {
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.shortlisted:
        return 'Shortlisted';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.selected:
        return 'Selected';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}

class Application {
  final String id;
  final String jobId;
  final String jobTitle;
  final String businessName;
  final String technicianId;
  final String technicianName;
  final String technicianSkill;
  final String technicianLocation;
  final int technicianExperience;
  final double technicianRating;
  final DateTime appliedDate;
  final ApplicationStatus status;
  final String expectedSalary;
  final String coverNote;

  Application({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.businessName,
    required this.technicianId,
    required this.technicianName,
    required this.technicianSkill,
    required this.technicianLocation,
    required this.technicianExperience,
    required this.technicianRating,
    required this.appliedDate,
    required this.status,
    required this.expectedSalary,
    this.coverNote = '',
  });

  Application copyWith({
    String? id,
    String? jobId,
    String? jobTitle,
    String? businessName,
    String? technicianId,
    String? technicianName,
    String? technicianSkill,
    String? technicianLocation,
    int? technicianExperience,
    double? technicianRating,
    DateTime? appliedDate,
    ApplicationStatus? status,
    String? expectedSalary,
    String? coverNote,
  }) {
    return Application(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      businessName: businessName ?? this.businessName,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianSkill: technicianSkill ?? this.technicianSkill,
      technicianLocation: technicianLocation ?? this.technicianLocation,
      technicianExperience: technicianExperience ?? this.technicianExperience,
      technicianRating: technicianRating ?? this.technicianRating,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      coverNote: coverNote ?? this.coverNote,
    );
  }
}
