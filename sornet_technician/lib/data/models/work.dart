enum WorkStatus {
  upcoming,
  active,
  completed;

  String get label {
    switch (this) {
      case WorkStatus.upcoming:
        return 'Upcoming';
      case WorkStatus.active:
        return 'Active';
      case WorkStatus.completed:
        return 'Completed';
    }
  }

  int get badgeColorValue {
    switch (this) {
      case WorkStatus.upcoming:
        return 0xFF0BA5EC;
      case WorkStatus.active:
        return 0xFF12B76A;
      case WorkStatus.completed:
        return 0xFF64748B;
    }
  }
}

class WorkRecord {
  final String id;
  final String offerId;
  final String jobId;
  final String jobTitle;
  final String position;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final bool isBusinessVerified;
  final String contactPerson;
  final String contactPhone;
  final String workLocation;
  final String city;
  final int salary;
  final String salaryPeriod;
  final String employmentType;
  final String workingHours;
  final DateTime startDate;
  final DateTime? completionDate;
  final List<String> responsibilities;
  final String workSummary;
  final WorkStatus status;
  final bool isRatedByTechnician;

  WorkRecord({
    required this.id,
    required this.offerId,
    required this.jobId,
    required this.jobTitle,
    required this.position,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    this.isBusinessVerified = true,
    required this.contactPerson,
    required this.contactPhone,
    required this.workLocation,
    required this.city,
    required this.salary,
    this.salaryPeriod = 'month',
    required this.employmentType,
    required this.workingHours,
    required this.startDate,
    this.completionDate,
    required this.responsibilities,
    this.workSummary = '',
    this.status = WorkStatus.active,
    this.isRatedByTechnician = false,
  });

  String get location => city.isNotEmpty ? '$city, Tamil Nadu' : workLocation;
  int get agreedSalary => salary;
  String? get supervisorName => contactPerson;
  String? get supervisorContact => contactPhone;
  String get workAddress => workLocation;
  List<String> get tasksSummary => responsibilities;
  String? get notes => workSummary.isNotEmpty ? workSummary : null;
  bool get hasReviewedBusiness => isRatedByTechnician;
  DateTime? get endDate => completionDate;

  WorkRecord copyWith({
    String? id,
    String? offerId,
    String? jobId,
    String? jobTitle,
    String? position,
    String? businessId,
    String? businessName,
    String? businessLogo,
    bool? isBusinessVerified,
    String? contactPerson,
    String? contactPhone,
    String? workLocation,
    String? city,
    int? salary,
    String? salaryPeriod,
    String? employmentType,
    String? workingHours,
    DateTime? startDate,
    DateTime? completionDate,
    List<String>? responsibilities,
    String? workSummary,
    WorkStatus? status,
    bool? isRatedByTechnician,
  }) {
    return WorkRecord(
      id: id ?? this.id,
      offerId: offerId ?? this.offerId,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      position: position ?? this.position,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
      isBusinessVerified: isBusinessVerified ?? this.isBusinessVerified,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      workLocation: workLocation ?? this.workLocation,
      city: city ?? this.city,
      salary: salary ?? this.salary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      employmentType: employmentType ?? this.employmentType,
      workingHours: workingHours ?? this.workingHours,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      responsibilities: responsibilities ?? this.responsibilities,
      workSummary: workSummary ?? this.workSummary,
      status: status ?? this.status,
      isRatedByTechnician: isRatedByTechnician ?? this.isRatedByTechnician,
    );
  }
}
