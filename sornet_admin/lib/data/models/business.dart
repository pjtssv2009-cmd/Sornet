import 'technician.dart';

class BusinessDocument {
  final String id;
  final String title;
  final String type; // 'GST Certificate', 'Company Incorporation', 'PAN Card', 'Trade License'
  final String documentNumber;
  final String fileUrl;
  final DateTime uploadDate;
  final VerificationStatus status;

  BusinessDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.documentNumber,
    required this.fileUrl,
    required this.uploadDate,
    this.status = VerificationStatus.pending,
  });
}

class Business {
  final String id;
  final String businessName;
  final String logo;
  final String businessType; // 'HVAC Contractor', 'Appliance Service Chain', 'Facility Management', 'Authorized Service Center'
  final String registrationNumber; // GSTIN / CIN
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final List<String> operatingLocations;
  final int numberOfEmployees;
  final String technicianRequirements;
  final List<String> services;
  final VerificationStatus verificationStatus;
  final List<BusinessDocument> documents;
  final int totalJobs;
  final int activeJobs;
  final int hiredTechnicians;
  final int applicationsReceived;
  final DateTime dateJoined;
  final String? rejectionReason;
  final String? suspensionReason;

  Business({
    required this.id,
    required this.businessName,
    required this.logo,
    required this.businessType,
    required this.registrationNumber,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.operatingLocations,
    required this.numberOfEmployees,
    required this.technicianRequirements,
    required this.services,
    required this.verificationStatus,
    required this.documents,
    required this.totalJobs,
    required this.activeJobs,
    required this.hiredTechnicians,
    required this.applicationsReceived,
    required this.dateJoined,
    this.rejectionReason,
    this.suspensionReason,
  });

  Business copyWith({
    String? id,
    String? businessName,
    String? logo,
    String? businessType,
    String? registrationNumber,
    String? contactPerson,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    List<String>? operatingLocations,
    int? numberOfEmployees,
    String? technicianRequirements,
    List<String>? services,
    VerificationStatus? verificationStatus,
    List<BusinessDocument>? documents,
    int? totalJobs,
    int? activeJobs,
    int? hiredTechnicians,
    int? applicationsReceived,
    DateTime? dateJoined,
    String? rejectionReason,
    String? suspensionReason,
  }) {
    return Business(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      logo: logo ?? this.logo,
      businessType: businessType ?? this.businessType,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      operatingLocations: operatingLocations ?? this.operatingLocations,
      numberOfEmployees: numberOfEmployees ?? this.numberOfEmployees,
      technicianRequirements: technicianRequirements ?? this.technicianRequirements,
      services: services ?? this.services,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      documents: documents ?? this.documents,
      totalJobs: totalJobs ?? this.totalJobs,
      activeJobs: activeJobs ?? this.activeJobs,
      hiredTechnicians: hiredTechnicians ?? this.hiredTechnicians,
      applicationsReceived: applicationsReceived ?? this.applicationsReceived,
      dateJoined: dateJoined ?? this.dateJoined,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      suspensionReason: suspensionReason ?? this.suspensionReason,
    );
  }
}
