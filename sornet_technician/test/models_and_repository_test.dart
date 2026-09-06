import 'package:flutter_test/flutter_test.dart';
import 'package:sornet_technician/data/models/application.dart';
import 'package:sornet_technician/data/models/interview.dart';
import 'package:sornet_technician/data/models/offer.dart';
import 'package:sornet_technician/data/models/review.dart';
import 'package:sornet_technician/data/repositories/sornet_technician_repository.dart';

void main() {
  group('SORNET Technician Repository & Data Tests', () {
    late SornetTechnicianRepository repository;

    setUp(() {
      repository = SornetTechnicianRepository();
    });

    test('Initializes with default technician profile', () async {
      final technician = await repository.getCurrentTechnician();
      expect(technician, isNotNull);
      expect(technician.fullName, 'R. Arun Kumar');
      expect(technician.primaryTrade, 'AC Technician');
      expect(technician.isVerified, isTrue);
      expect(technician.skills.length, greaterThan(3));
      expect(technician.brandExperience.length, greaterThan(3));
    });

    test('Job search with filter returns matching results', () async {
      final allJobs = await repository.getJobs();
      expect(allJobs.length, greaterThanOrEqualTo(5));

      final chennaiJobs = await repository.getJobs(
        city: 'Chennai',
      );
      expect(chennaiJobs, isNotEmpty);
      for (final job in chennaiJobs) {
        expect(job.city, 'Chennai');
      }
    });

    test('Submit job application creates new application', () async {
      final initialApps = await repository.getApplications();
      final count = initialApps.length;

      final application = await repository.applyForJob(
        jobId: 'job-1',
        expectedSalary: 32000,
        availability: 'Immediate',
        coverNote: 'Experienced commercial HVAC specialist.',
      );

      expect(application, isNotNull);
      expect(application.jobId, 'job-1');
      expect(application.status, ApplicationStatus.applied);

      final updatedApps = await repository.getApplications();
      expect(updatedApps.length, count + 1);
    });

    test('Accept job offer updates offer status to accepted', () async {
      final offers = await repository.getOffers();
      final pendingOffer = offers.firstWhere((o) => o.status == OfferStatus.pending);

      final accepted = await repository.acceptOffer(pendingOffer.id);
      expect(accepted.status, OfferStatus.accepted);

      final updatedOffers = await repository.getOffers();
      final updatedOffer = updatedOffers.firstWhere((o) => o.id == pendingOffer.id);
      expect(updatedOffer.status, OfferStatus.accepted);
    });

    test('Reschedule interview updates status and date', () async {
      final interviews = await repository.getInterviews();
      final scheduledInterview = interviews.firstWhere((i) => i.status == InterviewStatus.scheduled);
      final newTime = DateTime.now().add(const Duration(days: 3));

      final modified = await repository.rescheduleInterview(
        scheduledInterview.id,
        newTime,
      );
      expect(modified.status, InterviewStatus.rescheduled);
      expect(modified.scheduledAt, newTime);
    });

    test('Submit employer rating updates work record', () async {
      final workRecords = await repository.getWorkRecords();
      final record = workRecords.first;

      final rating = EmployerRating(
        id: 'rating_test_1',
        workId: record.id,
        businessId: record.businessId,
        businessName: record.businessName,
        businessLogo: record.businessLogo,
        jobTitle: record.jobTitle,
        overallRating: 5.0,
        technicalSkillRating: 5.0,
        qualityOfWorkRating: 5.0,
        punctualityRating: 5.0,
        safetyAdherenceRating: 5.0,
        communicationRating: 5.0,
        reviewText: 'Great employer with supportive site management.',
        wouldHireAgain: true,
        createdAt: DateTime.now(),
      );

      final result = await repository.submitEmployerRating(rating);
      expect(result.id, 'rating_test_1');

      final updated = await repository.getWorkRecordById(record.id);
      expect(updated?.isRatedByTechnician, isTrue);
    });

    test('Toggle save job bookmark', () async {
      final savedState = await repository.toggleSaveJob('job_2');
      final savedJobs = await repository.getSavedJobs();

      if (savedState) {
        expect(savedJobs.any((s) => s.job.id == 'job_2'), isTrue);
      } else {
        expect(savedJobs.any((s) => s.job.id == 'job_2'), isFalse);
      }
    });
  });
}
