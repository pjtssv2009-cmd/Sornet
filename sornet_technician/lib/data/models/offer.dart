enum OfferStatus {
  pending,
  accepted,
  rejected,
  expired;

  String get label {
    switch (this) {
      case OfferStatus.pending:
        return 'Pending Review';
      case OfferStatus.accepted:
        return 'Accepted';
      case OfferStatus.rejected:
        return 'Declined';
      case OfferStatus.expired:
        return 'Expired';
    }
  }

  int get badgeColorValue {
    switch (this) {
      case OfferStatus.pending:
        return 0xFFF79009;
      case OfferStatus.accepted:
        return 0xFF12B76A;
      case OfferStatus.rejected:
        return 0xFFF04438;
      case OfferStatus.expired:
        return 0xFF64748B;
    }
  }
}

class JobOffer {
  final String id;
  final String applicationId;
  final String jobId;
  final String jobTitle;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final bool isBusinessVerified;
  final String position;
  final int offeredSalary;
  final String salaryPeriod; // 'month', 'day', 'job'
  final String employmentType; // 'Full Time', 'Contract', 'Freelance'
  final DateTime joiningDate;
  final String workingHours;
  final String location;
  final String city;
  final List<String> benefits;
  final String? additionalTerms;
  final String? messageFromEmployer;
  final OfferStatus status;
  final DateTime sentDate;
  final DateTime expiryDate;
  final String? responseRemarks;
  final DateTime? responseDate;

  JobOffer({
    required this.id,
    required this.applicationId,
    required this.jobId,
    required this.jobTitle,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    this.isBusinessVerified = true,
    required this.position,
    required this.offeredSalary,
    this.salaryPeriod = 'month',
    required this.employmentType,
    required this.joiningDate,
    required this.workingHours,
    required this.location,
    required this.city,
    required this.benefits,
    this.additionalTerms,
    this.messageFromEmployer,
    this.status = OfferStatus.pending,
    required this.sentDate,
    required this.expiryDate,
    this.responseRemarks,
    this.responseDate,
  });

  String get jobType => employmentType;
  String? get probationPeriod => '3 Months';
  DateTime get validUntil => expiryDate;
  String? get specialInstructions => additionalTerms ?? messageFromEmployer;

  JobOffer copyWith({
    String? id,
    String? applicationId,
    String? jobId,
    String? jobTitle,
    String? businessId,
    String? businessName,
    String? businessLogo,
    bool? isBusinessVerified,
    String? position,
    int? offeredSalary,
    String? salaryPeriod,
    String? employmentType,
    DateTime? joiningDate,
    String? workingHours,
    String? location,
    String? city,
    List<String>? benefits,
    String? additionalTerms,
    String? messageFromEmployer,
    OfferStatus? status,
    DateTime? sentDate,
    DateTime? expiryDate,
    String? responseRemarks,
    DateTime? responseDate,
  }) {
    return JobOffer(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
      isBusinessVerified: isBusinessVerified ?? this.isBusinessVerified,
      position: position ?? this.position,
      offeredSalary: offeredSalary ?? this.offeredSalary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      employmentType: employmentType ?? this.employmentType,
      joiningDate: joiningDate ?? this.joiningDate,
      workingHours: workingHours ?? this.workingHours,
      location: location ?? this.location,
      city: city ?? this.city,
      benefits: benefits ?? this.benefits,
      additionalTerms: additionalTerms ?? this.additionalTerms,
      messageFromEmployer: messageFromEmployer ?? this.messageFromEmployer,
      status: status ?? this.status,
      sentDate: sentDate ?? this.sentDate,
      expiryDate: expiryDate ?? this.expiryDate,
      responseRemarks: responseRemarks ?? this.responseRemarks,
      responseDate: responseDate ?? this.responseDate,
    );
  }
}
