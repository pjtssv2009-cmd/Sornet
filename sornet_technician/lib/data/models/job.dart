enum JobStatus {
  active,
  closed,
  draft,
  expired,
}

enum JobType {
  fullTime,
  partTime,
  contract,
  freelance,
}

class Job {
  final String id;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final bool isBusinessVerified;
  final double businessRating;
  final String title;
  final String category;
  final String experienceRequired;
  final String technicianType; // 'Full Time', 'Contract', 'Freelance'
  final List<String> skillsRequired;
  final List<String> acTypes;
  final List<String> acTechnologies;
  final List<String> brands;
  final List<String> requiredServices;
  final String location;
  final String city;
  final double distanceKm;
  final int minSalary;
  final int maxSalary;
  final String salaryPeriod; // 'month', 'day', 'job'
  final int positionsCount;
  final DateTime joiningDate;
  final String workingHours;
  final String description;
  final String requirements;
  final List<String> benefits;
  final JobStatus status;
  final DateTime postedDate;
  final DateTime applicationDeadline;
  final bool isSaved;
  final bool hasApplied;

  Job({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    this.isBusinessVerified = true,
    this.businessRating = 4.8,
    required this.title,
    required this.category,
    required this.experienceRequired,
    required this.technicianType,
    required this.skillsRequired,
    required this.acTypes,
    required this.acTechnologies,
    required this.brands,
    required this.requiredServices,
    required this.location,
    required this.city,
    this.distanceKm = 4.5,
    required this.minSalary,
    required this.maxSalary,
    this.salaryPeriod = 'month',
    this.positionsCount = 2,
    required this.joiningDate,
    required this.workingHours,
    required this.description,
    required this.requirements,
    required this.benefits,
    this.status = JobStatus.active,
    required this.postedDate,
    required this.applicationDeadline,
    this.isSaved = false,
    this.hasApplied = false,
  });

  Job copyWith({
    String? id,
    String? businessId,
    String? businessName,
    String? businessLogo,
    bool? isBusinessVerified,
    double? businessRating,
    String? title,
    String? category,
    String? experienceRequired,
    String? technicianType,
    List<String>? skillsRequired,
    List<String>? acTypes,
    List<String>? acTechnologies,
    List<String>? brands,
    List<String>? requiredServices,
    String? location,
    String? city,
    double? distanceKm,
    int? minSalary,
    int? maxSalary,
    String? salaryPeriod,
    int? positionsCount,
    DateTime? joiningDate,
    String? workingHours,
    String? description,
    String? requirements,
    List<String>? benefits,
    JobStatus? status,
    DateTime? postedDate,
    DateTime? applicationDeadline,
    bool? isSaved,
    bool? hasApplied,
  }) {
    return Job(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
      isBusinessVerified: isBusinessVerified ?? this.isBusinessVerified,
      businessRating: businessRating ?? this.businessRating,
      title: title ?? this.title,
      category: category ?? this.category,
      experienceRequired: experienceRequired ?? this.experienceRequired,
      technicianType: technicianType ?? this.technicianType,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      acTypes: acTypes ?? this.acTypes,
      acTechnologies: acTechnologies ?? this.acTechnologies,
      brands: brands ?? this.brands,
      requiredServices: requiredServices ?? this.requiredServices,
      location: location ?? this.location,
      city: city ?? this.city,
      distanceKm: distanceKm ?? this.distanceKm,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      positionsCount: positionsCount ?? this.positionsCount,
      joiningDate: joiningDate ?? this.joiningDate,
      workingHours: workingHours ?? this.workingHours,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      benefits: benefits ?? this.benefits,
      status: status ?? this.status,
      postedDate: postedDate ?? this.postedDate,
      applicationDeadline: applicationDeadline ?? this.applicationDeadline,
      isSaved: isSaved ?? this.isSaved,
      hasApplied: hasApplied ?? this.hasApplied,
    );
  }
}

class SavedJob {
  final String id;
  final Job job;
  final DateTime savedAt;

  SavedJob({
    required this.id,
    required this.job,
    required this.savedAt,
  });
}

class JobAlert {
  final String id;
  final String title;
  final String category;
  final String city;
  final int minSalary;
  final String frequency; // 'Instant', 'Daily', 'Weekly'
  final bool isActive;
  final DateTime createdAt;

  JobAlert({
    required this.id,
    required this.title,
    required this.category,
    required this.city,
    required this.minSalary,
    this.frequency = 'Daily',
    this.isActive = true,
    required this.createdAt,
  });
}
