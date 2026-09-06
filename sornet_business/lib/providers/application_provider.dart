import 'package:flutter/foundation.dart';
import '../data/models/application.dart';
import '../data/repositories/sornet_business_repository.dart';

class ApplicationProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<Application> _applications = [];
  String? _selectedJobFilter;
  String _searchQuery = '';

  ApplicationProvider(this._repository) {
    loadApplications();
  }

  bool get isLoading => _isLoading;
  List<Application> get applications => _applications;
  String? get selectedJobFilter => _selectedJobFilter;
  String get searchQuery => _searchQuery;

  List<Application> get allApplications => _filteredBySearchAndJob(_applications);

  List<Application> get newApplications =>
      _filteredBySearchAndJob(_applications.where((a) => a.status == ApplicationStatus.newApplication).toList());

  List<Application> get shortlistedApplications =>
      _filteredBySearchAndJob(_applications.where((a) => a.status == ApplicationStatus.shortlisted).toList());

  List<Application> get interviewApplications =>
      _filteredBySearchAndJob(_applications.where((a) => a.status == ApplicationStatus.interviewScheduled).toList());

  List<Application> get selectedApplications =>
      _filteredBySearchAndJob(_applications.where((a) => a.status == ApplicationStatus.selected).toList());

  List<Application> get rejectedApplications =>
      _filteredBySearchAndJob(_applications.where((a) => a.status == ApplicationStatus.rejected).toList());

  List<Application> _filteredBySearchAndJob(List<Application> list) {
    var result = list;
    if (_selectedJobFilter != null && _selectedJobFilter!.isNotEmpty && _selectedJobFilter != 'All Jobs') {
      result = result.where((a) => a.jobId == _selectedJobFilter || a.jobTitle == _selectedJobFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((a) {
        return a.technician.name.toLowerCase().contains(q) ||
            a.jobTitle.toLowerCase().contains(q) ||
            a.technician.city.toLowerCase().contains(q) ||
            a.technician.acExpertise.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }
    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setJobFilter(String? jobFilter) {
    _selectedJobFilter = jobFilter;
    notifyListeners();
  }

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

  Future<void> shortlistApplication(String applicationId) async {
    try {
      final updated = await _repository.updateApplicationStatus(
        applicationId,
        ApplicationStatus.shortlisted,
      );
      final index = _applications.indexWhere((a) => a.id == applicationId);
      if (index != -1) {
        _applications[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error shortlisting: $e');
    }
  }

  Future<void> rejectApplication(String applicationId, {String? reason}) async {
    try {
      final updated = await _repository.updateApplicationStatus(
        applicationId,
        ApplicationStatus.rejected,
        reason: reason ?? 'Candidate qualifications do not match current requirements.',
      );
      final index = _applications.indexWhere((a) => a.id == applicationId);
      if (index != -1) {
        _applications[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error rejecting application: $e');
    }
  }
}
