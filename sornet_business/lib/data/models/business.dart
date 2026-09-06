enum VerificationStatus {
  notSubmitted,
  underReview,
  verified,
  rejected,
  moreInfoRequired,
}

class BusinessDocument {
  final String id;
  final String title;
  final String documentType;
  final String fileUrl;
  final DateTime uploadDate;
  final bool isVerified;

  BusinessDocument({
    required this.id,
    required this.title,
    required this.documentType,
    required this.fileUrl,
    required this.uploadDate,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'documentType': documentType,
        'fileUrl': fileUrl,
        'uploadDate': uploadDate.toIso8601String(),
        'isVerified': isVerified,
      };

  factory BusinessDocument.fromJson(Map<String, dynamic> json) => BusinessDocument(
        id: json['id'] as String,
        title: json['title'] as String,
        documentType: json['documentType'] as String,
        fileUrl: json['fileUrl'] as String,
        uploadDate: DateTime.parse(json['uploadDate'] as String),
        isVerified: json['isVerified'] as bool? ?? false,
      );
}

class BusinessVerification {
  final bool phoneVerified;
  final bool emailVerified;
  final bool businessIdentityVerified;
  final bool registrationVerified;
  final bool addressVerified;
  final bool adminApproved;
  final VerificationStatus status;
  final String? reviewRemarks;
  final DateTime? verifiedAt;

  BusinessVerification({
    this.phoneVerified = false,
    this.emailVerified = false,
    this.businessIdentityVerified = false,
    this.registrationVerified = false,
    this.addressVerified = false,
    this.adminApproved = false,
    this.status = VerificationStatus.underReview,
    this.reviewRemarks,
    this.verifiedAt,
  });

  int get verifiedCount {
    int count = 0;
    if (phoneVerified) count++;
    if (emailVerified) count++;
    if (businessIdentityVerified) count++;
    if (registrationVerified) count++;
    if (addressVerified) count++;
    if (adminApproved) count++;
    return count;
  }

  double get completionPercentage => (verifiedCount / 6) * 100;

  bool get isFullyVerified => status == VerificationStatus.verified && adminApproved;

  Map<String, dynamic> toJson() => {
        'phoneVerified': phoneVerified,
        'emailVerified': emailVerified,
        'businessIdentityVerified': businessIdentityVerified,
        'registrationVerified': registrationVerified,
        'addressVerified': addressVerified,
        'adminApproved': adminApproved,
        'status': status.name,
        'reviewRemarks': reviewRemarks,
        'verifiedAt': verifiedAt?.toIso8601String(),
      };

  factory BusinessVerification.fromJson(Map<String, dynamic> json) => BusinessVerification(
        phoneVerified: json['phoneVerified'] as bool? ?? false,
        emailVerified: json['emailVerified'] as bool? ?? false,
        businessIdentityVerified: json['businessIdentityVerified'] as bool? ?? false,
        registrationVerified: json['registrationVerified'] as bool? ?? false,
        addressVerified: json['addressVerified'] as bool? ?? false,
        adminApproved: json['adminApproved'] as bool? ?? false,
        status: VerificationStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => VerificationStatus.underReview,
        ),
        reviewRemarks: json['reviewRemarks'] as String?,
        verifiedAt: json['verifiedAt'] != null ? DateTime.parse(json['verifiedAt'] as String) : null,
      );
}

class Business {
  final String id;
  final String businessName;
  final String businessType;
  final String contactPerson;
  final String mobileNumber;
  final String email;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final List<String> operatingLocations;
  final int yearsInBusiness;
  final int numberOfEmployees;
  final List<String> servicesOffered;
  final String? gstNumber;
  final String? logoUrl;
  final double rating;
  final int reviewCount;
  final BusinessVerification verification;
  final List<BusinessDocument> documents;
  final String subscriptionTier; // Free, Professional, Enterprise
  final DateTime joinedAt;

  Business({
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.contactPerson,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.operatingLocations,
    required this.yearsInBusiness,
    required this.numberOfEmployees,
    required this.servicesOffered,
    this.gstNumber,
    this.logoUrl,
    this.rating = 4.8,
    this.reviewCount = 24,
    required this.verification,
    required this.documents,
    this.subscriptionTier = 'Professional',
    required this.joinedAt,
  });

  Business copyWith({
    String? id,
    String? businessName,
    String? businessType,
    String? contactPerson,
    String? mobileNumber,
    String? email,
    String? address,
    String? city,
    String? state,
    String? pincode,
    List<String>? operatingLocations,
    int? yearsInBusiness,
    int? numberOfEmployees,
    List<String>? servicesOffered,
    String? gstNumber,
    String? logoUrl,
    double? rating,
    int? reviewCount,
    BusinessVerification? verification,
    List<BusinessDocument>? documents,
    String? subscriptionTier,
    DateTime? joinedAt,
  }) {
    return Business(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      contactPerson: contactPerson ?? this.contactPerson,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      operatingLocations: operatingLocations ?? this.operatingLocations,
      yearsInBusiness: yearsInBusiness ?? this.yearsInBusiness,
      numberOfEmployees: numberOfEmployees ?? this.numberOfEmployees,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      gstNumber: gstNumber ?? this.gstNumber,
      logoUrl: logoUrl ?? this.logoUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      verification: verification ?? this.verification,
      documents: documents ?? this.documents,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessName': businessName,
        'businessType': businessType,
        'contactPerson': contactPerson,
        'mobileNumber': mobileNumber,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'operatingLocations': operatingLocations,
        'yearsInBusiness': yearsInBusiness,
        'numberOfEmployees': numberOfEmployees,
        'servicesOffered': servicesOffered,
        'gstNumber': gstNumber,
        'logoUrl': logoUrl,
        'rating': rating,
        'reviewCount': reviewCount,
        'verification': verification.toJson(),
        'documents': documents.map((d) => d.toJson()).toList(),
        'subscriptionTier': subscriptionTier,
        'joinedAt': joinedAt.toIso8601String(),
      };

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'] as String,
        businessName: json['businessName'] as String,
        businessType: json['businessType'] as String,
        contactPerson: json['contactPerson'] as String,
        mobileNumber: json['mobileNumber'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        pincode: json['pincode'] as String,
        operatingLocations: List<String>.from(json['operatingLocations'] as List),
        yearsInBusiness: json['yearsInBusiness'] as int,
        numberOfEmployees: json['numberOfEmployees'] as int,
        servicesOffered: List<String>.from(json['servicesOffered'] as List),
        gstNumber: json['gstNumber'] as String?,
        logoUrl: json['logoUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        reviewCount: json['reviewCount'] as int? ?? 24,
        verification: BusinessVerification.fromJson(json['verification'] as Map<String, dynamic>),
        documents: (json['documents'] as List)
            .map((d) => BusinessDocument.fromJson(d as Map<String, dynamic>))
            .toList(),
        subscriptionTier: json['subscriptionTier'] as String? ?? 'Professional',
        joinedAt: DateTime.parse(json['joinedAt'] as String),
      );
}
