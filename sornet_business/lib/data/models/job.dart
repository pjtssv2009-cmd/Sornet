enum JobStatus {
  active,
  draft,
  closed,
}

class Job {
  final String id;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final String title;
  final String category;
  final String experienceRequired;
  final String technicianType; // Full Time, Contract, etc.
  final List<String> skillsRequired; // Split AC, VRF, etc.
  final List<String> technicalExpertise; // Inverter, Non-Inverter
  final List<String> brands; // Daikin, LG, Voltas, etc.
  final List<String> requiredServices; // Installation, PCB repair, etc.
  final String location;
  final String city;
  final int minSalary;
  final int maxSalary;
  final String salaryPeriod; // 'month', 'day', 'job'
  final int positionsCount;
  final DateTime joiningDate;
  final String workingHours;
  final String description;
  final List<String> benefits;
  final String additionalRequirements;
  final JobStatus status;
  final DateTime postedDate;
  final int applicantsCount;
  final int shortlistedCount;
  final int interviewsCount;
  final int hiredCount;

  Job({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    required this.title,
    required this.category,
    required this.experienceRequired,
    required this.technicianType,
    required this.skillsRequired,
    required this.technicalExpertise,
    required this.brands,
    required this.requiredServices,
    required this.location,
    required this.city,
    required this.minSalary,
    required this.maxSalary,
    this.salaryPeriod = 'month',
    required this.positionsCount,
    required this.joiningDate,
    required this.workingHours,
    required this.description,
    required this.benefits,
    this.additionalRequirements = '',
    this.status = JobStatus.active,
    required this.postedDate,
    this.applicantsCount = 0,
    this.shortlistedCount = 0,
    this.interviewsCount = 0,
    this.hiredCount = 0,
  });

  Job copyWith({
    String? id,
    String? businessId,
    String? businessName,
    String? businessLogo,
    String? title,
    String? category,
    String? experienceRequired,
    String? technicianType,
    List<String>? skillsRequired,
    List<String>? technicalExpertise,
    List<String>? brands,
    List<String>? requiredServices,
    String? location,
    String? city,
    int? minSalary,
    int? maxSalary,
    String? salaryPeriod,
    int? positionsCount,
    DateTime? joiningDate,
    String? workingHours,
    String? description,
    List<String>? benefits,
    String? additionalRequirements,
    JobStatus? status,
    DateTime? postedDate,
    int? applicantsCount,
    int? shortlistedCount,
    int? interviewsCount,
    int? hiredCount,
  }) {
    return Job(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
      title: title ?? this.title,
      category: category ?? this.category,
      experienceRequired: experienceRequired ?? this.experienceRequired,
      technicianType: technicianType ?? this.technicianType,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      technicalExpertise: technicalExpertise ?? this.technicalExpertise,
      brands: brands ?? this.brands,
      requiredServices: requiredServices ?? this.requiredServices,
      location: location ?? this.location,
      city: city ?? this.city,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      positionsCount: positionsCount ?? this.positionsCount,
      joiningDate: joiningDate ?? this.joiningDate,
      workingHours: workingHours ?? this.workingHours,
      description: description ?? this.description,
      benefits: benefits ?? this.benefits,
      additionalRequirements: additionalRequirements ?? this.additionalRequirements,
      status: status ?? this.status,
      postedDate: postedDate ?? this.postedDate,
      applicantsCount: applicantsCount ?? this.applicantsCount,
      shortlistedCount: shortlistedCount ?? this.shortlistedCount,
      interviewsCount: interviewsCount ?? this.interviewsCount,
      hiredCount: hiredCount ?? this.hiredCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessId': businessId,
        'businessName': businessName,
        'businessLogo': businessLogo,
        'title': title,
        'category': category,
        'experienceRequired': experienceRequired,
        'technicianType': technicianType,
        'skillsRequired': skillsRequired,
        'technicalExpertise': technicalExpertise,
        'brands': brands,
        'requiredServices': requiredServices,
        'location': location,
        'city': city,
        'minSalary': minSalary,
        'maxSalary': maxSalary,
        'salaryPeriod': salaryPeriod,
        'positionsCount': positionsCount,
        'joiningDate': joiningDate.toIso8601String(),
        'workingHours': workingHours,
        'description': description,
        'benefits': benefits,
        'additionalRequirements': additionalRequirements,
        'status': status.name,
        'postedDate': postedDate.toIso8601String(),
        'applicantsCount': applicantsCount,
        'shortlistedCount': shortlistedCount,
        'interviewsCount': interviewsCount,
        'hiredCount': hiredCount,
      };

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json['id'] as String,
        businessId: json['businessId'] as String,
        businessName: json['businessName'] as String,
        businessLogo: json['businessLogo'] as String,
        title: json['title'] as String,
        category: json['category'] as String,
        experienceRequired: json['experienceRequired'] as String,
        technicianType: json['technicianType'] as String,
        skillsRequired: List<String>.from(json['skillsRequired'] as List),
        technicalExpertise: List<String>.from(json['technicalExpertise'] as List),
        brands: List<String>.from(json['brands'] as List),
        requiredServices: List<String>.from(json['requiredServices'] as List),
        location: json['location'] as String,
        city: json['city'] as String,
        minSalary: json['minSalary'] as int,
        maxSalary: json['maxSalary'] as int,
        salaryPeriod: json['salaryPeriod'] as String? ?? 'month',
        positionsCount: json['positionsCount'] as int,
        joiningDate: DateTime.parse(json['joiningDate'] as String),
        workingHours: json['workingHours'] as String,
        description: json['description'] as String,
        benefits: List<String>.from(json['benefits'] as List),
        additionalRequirements: json['additionalRequirements'] as String? ?? '',
        status: JobStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => JobStatus.active,
        ),
        postedDate: DateTime.parse(json['postedDate'] as String),
        applicantsCount: json['applicantsCount'] as int? ?? 0,
        shortlistedCount: json['shortlistedCount'] as int? ?? 0,
        interviewsCount: json['interviewsCount'] as int? ?? 0,
        hiredCount: json['hiredCount'] as int? ?? 0,
      );
}
