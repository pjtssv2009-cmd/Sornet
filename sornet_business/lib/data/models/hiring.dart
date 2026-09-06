enum HiringStatus {
  upcoming,
  active,
  completed,
}

class HiredTechnician {
  final String id;
  final String technicianId;
  final String technicianName;
  final String technicianPhoto;
  final String technicianPhone;
  final String jobId;
  final String jobTitle;
  final String position;
  final int salary;
  final String salaryPeriod;
  final String employmentType;
  final DateTime joiningDate;
  final DateTime? completionDate;
  final HiringStatus status;
  final double rating;
  final bool hasBeenReviewed;
  final String location;

  HiredTechnician({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.technicianPhoto,
    required this.technicianPhone,
    required this.jobId,
    required this.jobTitle,
    required this.position,
    required this.salary,
    this.salaryPeriod = 'month',
    required this.employmentType,
    required this.joiningDate,
    this.completionDate,
    this.status = HiringStatus.active,
    this.rating = 4.8,
    this.hasBeenReviewed = false,
    required this.location,
  });

  HiredTechnician copyWith({
    String? id,
    String? technicianId,
    String? technicianName,
    String? technicianPhoto,
    String? technicianPhone,
    String? jobId,
    String? jobTitle,
    String? position,
    int? salary,
    String? salaryPeriod,
    String? employmentType,
    DateTime? joiningDate,
    DateTime? completionDate,
    HiringStatus? status,
    double? rating,
    bool? hasBeenReviewed,
    String? location,
  }) {
    return HiredTechnician(
      id: id ?? this.id,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhoto: technicianPhoto ?? this.technicianPhoto,
      technicianPhone: technicianPhone ?? this.technicianPhone,
      jobId: jobId ?? this.jobId,
      jobTitle: jobTitle ?? this.jobTitle,
      position: position ?? this.position,
      salary: salary ?? this.salary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      employmentType: employmentType ?? this.employmentType,
      joiningDate: joiningDate ?? this.joiningDate,
      completionDate: completionDate ?? this.completionDate,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      hasBeenReviewed: hasBeenReviewed ?? this.hasBeenReviewed,
      location: location ?? this.location,
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
        'salary': salary,
        'salaryPeriod': salaryPeriod,
        'employmentType': employmentType,
        'joiningDate': joiningDate.toIso8601String(),
        'completionDate': completionDate?.toIso8601String(),
        'status': status.name,
        'rating': rating,
        'hasBeenReviewed': hasBeenReviewed,
        'location': location,
      };

  factory HiredTechnician.fromJson(Map<String, dynamic> json) => HiredTechnician(
        id: json['id'] as String,
        technicianId: json['technicianId'] as String,
        technicianName: json['technicianName'] as String,
        technicianPhoto: json['technicianPhoto'] as String,
        technicianPhone: json['technicianPhone'] as String,
        jobId: json['jobId'] as String,
        jobTitle: json['jobTitle'] as String,
        position: json['position'] as String,
        salary: json['salary'] as int,
        salaryPeriod: json['salaryPeriod'] as String? ?? 'month',
        employmentType: json['employmentType'] as String,
        joiningDate: DateTime.parse(json['joiningDate'] as String),
        completionDate: json['completionDate'] != null
            ? DateTime.parse(json['completionDate'] as String)
            : null,
        status: HiringStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => HiringStatus.active,
        ),
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        hasBeenReviewed: json['hasBeenReviewed'] as bool? ?? false,
        location: json['location'] as String,
      );
}
