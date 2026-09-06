enum VerificationStatus {
  notSubmitted,
  underReview,
  verified,
  rejected,
  moreInfoRequired;

  String get label {
    switch (this) {
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.underReview:
        return 'Under Review';
      case VerificationStatus.moreInfoRequired:
        return 'Action Required';
      case VerificationStatus.rejected:
        return 'Rejected';
      case VerificationStatus.notSubmitted:
        return 'Not Submitted';
    }
  }

  int get badgeColorValue {
    switch (this) {
      case VerificationStatus.verified:
        return 0xFF12B76A;
      case VerificationStatus.underReview:
      case VerificationStatus.moreInfoRequired:
        return 0xFFF79009;
      case VerificationStatus.rejected:
        return 0xFFF04438;
      case VerificationStatus.notSubmitted:
        return 0xFF64748B;
    }
  }
}

class TechnicianExperience {
  final String id;
  final String company;
  final String role;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentRole;
  final String? description;
  final bool isVerified;

  TechnicianExperience({
    required this.id,
    String? company,
    String? companyName,
    String? role,
    String? jobTitle,
    required this.location,
    required dynamic startDate,
    dynamic endDate,
    bool? isCurrentRole,
    bool? isCurrent,
    this.description,
    this.isVerified = false,
  })  : company = company ?? companyName ?? '',
        role = role ?? jobTitle ?? '',
        startDate = startDate is DateTime
            ? startDate
            : (DateTime.tryParse(startDate.toString()) ?? DateTime.now()),
        endDate = endDate is DateTime
            ? endDate
            : (endDate != null ? DateTime.tryParse(endDate.toString()) : null),
        isCurrentRole = isCurrentRole ?? isCurrent ?? false;

  String get companyName => company;
  String get jobTitle => role;
  bool get isCurrent => isCurrentRole;

  Map<String, dynamic> toJson() => {
        'id': id,
        'company': company,
        'role': role,
        'location': location,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'isCurrentRole': isCurrentRole,
        'description': description,
        'isVerified': isVerified,
      };

  factory TechnicianExperience.fromJson(Map<String, dynamic> json) =>
      TechnicianExperience(
        id: json['id'] as String,
        company: json['company'] as String? ?? json['companyName'] as String? ?? '',
        role: json['role'] as String? ?? json['jobTitle'] as String? ?? '',
        location: json['location'] as String? ?? '',
        startDate: json['startDate'] != null
            ? DateTime.tryParse(json['startDate'].toString()) ?? DateTime.now()
            : DateTime.now(),
        endDate: json['endDate'] != null
            ? DateTime.tryParse(json['endDate'].toString())
            : null,
        isCurrentRole: json['isCurrentRole'] as bool? ?? json['isCurrent'] as bool? ?? false,
        description: json['description'] as String?,
        isVerified: json['isVerified'] as bool? ?? false,
      );
}

class TechnicianCertificate {
  final String id;
  final String title;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? certificateNumber;
  final String? fileUrl;
  final VerificationStatus status;

  TechnicianCertificate({
    required this.id,
    required this.title,
    String? issuer,
    String? issuingAuthority,
    required dynamic issueDate,
    dynamic expiryDate,
    this.certificateNumber,
    this.fileUrl,
    this.status = VerificationStatus.verified,
    bool? isVerified,
  })  : issuer = issuer ?? issuingAuthority ?? '',
        issueDate = issueDate is DateTime
            ? issueDate
            : (DateTime.tryParse(issueDate.toString()) ?? DateTime.now()),
        expiryDate = expiryDate is DateTime
            ? expiryDate
            : (expiryDate != null
                ? DateTime.tryParse(expiryDate.toString())
                : null);

  String get issuingAuthority => issuer;
  bool get isVerified => status == VerificationStatus.verified;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'issuer': issuer,
        'issueDate': issueDate.toIso8601String(),
        'expiryDate': expiryDate?.toIso8601String(),
        'certificateNumber': certificateNumber,
        'fileUrl': fileUrl,
        'status': status.name,
      };

  factory TechnicianCertificate.fromJson(Map<String, dynamic> json) =>
      TechnicianCertificate(
        id: json['id'] as String,
        title: json['title'] as String,
        issuer: json['issuer'] as String? ?? json['issuingAuthority'] as String? ?? '',
        issueDate: json['issueDate'] != null
            ? DateTime.tryParse(json['issueDate'].toString()) ?? DateTime.now()
            : DateTime.now(),
        expiryDate: json['expiryDate'] != null
            ? DateTime.tryParse(json['expiryDate'].toString())
            : null,
        certificateNumber: json['certificateNumber'] as String?,
        fileUrl: json['fileUrl'] as String?,
        status: VerificationStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => VerificationStatus.verified,
        ),
      );
}

class TechnicianDocument {
  final String id;
  final String title;
  final String documentType;
  final String? documentNumber;
  final String fileUrl;
  final DateTime uploadDate;
  final VerificationStatus status;
  final String? remarks;

  TechnicianDocument({
    required this.id,
    String? title,
    String? name,
    required this.documentType,
    this.documentNumber,
    required this.fileUrl,
    dynamic uploadDate,
    dynamic uploadedAt,
    this.status = VerificationStatus.verified,
    this.remarks,
    bool? isVerified,
  })  : title = title ?? name ?? documentType,
        uploadDate = uploadDate is DateTime
            ? uploadDate
            : (uploadedAt is DateTime
                ? uploadedAt
                : (DateTime.tryParse(uploadDate?.toString() ?? uploadedAt?.toString() ?? '') ??
                    DateTime.now()));

  String get name => title;
  DateTime get uploadedAt => uploadDate;
  bool get isVerified => status == VerificationStatus.verified;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'documentType': documentType,
        'documentNumber': documentNumber,
        'fileUrl': fileUrl,
        'uploadDate': uploadDate.toIso8601String(),
        'status': status.name,
        'remarks': remarks,
      };

  factory TechnicianDocument.fromJson(Map<String, dynamic> json) =>
      TechnicianDocument(
        id: json['id'] as String,
        title: json['title'] as String? ?? json['name'] as String? ?? '',
        documentType: json['documentType'] as String,
        documentNumber: json['documentNumber'] as String?,
        fileUrl: json['fileUrl'] as String,
        uploadDate: DateTime.tryParse(json['uploadDate']?.toString() ?? '') ?? DateTime.now(),
        status: VerificationStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => VerificationStatus.verified,
        ),
        remarks: json['remarks'] as String?,
      );
}

class TechnicianVerification {
  final bool phoneVerified;
  final bool emailVerified;
  final bool identityVerified;
  final bool experienceVerified;
  final bool certificateVerified;
  final bool platformVerified;
  final VerificationStatus overallStatus;
  final String? remarks;
  final DateTime? verifiedAt;

  TechnicianVerification({
    bool? phoneVerified,
    bool? isPhoneVerified,
    bool? emailVerified,
    bool? isEmailVerified,
    bool? identityVerified,
    bool? isIdentityVerified,
    bool? experienceVerified,
    bool? isExperienceVerified,
    bool? certificateVerified,
    bool? isSkillCertified,
    this.platformVerified = true,
    VerificationStatus? overallStatus,
    VerificationStatus? status,
    this.remarks,
    this.verifiedAt,
  })  : phoneVerified = phoneVerified ?? isPhoneVerified ?? true,
        emailVerified = emailVerified ?? isEmailVerified ?? true,
        identityVerified = identityVerified ?? isIdentityVerified ?? true,
        experienceVerified = experienceVerified ?? isExperienceVerified ?? true,
        certificateVerified = certificateVerified ?? isSkillCertified ?? true,
        overallStatus = overallStatus ?? status ?? VerificationStatus.verified;

  bool get isPhoneVerified => phoneVerified;
  bool get isEmailVerified => emailVerified;
  bool get isIdentityVerified => identityVerified;
  bool get isExperienceVerified => experienceVerified;
  bool get isSkillCertified => certificateVerified;
  VerificationStatus get status => overallStatus;

  bool get isFullyVerified =>
      phoneVerified &&
      emailVerified &&
      identityVerified &&
      experienceVerified &&
      certificateVerified;

  Map<String, dynamic> toJson() => {
        'phoneVerified': phoneVerified,
        'emailVerified': emailVerified,
        'identityVerified': identityVerified,
        'experienceVerified': experienceVerified,
        'certificateVerified': certificateVerified,
        'platformVerified': platformVerified,
        'overallStatus': overallStatus.name,
        'remarks': remarks,
        'verifiedAt': verifiedAt?.toIso8601String(),
      };

  factory TechnicianVerification.fromJson(Map<String, dynamic> json) =>
      TechnicianVerification(
        phoneVerified: json['phoneVerified'] as bool? ?? true,
        emailVerified: json['emailVerified'] as bool? ?? true,
        identityVerified: json['identityVerified'] as bool? ?? true,
        experienceVerified: json['experienceVerified'] as bool? ?? true,
        certificateVerified: json['certificateVerified'] as bool? ?? true,
        platformVerified: json['platformVerified'] as bool? ?? true,
        overallStatus: VerificationStatus.values.firstWhere(
          (e) => e.name == json['overallStatus'],
          orElse: () => VerificationStatus.verified,
        ),
        remarks: json['remarks'] as String?,
        verifiedAt: json['verifiedAt'] != null
            ? DateTime.tryParse(json['verifiedAt'] as String)
            : null,
      );
}

class TechnicianAvailability {
  final String statusLabel;
  final DateTime? availableFrom;
  final List<String> preferredLocations;
  final int maxTravelDistanceKm;
  final String preferredEmploymentType;
  final int expectedSalaryMonthly;
  final int expectedDailyRate;
  final bool willingToRelocate;
  final bool immediateJoining;

  TechnicianAvailability({
    String? status,
    AvailabilityStatus? statusEnum,
    this.availableFrom,
    required this.preferredLocations,
    this.maxTravelDistanceKm = 25,
    this.preferredEmploymentType = 'Full Time',
    int? expectedSalaryMonthly,
    double? minSalary,
    double? maxSalary,
    String? salaryPeriod,
    int? expectedDailyRate,
    this.willingToRelocate = false,
    this.immediateJoining = true,
  })  : statusLabel = statusEnum?.label ?? status ?? 'Actively Looking',
        expectedSalaryMonthly = expectedSalaryMonthly ?? minSalary?.toInt() ?? 28000,
        expectedDailyRate = expectedDailyRate ?? 1400;

  AvailabilityStatus get status {
    if (statusLabel.toLowerCase().contains('contract')) {
      return AvailabilityStatus.availableForContracts;
    } else if (statusLabel.toLowerCase().contains('not') ||
        statusLabel.toLowerCase().contains('working')) {
      return AvailabilityStatus.employedNotLooking;
    }
    return AvailabilityStatus.activelyLooking;
  }

  double get minSalary => expectedSalaryMonthly.toDouble();
  double get maxSalary => (expectedSalaryMonthly * 1.3).toDouble();
  String get salaryPeriod => 'monthly';

  Map<String, dynamic> toJson() => {
        'status': statusLabel,
        'availableFrom': availableFrom?.toIso8601String(),
        'preferredLocations': preferredLocations,
        'maxTravelDistanceKm': maxTravelDistanceKm,
        'preferredEmploymentType': preferredEmploymentType,
        'expectedSalaryMonthly': expectedSalaryMonthly,
        'expectedDailyRate': expectedDailyRate,
        'willingToRelocate': willingToRelocate,
        'immediateJoining': immediateJoining,
      };

  factory TechnicianAvailability.fromJson(Map<String, dynamic> json) =>
      TechnicianAvailability(
        status: json['status'] as String? ?? 'Actively Looking',
        availableFrom: json['availableFrom'] != null
            ? DateTime.tryParse(json['availableFrom'] as String)
            : null,
        preferredLocations: (json['preferredLocations'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            ['Chennai'],
        maxTravelDistanceKm: json['maxTravelDistanceKm'] as int? ?? 25,
        preferredEmploymentType:
            json['preferredEmploymentType'] as String? ?? 'Full Time',
        expectedSalaryMonthly: json['expectedSalaryMonthly'] as int? ?? 28000,
        expectedDailyRate: json['expectedDailyRate'] as int? ?? 1400,
        willingToRelocate: json['willingToRelocate'] as bool? ?? false,
        immediateJoining: json['immediateJoining'] as bool? ?? true,
      );
}

enum AvailabilityStatus {
  activelyLooking,
  availableForContracts,
  employedNotLooking;

  String get label {
    switch (this) {
      case AvailabilityStatus.activelyLooking:
        return 'Actively Looking for Jobs';
      case AvailabilityStatus.availableForContracts:
        return 'Available for Contract / Projects';
      case AvailabilityStatus.employedNotLooking:
        return 'Employed / Not Looking';
    }
  }
}

class TechnicianPrivacySettings {
  final bool showPhonePublicly;
  final bool showEmailPublicly;
  final bool showExactLocation;
  final bool isProfileSearchable;
  final bool allowDirectMessages;

  TechnicianPrivacySettings({
    bool? showPhonePublicly,
    bool? showPhoneNumber,
    bool? showEmailPublicly,
    bool? showEmailAddress,
    this.showExactLocation = false,
    bool? isProfileSearchable,
    bool? isProfileVisible,
    this.allowDirectMessages = true,
  })  : showPhonePublicly = showPhonePublicly ?? showPhoneNumber ?? false,
        showEmailPublicly = showEmailPublicly ?? showEmailAddress ?? false,
        isProfileSearchable = isProfileSearchable ?? isProfileVisible ?? true;

  bool get isProfileVisible => isProfileSearchable;
  bool get showPhoneNumber => showPhonePublicly;
  bool get showEmailAddress => showEmailPublicly;

  Map<String, dynamic> toJson() => {
        'showPhonePublicly': showPhonePublicly,
        'showEmailPublicly': showEmailPublicly,
        'showExactLocation': showExactLocation,
        'isProfileSearchable': isProfileSearchable,
        'allowDirectMessages': allowDirectMessages,
      };

  factory TechnicianPrivacySettings.fromJson(Map<String, dynamic> json) =>
      TechnicianPrivacySettings(
        showPhonePublicly: json['showPhonePublicly'] as bool? ?? false,
        showEmailPublicly: json['showEmailPublicly'] as bool? ?? false,
        showExactLocation: json['showExactLocation'] as bool? ?? false,
        isProfileSearchable: json['isProfileSearchable'] as bool? ?? true,
        allowDirectMessages: json['allowDirectMessages'] as bool? ?? true,
      );
}

class Technician {
  final String id;
  final String fullName;
  final String photoUrl;
  final String mobileNumber;
  final String email;
  final String gender;
  final String dateOfBirth;
  final String currentCity;
  final String state;
  final String pincode;
  final String primaryTrade;
  final double experienceYears;
  final String educationQualification;
  final String aboutMe;
  final String professionalSummary;
  final List<String> acTypes;
  final List<String> acTechnologies;
  final List<String> brands;
  final List<String> services;
  final List<String> languages;
  final List<TechnicianExperience> experiences;
  final List<TechnicianCertificate> certificates;
  final List<TechnicianDocument> documents;
  final TechnicianVerification verification;
  final TechnicianAvailability availability;
  final TechnicianPrivacySettings privacy;
  final int trustScore; // e.g. 92/100
  final double rating;
  final int reviewCount;
  final int profileStrengthPercentage; // e.g. 85%
  final DateTime joinedDate;

  Technician({
    required this.id,
    required this.fullName,
    required this.photoUrl,
    required this.mobileNumber,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.currentCity,
    required this.state,
    required this.pincode,
    this.primaryTrade = 'AC Technician',
    required this.experienceYears,
    required this.educationQualification,
    required this.aboutMe,
    required this.professionalSummary,
    required this.acTypes,
    required this.acTechnologies,
    required this.brands,
    required this.services,
    required this.languages,
    required this.experiences,
    required this.certificates,
    required this.documents,
    required this.verification,
    required this.availability,
    required this.privacy,
    this.trustScore = 92,
    this.rating = 4.9,
    this.reviewCount = 28,
    this.profileStrengthPercentage = 85,
    required this.joinedDate,
  });

  String get phone => mobileNumber;
  String get city => currentCity;
  String? get bio => aboutMe;
  List<String> get skills => [...services, ...acTechnologies];
  List<String> get brandExperience => brands;
  double get totalExperienceYears => experienceYears;
  int get completedJobsCount => 42;
  int get totalReviews => reviewCount;
  bool get isVerified => verification.isFullyVerified;
  TechnicianPrivacySettings get privacySettings => privacy;

  Technician copyWith({
    String? id,
    String? fullName,
    String? photoUrl,
    String? mobileNumber,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? currentCity,
    String? state,
    String? pincode,
    String? primaryTrade,
    double? experienceYears,
    String? educationQualification,
    String? aboutMe,
    String? professionalSummary,
    List<String>? acTypes,
    List<String>? acTechnologies,
    List<String>? brands,
    List<String>? services,
    List<String>? languages,
    List<TechnicianExperience>? experiences,
    List<TechnicianCertificate>? certificates,
    List<TechnicianDocument>? documents,
    TechnicianVerification? verification,
    TechnicianAvailability? availability,
    TechnicianPrivacySettings? privacy,
    int? trustScore,
    double? rating,
    int? reviewCount,
    int? profileStrengthPercentage,
    DateTime? joinedDate,
  }) {
    return Technician(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      currentCity: currentCity ?? this.currentCity,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      primaryTrade: primaryTrade ?? this.primaryTrade,
      experienceYears: experienceYears ?? this.experienceYears,
      educationQualification:
          educationQualification ?? this.educationQualification,
      aboutMe: aboutMe ?? this.aboutMe,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      acTypes: acTypes ?? this.acTypes,
      acTechnologies: acTechnologies ?? this.acTechnologies,
      brands: brands ?? this.brands,
      services: services ?? this.services,
      languages: languages ?? this.languages,
      experiences: experiences ?? this.experiences,
      certificates: certificates ?? this.certificates,
      documents: documents ?? this.documents,
      verification: verification ?? this.verification,
      availability: availability ?? this.availability,
      privacy: privacy ?? this.privacy,
      trustScore: trustScore ?? this.trustScore,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      profileStrengthPercentage:
          profileStrengthPercentage ?? this.profileStrengthPercentage,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
