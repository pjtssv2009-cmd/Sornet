enum OfferStatus {
  sent,
  accepted,
  rejected,
  expired,
  cancelled,
}

class JobOffer {
  final String id;
  final String technicianId;
  final String technicianName;
  final String technicianPhoto;
  final String technicianPhone;
  final String jobId;
  final String jobTitle;
  final String position;
  final int salaryAmount;
  final String salaryPeriod; // 'month', 'day', 'job'
  final String employmentType; // 'Full Time', 'Contract', 'Freelance'
  final DateTime joiningDate;
  final String workingHours;
  final String location;
  final List<String> benefits;
  final String? additionalTerms;
  final String? personalMessage;
  final OfferStatus status;
  final DateTime sentDate;
  final DateTime expiryDate;
  final String? responseRemarks;
  final DateTime? responseDate;

  JobOffer({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.technicianPhoto,
    required this.technicianPhone,
    required this.jobId,
    required this.jobTitle,
    required this.position,
    required this.salaryAmount,
    this.salaryPeriod = 'month',
    required this.employmentType,
    required this.joiningDate,
    required this.workingHours,
    required this.location,
    required this.benefits,
    this.additionalTerms,
    this.personalMessage,
    this.status = OfferStatus.sent,
    required this.sentDate,
    required this.expiryDate,
    this.responseRemarks,
    this.responseDate,
  });

  JobOffer copyWith({
    String? id,
    String? technicianId,
    String? technicianName,
    String? technicianPhoto,
    String? technicianPhone,
    String? jobId,
    String? jobTitle,
    String? position,
    int? salaryAmount,
    String? salaryPeriod,
    String? employmentType,
    DateTime? joiningDate,
    String? workingHours,
    String? location,
    List<String>? benefits,
    String? additionalTerms,
    String? personalMessage,
    OfferStatus? status,
    DateTime? sentDate,
    DateTime? expiryDate,
    String? responseRemarks,
    DateTime? responseDate,
  }) {
    return JobOffer(
      id: id ?? this.id,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhoto: technicianPhoto ?? this.technicianPhoto,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      position: position ?? this.position,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      employmentType: employmentType ?? this.employmentType,
      joiningDate: joiningDate ?? this.joiningDate,
      workingHours: workingHours ?? this.workingHours,
      location: location ?? this.location,
      benefits: benefits ?? this.benefits,
      additionalTerms: additionalTerms ?? this.additionalTerms,
      personalMessage: personalMessage ?? this.personalMessage,
      status: status ?? this.status,
      sentDate: sentDate ?? this.sentDate,
      expiryDate: expiryDate ?? this.expiryDate,
      responseRemarks: responseRemarks ?? this.responseRemarks,
      responseDate: responseDate ?? this.responseDate,
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
        'position': position,
        'salaryAmount': salaryAmount,
        'salaryPeriod': salaryPeriod,
        'employmentType': employmentType,
        'joiningDate': joiningDate.toIso8601String(),
        'workingHours': workingHours,
        'location': location,
        'benefits': benefits,
        'additionalTerms': additionalTerms,
        'personalMessage': personalMessage,
        'status': status.name,
        'sentDate': sentDate.toIso8601String(),
        'expiryDate': expiryDate.toIso8601String(),
        'responseRemarks': responseRemarks,
        'responseDate': responseDate?.toIso8601String(),
      };

  factory JobOffer.fromJson(Map<String, dynamic> json) => JobOffer(
        id: json['id'] as String,
        technicianId: json['technicianId'] as String,
        technicianName: json['technicianName'] as String,
        technicianPhoto: json['technicianPhoto'] as String,
        technicianPhone: json['technicianPhone'] as String,
        jobId: json['jobId'] as String,
        jobTitle: json['jobTitle'] as String,
        position: json['position'] as String,
        salaryAmount: json['salaryAmount'] as int,
        salaryPeriod: json['salaryPeriod'] as String? ?? 'month',
        employmentType: json['employmentType'] as String,
        joiningDate: DateTime.parse(json['joiningDate'] as String),
        workingHours: json['workingHours'] as String,
        location: json['location'] as String,
        benefits: List<String>.from(json['benefits'] as List),
        additionalTerms: json['additionalTerms'] as String?,
        personalMessage: json['personalMessage'] as String?,
        status: OfferStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OfferStatus.sent,
        ),
        sentDate: DateTime.parse(json['sentDate'] as String),
        expiryDate: DateTime.parse(json['expiryDate'] as String),
        responseRemarks: json['responseRemarks'] as String?,
        responseDate: json['responseDate'] != null
            ? DateTime.parse(json['responseDate'] as String)
            : null,
      );
}
