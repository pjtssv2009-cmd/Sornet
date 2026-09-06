import 'package:flutter_test/flutter_test.dart';
import 'package:sornet_business/data/models/business.dart';
import 'package:sornet_business/data/models/job.dart';
import 'package:sornet_business/data/models/application.dart';
import 'package:sornet_business/data/models/interview.dart';
import 'package:sornet_business/data/models/offer.dart';
import 'package:sornet_business/data/models/review.dart';
import 'package:sornet_business/data/repositories/sornet_business_repository.dart';

void main() {
  group('SORNET Business Repository & Flow Tests', () {
    late SornetBusinessRepository repository;

    setUp(() {
      repository = SornetBusinessRepository();
    });

    test('Initial Business Profile loads correctly', () async {
      final profile = await repository.getCurrentBusiness();
      expect(profile.businessName, equals('CoolFlow Air Conditioning & Facility Services'));
      expect(profile.verification.status, equals(VerificationStatus.verified));
      expect(profile.documents.length, greaterThanOrEqualTo(1));
    });

    test('Jobs listing and creation workflow', () async {
      final initialJobs = await repository.getJobs();
      expect(initialJobs.length, equals(10));

      final newJob = Job(
        id: 'job_test_999',
        businessId: 'biz-101',
        businessName: 'CoolFlow Air Conditioning & Facility Services',
        businessLogo: 'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?w=150',
        title: 'Lead VRF / VRV Specialist',
        category: 'VRF/VRV Systems',
        experienceRequired: '4+ Years',
        technicianType: 'Full Time',
        skillsRequired: ['VRF/VRV Systems', 'Central AC'],
        technicalExpertise: ['Inverter AC', 'PCB Board Repair'],
        brands: ['Daikin', 'Mitsubishi', 'Carrier'],
        requiredServices: ['Installation', 'Gas Charging & Leakage Repair'],
        location: 'Electronic City Phase 1, Bangalore',
        city: 'Bengaluru',
        minSalary: 35000,
        maxSalary: 48000,
        salaryPeriod: 'month',
        positionsCount: 3,
        joiningDate: DateTime.now().add(const Duration(days: 7)),
        workingHours: '9:00 AM - 6:00 PM',
        description: 'Lead VRF installation and multi-split commissioning.',
        benefits: ['PF & Medical Insurance', 'Performance Incentives', 'Fuel Allowance'],
        additionalRequirements: 'Must have valid two-wheeler license and own basic tools.',
        status: JobStatus.active,
        postedDate: DateTime.now(),
        applicantsCount: 0,
        shortlistedCount: 0,
        interviewsCount: 0,
        hiredCount: 0,
      );

      final created = await repository.createJob(newJob);
      expect(created.id, equals('job_test_999'));

      final allJobsAfter = await repository.getJobs();
      expect(allJobsAfter.length, equals(11));
      expect(allJobsAfter.any((j) => j.id == 'job_test_999'), isTrue);
    });

    test('Technician search, filtering, and detail lookup', () async {
      final allTechs = await repository.getTechnicians();
      expect(allTechs.length, equals(15));

      final chennaiTechs = await repository.getTechnicians(city: 'Chennai');
      expect(chennaiTechs.length, greaterThanOrEqualTo(1));
      for (final t in chennaiTechs) {
        expect(t.city, equals('Chennai'));
      }

      final techDetail = await repository.getTechnicianById('tech-1');
      expect(techDetail, isNotNull);
      expect(techDetail!.name, equals('R. Vignesh Kumar'));
      expect(techDetail.isVerified, isTrue);
      expect(techDetail.rating, equals(4.9));
    });

    test('Application lifecycle: shortlisting, status changes', () async {
      final apps = await repository.getApplications();
      expect(apps.isNotEmpty, isTrue);

      final targetApp = apps.first;
      final updated = await repository.updateApplicationStatus(targetApp.id, ApplicationStatus.shortlisted);
      expect(updated.status, equals(ApplicationStatus.shortlisted));
    });

    test('Interview scheduling and status updates', () async {
      final initialInterviews = await repository.getInterviews();
      expect(initialInterviews.length, equals(5));

      final newInterview = Interview(
        id: 'int_test_101',
        technicianId: 'tech_001',
        technicianName: 'Vikram Sharma',
        technicianPhoto: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        technicianPhone: '+91 98765 43210',
        jobId: 'job_001',
        jobTitle: 'Senior Commercial HVAC Technician',
        scheduledAt: DateTime.now().add(const Duration(days: 2)),
        type: InterviewType.inPerson,
        locationOrLink: 'Apex Tower, 4th Floor, Whitefield, Bangalore',
        notes: 'Bring technical certificates and previous employer letters.',
        status: InterviewStatus.scheduled,
        createdAt: DateTime.now(),
      );

      final scheduled = await repository.scheduleInterview(newInterview);
      expect(scheduled.id, equals('int_test_101'));

      final allInterviewsAfter = await repository.getInterviews();
      expect(allInterviewsAfter.length, equals(6));
    });

    test('Hiring offers creation flow', () async {
      final initialOffers = await repository.getOffers();
      expect(initialOffers.length, equals(5));

      final newOffer = JobOffer(
        id: 'off_test_202',
        technicianId: 'tech_002',
        technicianName: 'Rajesh Kumar',
        technicianPhoto: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        technicianPhone: '+91 98765 43211',
        jobId: 'job_001',
        jobTitle: 'Senior Commercial HVAC Technician',
        position: 'Senior AC Technician',
        salaryAmount: 36000,
        salaryPeriod: 'month',
        employmentType: 'Full Time',
        joiningDate: DateTime.now().add(const Duration(days: 7)),
        workingHours: '9:00 AM - 6:00 PM',
        location: 'Whitefield Campus, Bangalore',
        benefits: ['Health Insurance', 'EPF', 'Overtime Bonus'],
        additionalTerms: 'Standard full-time employment with 3-month probation.',
        status: OfferStatus.sent,
        sentDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      final createdOffer = await repository.sendOffer(newOffer);
      expect(createdOffer.id, equals('off_test_202'));
      expect(createdOffer.status, equals(OfferStatus.sent));
    });

    test('Hired technician rating & review submission', () async {
      final hired = await repository.getHiredTechnicians();
      expect(hired.length, equals(5));

      final firstHired = hired.first;
      final review = await repository.submitReview(
        TechnicianReview(
          id: 'rev_test_303',
          technicianId: firstHired.technicianId,
          technicianName: firstHired.technicianName,
          businessId: 'biz_001',
          businessName: 'CoolTech Aircon Systems Pvt Ltd',
          hiringId: firstHired.id,
          jobTitle: firstHired.jobTitle,
          technicalSkillRating: 5.0,
          professionalismRating: 4.8,
          communicationRating: 4.6,
          punctualityRating: 5.0,
          qualityOfWorkRating: 4.9,
          overallRating: 4.86,
          reviewText: 'Outstanding technical competency and thorough troubleshooting.',
          createdAt: DateTime.now(),
        ),
      );

      expect(review.technicianName, equals(firstHired.technicianName));
      expect(review.overallRating, greaterThan(4.5));
    });
  });
}
