import 'package:flutter_test/flutter_test.dart';
import 'package:sornet_admin/data/repositories/sornet_repository.dart';
import 'package:sornet_admin/data/models/technician.dart';
import 'package:sornet_admin/data/models/job.dart';

void main() {
  group('SornetRepository Tests', () {
    late SornetRepository repository;

    setUp(() {
      repository = SornetRepository();
    });

    test('Loads initial technicians and filters by search query', () async {
      final techs = await repository.getTechnicians();
      expect(techs.isNotEmpty, isTrue);

      final searched = await repository.getTechnicians(query: 'Arun');
      expect(searched.any((t) => t.name.contains('Arun')), isTrue);
    });

    test('Technician verification workflow', () async {
      final pendingTechs = await repository.getTechnicians(statusFilter: VerificationStatus.pending);
      if (pendingTechs.isNotEmpty) {
        final targetId = pendingTechs.first.id;
        await repository.updateTechnicianStatus(
          targetId,
          VerificationStatus.verified,
        );

        final updated = await repository.getTechnicianById(targetId);
        expect(updated?.verificationStatus, VerificationStatus.verified);
      }
    });

    test('Job status update workflow', () async {
      final jobs = await repository.getJobs();
      expect(jobs.isNotEmpty, isTrue);

      final targetJob = jobs.first;
      await repository.updateJobStatus(targetJob.id, JobStatus.filled);

      final updatedJob = await repository.getJobById(targetJob.id);
      expect(updatedJob?.status, JobStatus.filled);
    });

    test('Module toggle updates state correctly', () async {
      final modules = await repository.getModules();
      expect(modules.isNotEmpty, isTrue);

      final initialStatus = modules.first.isEnabled;
      await repository.toggleModule(modules.first.id, !initialStatus);

      final updatedModules = await repository.getModules();
      expect(updatedModules.first.isEnabled, !initialStatus);
    });
  });
}
