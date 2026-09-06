class TechnicianExperience {
  final String company;
  final String role;
  final String duration;
  final String description;

  TechnicianExperience({
    required this.company,
    required this.role,
    required this.duration,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'company': company,
        'role': role,
        'duration': duration,
        'description': description,
      };

  factory TechnicianExperience.fromJson(Map<String, dynamic> json) => TechnicianExperience(
        company: json['company'] as String,
        role: json['role'] as String,
        duration: json['duration'] as String,
        description: json['description'] as String,
      );
}

class TechnicianCertificate {
  final String title;
  final String issuer;
  final String issueYear;
  final String certificateNumber;
  final bool isVerified;

  TechnicianCertificate({
    required this.title,
    required this.issuer,
    required this.issueYear,
    required this.certificateNumber,
    this.isVerified = true,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'issuer': issuer,
        'issueYear': issueYear,
        'certificateNumber': certificateNumber,
        'isVerified': isVerified,
      };

  factory TechnicianCertificate.fromJson(Map<String, dynamic> json) => TechnicianCertificate(
        title: json['title'] as String,
        issuer: json['issuer'] as String,
        issueYear: json['issueYear'] as String,
        certificateNumber: json['certificateNumber'] as String,
        isVerified: json['isVerified'] as bool? ?? true,
      );
}

class Technician {
  final String id;
  final String name;
  final String photoUrl;
  final String phone;
  final String email;
  final String location;
  final String city;
  final double experienceYears;
  final double rating;
  final int reviewsCount;
  final int trustScore; // e.g. 96/100
  final bool isVerified;
  final bool isIdentityVerified;
  final bool isSkillVerified;
  final String availability; // 'Immediate', 'Within 7 Days', 'Within 15 Days'
  final int expectedSalaryMonthly;
  final int dailyRate;
  final String about;
  final List<String> acExpertise; // Split AC, Window AC, VRF/VRV, etc.
  final List<String> technicalExpertise; // Inverter, Non-Inverter, Dual Inverter
  final List<String> brands; // Daikin, LG, Samsung, Voltas, etc.
  final List<String> services; // Installation, PCB Repair, Gas Charging, etc.
  final List<TechnicianExperience> experienceHistory;
  final List<TechnicianCertificate> certificates;
  final int completedJobsCount;
  final bool isShortlisted;

  Technician({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.phone,
    required this.email,
    required this.location,
    required this.city,
    required this.experienceYears,
    required this.rating,
    required this.reviewsCount,
    required this.trustScore,
    this.isVerified = true,
    this.isIdentityVerified = true,
    this.isSkillVerified = true,
    required this.availability,
    required this.expectedSalaryMonthly,
    required this.dailyRate,
    required this.about,
    required this.acExpertise,
    required this.technicalExpertise,
    required this.brands,
    required this.services,
    required this.experienceHistory,
    required this.certificates,
    this.completedJobsCount = 42,
    this.isShortlisted = false,
  });

  Technician copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? phone,
    String? email,
    String? location,
    String? city,
    double? experienceYears,
    double? rating,
    int? reviewsCount,
    int? trustScore,
    bool? isVerified,
    bool? isIdentityVerified,
    bool? isSkillVerified,
    String? availability,
    int? expectedSalaryMonthly,
    int? dailyRate,
    String? about,
    List<String>? acExpertise,
    List<String>? technicalExpertise,
    List<String>? brands,
    List<String>? services,
    List<TechnicianExperience>? experienceHistory,
    List<TechnicianCertificate>? certificates,
    int? completedJobsCount,
    bool? isShortlisted,
  }) {
    return Technician(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      city: city ?? this.city,
      experienceYears: experienceYears ?? this.experienceYears,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      trustScore: trustScore ?? this.trustScore,
      isVerified: isVerified ?? this.isVerified,
      isIdentityVerified: isIdentityVerified ?? this.isIdentityVerified,
      isSkillVerified: isSkillVerified ?? this.isSkillVerified,
      availability: availability ?? this.availability,
      expectedSalaryMonthly: expectedSalaryMonthly ?? this.expectedSalaryMonthly,
      dailyRate: dailyRate ?? this.dailyRate,
      about: about ?? this.about,
      acExpertise: acExpertise ?? this.acExpertise,
      technicalExpertise: technicalExpertise ?? this.technicalExpertise,
      brands: brands ?? this.brands,
      services: services ?? this.services,
      experienceHistory: experienceHistory ?? this.experienceHistory,
      certificates: certificates ?? this.certificates,
      completedJobsCount: completedJobsCount ?? this.completedJobsCount,
      isShortlisted: isShortlisted ?? this.isShortlisted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'photoUrl': photoUrl,
        'phone': phone,
        'email': email,
        'location': location,
        'city': city,
        'experienceYears': experienceYears,
        'rating': rating,
        'reviewsCount': reviewsCount,
        'trustScore': trustScore,
        'isVerified': isVerified,
        'isIdentityVerified': isIdentityVerified,
        'isSkillVerified': isSkillVerified,
        'availability': availability,
        'expectedSalaryMonthly': expectedSalaryMonthly,
        'dailyRate': dailyRate,
        'about': about,
        'acExpertise': acExpertise,
        'technicalExpertise': technicalExpertise,
        'brands': brands,
        'services': services,
        'experienceHistory': experienceHistory.map((e) => e.toJson()).toList(),
        'certificates': certificates.map((c) => c.toJson()).toList(),
        'completedJobsCount': completedJobsCount,
        'isShortlisted': isShortlisted,
      };

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
        id: json['id'] as String,
        name: json['name'] as String,
        photoUrl: json['photoUrl'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        location: json['location'] as String,
        city: json['city'] as String,
        experienceYears: (json['experienceYears'] as num).toDouble(),
        rating: (json['rating'] as num).toDouble(),
        reviewsCount: json['reviewsCount'] as int,
        trustScore: json['trustScore'] as int,
        isVerified: json['isVerified'] as bool? ?? true,
        isIdentityVerified: json['isIdentityVerified'] as bool? ?? true,
        isSkillVerified: json['isSkillVerified'] as bool? ?? true,
        availability: json['availability'] as String,
        expectedSalaryMonthly: json['expectedSalaryMonthly'] as int,
        dailyRate: json['dailyRate'] as int,
        about: json['about'] as String,
        acExpertise: List<String>.from(json['acExpertise'] as List),
        technicalExpertise: List<String>.from(json['technicalExpertise'] as List),
        brands: List<String>.from(json['brands'] as List),
        services: List<String>.from(json['services'] as List),
        experienceHistory: (json['experienceHistory'] as List)
            .map((e) => TechnicianExperience.fromJson(e as Map<String, dynamic>))
            .toList(),
        certificates: (json['certificates'] as List)
            .map((c) => TechnicianCertificate.fromJson(c as Map<String, dynamic>))
            .toList(),
        completedJobsCount: json['completedJobsCount'] as int? ?? 42,
        isShortlisted: json['isShortlisted'] as bool? ?? false,
      );
}
