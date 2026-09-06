import 'package:flutter_test/flutter_test.dart';
import 'package:sornet_admin/data/models/technician.dart';
import 'package:sornet_admin/data/models/business.dart';
import 'package:sornet_admin/data/models/customer.dart';
import 'package:sornet_admin/data/models/job.dart';
import 'package:sornet_admin/data/models/admin_user.dart';

void main() {
  group('Domain Models Unit Tests', () {
    test('Technician model creation and copyWith', () {
      final tech = Technician(
        id: 'T-1001',
        name: 'Arun Kumar',
        profilePhoto: '',
        phone: '+91 98765 43210',
        email: 'arun.kumar@gmail.com',
        location: 'Anna Nagar',
        city: 'Chennai',
        dateJoined: DateTime(2024, 1, 15),
        yearsExperience: 7,
        primarySkill: 'AC Technician',
        currentOccupation: 'Full-time Technician',
        employmentType: 'Freelancer',
        acExpertise: ['Split AC', 'Window AC', 'Inverter AC'],
        inverterExperience: 'Expert',
        brands: ['Daikin', 'Voltas', 'LG'],
        services: ['Installation', 'Repair & Service', 'Gas Charging'],
        documents: [],
        verificationChecklist: const VerificationChecklist(
          phoneVerified: true,
          identityVerified: true,
          experienceVerified: true,
          certificateVerified: true,
          adminVerified: true,
        ),
        verificationStatus: VerificationStatus.verified,
        trustScore: 92,
        rating: 4.8,
        reviewCount: 47,
        completedJobs: 128,
      );

      expect(tech.name, 'Arun Kumar');
      expect(tech.verificationStatus, VerificationStatus.verified);
      expect(tech.brands.length, 3);
      expect(tech.trustScore, 92);

      final updated = tech.copyWith(
        verificationStatus: VerificationStatus.suspended,
        suspensionReason: 'Under review',
      );
      expect(updated.verificationStatus, VerificationStatus.suspended);
      expect(updated.suspensionReason, 'Under review');
    });

    test('Business model properties and status updates', () {
      final biz = Business(
        id: 'B-2001',
        businessName: 'Apex Facilities & HVAC Solutions',
        logo: '',
        businessType: 'HVAC Services',
        registrationNumber: 'CIN-U74999TN2018PTC123456',
        contactPerson: 'Rajesh Sharma',
        phone: '+91 99887 76655',
        email: 'rajesh@apexfacilities.com',
        address: 'No 45, Mount Road',
        city: 'Chennai',
        state: 'Tamil Nadu',
        pinCode: '600002',
        operatingLocations: ['Chennai', 'Kanchipuram'],
        numberOfEmployees: 35,
        technicianRequirements: 'AC & HVAC Technicians',
        services: ['Commercial AC Maintenance', 'Chiller Plant Overhaul'],
        verificationStatus: VerificationStatus.verified,
        documents: [],
        totalJobs: 34,
        activeJobs: 5,
        hiredTechnicians: 18,
        applicationsReceived: 72,
        dateJoined: DateTime(2024, 3, 10),
      );

      expect(biz.businessName, 'Apex Facilities & HVAC Solutions');
      expect(biz.activeJobs, 5);
      expect(biz.hiredTechnicians, 18);
    });

    test('Customer model creation', () {
      final cust = Customer(
        id: 'C-3001',
        name: 'Priya Raman',
        phone: '+91 98401 23456',
        email: 'priya.raman@gmail.com',
        address: 'Flat 4B, Sky Towers, T Nagar',
        city: 'Chennai',
        isActive: true,
        dateJoined: DateTime(2024, 1, 10),
        totalBookings: 8,
        completedBookings: 8,
        totalSpent: 14200.0,
        serviceHistory: [],
      );

      expect(cust.name, 'Priya Raman');
      expect(cust.totalBookings, 8);
      expect(cust.isActive, isTrue);
      expect(cust.totalSpent, 14200.0);
    });

    test('Job status enum check and properties', () {
      final job = Job(
        id: 'J-5001',
        title: 'Commercial Multi-Split AC Installation',
        businessId: 'B-2001',
        businessName: 'Apex Facilities & HVAC Solutions',
        category: 'HVAC & AC Service',
        location: 'Chennai - Guindy Industrial Estate',
        experienceRequired: '3+ Years',
        employmentType: 'Full-time Contract',
        salary: '₹28,000 - ₹35,000 / month',
        positionsCount: 4,
        applicantsCount: 6,
        status: JobStatus.open,
        acExpertise: ['Multi-Split AC', 'Cassette AC', 'VRV / VRF'],
        inverterType: 'Both',
        brands: ['Daikin', 'Blue Star', 'Voltas'],
        description: 'Need certified AC technicians for commercial installation.',
        createdDate: DateTime(2025, 2, 20),
        joiningDate: DateTime(2025, 3, 15),
      );

      expect(job.title, contains('Multi-Split'));
      expect(job.status, JobStatus.open);
      expect(job.positionsCount, 4);
    });

    test('Admin User RBAC role permissions', () {
      final superAdmin = AdminUser(
        id: 'ADM-01',
        name: 'Suresh Raghavan',
        email: 'admin@sornet.com',
        phone: '+91 98400 11223',
        role: AdminRole.superAdmin,
        isActive: true,
        lastActive: DateTime.now(),
        permissions: {
          'technicians': const AdminPermission(
            canView: true,
            canCreate: true,
            canEdit: true,
            canDelete: true,
            canApprove: true,
          ),
        },
      );

      expect(superAdmin.role, AdminRole.superAdmin);
      expect(superAdmin.permissions['technicians']?.canApprove, isTrue);
    });
  });
}
