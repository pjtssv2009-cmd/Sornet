enum VerificationStatus {
  verified,
  pending,
  rejected,
  suspended;

  String get label {
    switch (this) {
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.pending:
        return 'Pending Review';
      case VerificationStatus.rejected:
        return 'Rejected';
      case VerificationStatus.suspended:
        return 'Suspended';
    }
  }
}

class TechDocument {
  final String id;
  final String title;
  final String type; // 'Govt ID', 'Experience Proof', 'Certificate', 'Training Document', 'Employer Verification'
  final String documentNumber;
  final String fileUrl;
  final String fileType; // 'pdf', 'image'
  final DateTime uploadDate;
  final VerificationStatus status;
  final String? rejectionNote;

  TechDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.documentNumber,
    required this.fileUrl,
    this.fileType = 'image',
    required this.uploadDate,
    this.status = VerificationStatus.pending,
    this.rejectionNote,
  });

  TechDocument copyWith({
    String? id,
    String? title,
    String? type,
    String? documentNumber,
    String? fileUrl,
    String? fileType,
    DateTime? uploadDate,
    VerificationStatus? status,
    String? rejectionNote,
  }) {
    return TechDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      documentNumber: documentNumber ?? this.documentNumber,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      uploadDate: uploadDate ?? this.uploadDate,
      status: status ?? this.status,
      rejectionNote: rejectionNote ?? this.rejectionNote,
    );
  }
}

class TechnicianReview {
  final String id;
  final String customerName;
  final double rating;
  final String comment;
  final DateTime date;

  TechnicianReview({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class VerificationChecklist {
  final bool phoneVerified;
  final bool identityVerified;
  final bool experienceVerified;
  final bool certificateVerified;
  final bool adminVerified;

  const VerificationChecklist({
    this.phoneVerified = false,
    this.identityVerified = false,
    this.experienceVerified = false,
    this.certificateVerified = false,
    this.adminVerified = false,
  });

  VerificationChecklist copyWith({
    bool? phoneVerified,
    bool? identityVerified,
    bool? experienceVerified,
    bool? certificateVerified,
    bool? adminVerified,
  }) {
    return VerificationChecklist(
      phoneVerified: phoneVerified ?? this.phoneVerified,
      identityVerified: identityVerified ?? this.identityVerified,
      experienceVerified: experienceVerified ?? this.experienceVerified,
      certificateVerified: certificateVerified ?? this.certificateVerified,
      adminVerified: adminVerified ?? this.adminVerified,
    );
  }

  int get completedCount {
    int count = 0;
    if (phoneVerified) count++;
    if (identityVerified) count++;
    if (experienceVerified) count++;
    if (certificateVerified) count++;
    if (adminVerified) count++;
    return count;
  }
}

class Technician {
  final String id;
  final String name;
  final String profilePhoto;
  final String phone;
  final String email;
  final String location;
  final String city;
  final DateTime dateJoined;
  final int yearsExperience;
  final String primarySkill;
  final String currentOccupation;
  final String employmentType; // 'Full-time', 'Freelance', 'Contract'
  
  // AC Expertise
  final List<String> acExpertise; // 'Split AC', 'Window AC', 'Cassette AC', 'Duct AC', 'Central AC', 'Portable AC', 'VRF / VRV'
  final String inverterExperience; // 'Inverter', 'Non-Inverter', 'Both'
  final List<String> brands; // 'Daikin', 'LG', 'Samsung', 'Voltas', 'Blue Star', 'Panasonic', 'Hitachi', 'Carrier'
  final List<String> services; // 'Installation', 'Uninstallation', 'Gas Charging', 'Leakage Repair', 'PCB Repair', 'Compressor Replacement', 'General Servicing', 'Troubleshooting', 'AMC Maintenance'

  // Documents & Trust
  final List<TechDocument> documents;
  final VerificationChecklist verificationChecklist;
  final VerificationStatus verificationStatus;
  final int trustScore; // 0 - 100
  final double rating; // e.g. 4.8
  final int reviewCount;
  final int completedJobs;
  final List<TechnicianReview> reviews;
  final String? rejectionReason;
  final String? suspensionReason;

  Technician({
    required this.id,
    required this.name,
    required this.profilePhoto,
    required this.phone,
    required this.email,
    required this.location,
    required this.city,
    required this.dateJoined,
    required this.yearsExperience,
    required this.primarySkill,
    required this.currentOccupation,
    required this.employmentType,
    required this.acExpertise,
    required this.inverterExperience,
    required this.brands,
    required this.services,
    required this.documents,
    required this.verificationChecklist,
    required this.verificationStatus,
    required this.trustScore,
    required this.rating,
    required this.reviewCount,
    required this.completedJobs,
    this.reviews = const [],
    this.rejectionReason,
    this.suspensionReason,
  });

  Technician copyWith({
    String? id,
    String? name,
    String? profilePhoto,
    String? phone,
    String? email,
    String? location,
    String? city,
    DateTime? dateJoined,
    int? yearsExperience,
    String? primarySkill,
    String? currentOccupation,
    String? employmentType,
    List<String>? acExpertise,
    String? inverterExperience,
    List<String>? brands,
    List<String>? services,
    List<TechDocument>? documents,
    VerificationChecklist? verificationChecklist,
    VerificationStatus? verificationStatus,
    int? trustScore,
    double? rating,
    int? reviewCount,
    int? completedJobs,
    List<TechnicianReview>? reviews,
    String? rejectionReason,
    String? suspensionReason,
  }) {
    return Technician(
      id: id ?? this.id,
      name: name ?? this.name,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      city: city ?? this.city,
      dateJoined: dateJoined ?? this.dateJoined,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      primarySkill: primarySkill ?? this.primarySkill,
      currentOccupation: currentOccupation ?? this.currentOccupation,
      employmentType: employmentType ?? this.employmentType,
      acExpertise: acExpertise ?? this.acExpertise,
      inverterExperience: inverterExperience ?? this.inverterExperience,
      brands: brands ?? this.brands,
      services: services ?? this.services,
      documents: documents ?? this.documents,
      verificationChecklist: verificationChecklist ?? this.verificationChecklist,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      trustScore: trustScore ?? this.trustScore,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      completedJobs: completedJobs ?? this.completedJobs,
      reviews: reviews ?? this.reviews,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      suspensionReason: suspensionReason ?? this.suspensionReason,
    );
  }
}
