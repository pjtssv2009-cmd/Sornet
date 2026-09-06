enum JobStatus {
  draft,
  open,
  shortlisted,
  interview,
  filled,
  closed,
  cancelled;

  String get label {
    switch (this) {
      case JobStatus.draft:
        return 'Draft';
      case JobStatus.open:
        return 'Open / Active';
      case JobStatus.shortlisted:
        return 'Shortlisted';
      case JobStatus.interview:
        return 'Interview Stage';
      case JobStatus.filled:
        return 'Filled';
      case JobStatus.closed:
        return 'Closed';
      case JobStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class Job {
  final String id;
  final String title;
  final String businessId;
  final String businessName;
  final String category;
  final String location;
  final String experienceRequired; // e.g. '3-5 Years'
  final String employmentType; // 'Full-time', 'Contract', 'Part-time'
  final String salary; // e.g. '₹28,000 - ₹35,000 / month'
  final int positionsCount;
  final int applicantsCount;
  final JobStatus status;
  final List<String> acExpertise;
  final String inverterType; // 'Inverter', 'Non-Inverter', 'Both'
  final List<String> brands;
  final String description;
  final DateTime createdDate;
  final DateTime joiningDate;
  final bool isApprovedByAdmin;

  Job({
    required this.id,
    required this.title,
    required this.businessId,
    required this.businessName,
    required this.category,
    required this.location,
    required this.experienceRequired,
    required this.employmentType,
    required this.salary,
    this.positionsCount = 1,
    this.applicantsCount = 0,
    required this.status,
    required this.acExpertise,
    required this.inverterType,
    required this.brands,
    required this.description,
    required this.createdDate,
    required this.joiningDate,
    this.isApprovedByAdmin = true,
  });

  Job copyWith({
    String? id,
    String? title,
    String? businessId,
    String? businessName,
    String? category,
    String? location,
    String? experienceRequired,
    String? employmentType,
    String? salary,
    int? positionsCount,
    int? applicantsCount,
    JobStatus? status,
    List<String>? acExpertise,
    String? inverterType,
    List<String>? brands,
    String? description,
    DateTime? createdDate,
    DateTime? joiningDate,
    bool? isApprovedByAdmin,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      category: category ?? this.category,
      location: location ?? this.location,
      experienceRequired: experienceRequired ?? this.experienceRequired,
      employmentType: employmentType ?? this.employmentType,
      salary: salary ?? this.salary,
      positionsCount: positionsCount ?? this.positionsCount,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      status: status ?? this.status,
      acExpertise: acExpertise ?? this.acExpertise,
      inverterType: inverterType ?? this.inverterType,
      brands: brands ?? this.brands,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      joiningDate: joiningDate ?? this.joiningDate,
      isApprovedByAdmin: isApprovedByAdmin ?? this.isApprovedByAdmin,
    );
  }
}
