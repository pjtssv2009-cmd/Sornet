import 'package:flutter/material.dart';
import '../data/models/application.dart';
import '../data/repositories/sornet_technician_repository.dart';

class ApplicationProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<Application> _applications = [];
  bool _isLoading = false;

  ApplicationProvider(this._repository) {
    loadApplications();
  }

  List<Application> get applications => _applications;
  bool get isLoading => _isLoading;

  int get totalApplicationsCount => _applications.length;
  int get shortlistedCount => _applications.where((a) => a.status == ApplicationStatus.shortlisted).length;
  int get interviewCount => _applications.where((a) => a.status == ApplicationStatus.interviewScheduled).length;
  int get offersCount => _applications.where((a) => a.status == ApplicationStatus.offerReceived).length;

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _applications = await _repository.getApplications();
    } catch (e) {
      debugPrint('Error loading applications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Application> applyForJob({
    required String jobId,
    required int expectedSalary,
    required String availability,
    String? coverNote,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final app = await _repository.applyForJob(
        jobId: jobId,
        expectedSalary: expectedSalary,
        availability: availability,
        coverNote: coverNote,
      );
      await loadApplications();
      return app;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> withdrawApplication(String applicationId) async {
    try {
      final success = await _repository.withdrawApplication(applicationId);
      if (success) {
        await loadApplications();
      }
      return success;
    } catch (e) {
      debugPrint('Error withdrawing application: $e');
      return false;
    }
  }
}
