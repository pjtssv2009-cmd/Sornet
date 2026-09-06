import 'package:flutter/foundation.dart';
import '../data/repositories/sornet_business_repository.dart';
import '../data/models/job.dart';
import '../data/models/application.dart';
import '../data/models/interview.dart';
import '../data/models/offer.dart';

class DashboardProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  int _activeJobsCount = 12;
  int _totalApplicationsCount = 48;
  int _shortlistedCount = 15;
  int _interviewsCount = 6;
  int _offersSentCount = 3;
  int _techniciansHiredCount = 8;

  List<Interview> _upcomingInterviews = [];
  List<Application> _recentApplications = [];

  DashboardProvider(this._repository) {
    loadDashboardData();
  }

  bool get isLoading => _isLoading;
  int get activeJobsCount => _activeJobsCount;
  int get totalApplicationsCount => _totalApplicationsCount;
  int get shortlistedCount => _shortlistedCount;
  int get interviewsCount => _interviewsCount;
  int get offersSentCount => _offersSentCount;
  int get techniciansHiredCount => _techniciansHiredCount;
  List<Interview> get upcomingInterviews => _upcomingInterviews;
  List<Application> get recentApplications => _recentApplications;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final jobs = await _repository.getJobs();
      final activeJobs = jobs.where((j) => j.status == JobStatus.active).toList();
      _activeJobsCount = activeJobs.isNotEmpty ? activeJobs.length : 12;

      final apps = await _repository.getApplications();
      _totalApplicationsCount = apps.length;
      _shortlistedCount = apps.where((a) => a.status == ApplicationStatus.shortlisted).length;
      _recentApplications = apps.take(5).toList();

      final interviews = await _repository.getInterviews();
      _interviewsCount = interviews.where((i) => i.status == InterviewStatus.scheduled).length;
      _upcomingInterviews = interviews.where((i) => i.status == InterviewStatus.scheduled || i.status == InterviewStatus.rescheduled).take(4).toList();

      final offers = await _repository.getOffers();
      _offersSentCount = offers.where((o) => o.status == OfferStatus.sent).length;

      final hired = await _repository.getHiredTechnicians();
      _techniciansHiredCount = hired.length;
    } catch (e) {
      debugPrint('Dashboard error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
