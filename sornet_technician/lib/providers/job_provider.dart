import 'package:flutter/material.dart';
import '../data/models/job.dart';
import '../data/repositories/sornet_technician_repository.dart';

class JobProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<Job> _jobs = [];
  List<SavedJob> _savedJobs = [];
  List<JobAlert> _jobAlerts = [];
  bool _isLoading = false;

  // Active Search & Filter State
  String _searchQuery = '';
  String _selectedCity = 'All Cities';
  String _selectedCategory = 'All Categories';
  String? _selectedAcType;
  String? _selectedBrand;
  String? _selectedService;
  String _selectedEmploymentType = 'All Types';
  int? _minSalary;
  int? _maxSalary;
  String _sortBy = 'recommended';

  JobProvider(this._repository) {
    loadJobs();
    loadSavedJobs();
    loadJobAlerts();
  }

  List<Job> get jobs => _jobs;
  List<SavedJob> get savedJobs => _savedJobs;
  List<JobAlert> get jobAlerts => _jobAlerts;
  bool get isLoading => _isLoading;

  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;
  String get selectedCategory => _selectedCategory;
  String? get selectedAcType => _selectedAcType;
  String? get selectedBrand => _selectedBrand;
  String? get selectedService => _selectedService;
  String get selectedEmploymentType => _selectedEmploymentType;
  int? get minSalary => _minSalary;
  int? get maxSalary => _maxSalary;
  String get sortBy => _sortBy;

  int get activeFiltersCount {
    var count = 0;
    if (_selectedCity != 'All Cities') count++;
    if (_selectedCategory != 'All Categories') count++;
    if (_selectedAcType != null && _selectedAcType!.isNotEmpty) count++;
    if (_selectedBrand != null && _selectedBrand!.isNotEmpty) count++;
    if (_selectedService != null && _selectedService!.isNotEmpty) count++;
    if (_selectedEmploymentType != 'All Types') count++;
    if (_minSalary != null || _maxSalary != null) count++;
    return count;
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _jobs = await _repository.getJobs(
        query: _searchQuery,
        city: _selectedCity == 'All Cities' ? null : _selectedCity,
        category: _selectedCategory == 'All Categories' ? null : _selectedCategory,
        acType: _selectedAcType,
        brand: _selectedBrand,
        service: _selectedService,
        employmentType: _selectedEmploymentType == 'All Types' ? null : _selectedEmploymentType,
        minSalary: _minSalary,
        maxSalary: _maxSalary,
        sortBy: _sortBy,
      );
    } catch (e) {
      debugPrint('Error loading jobs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadJobs();
  }

  void setFilters({
    String? city,
    String? category,
    String? acType,
    String? brand,
    String? service,
    String? employmentType,
    int? minSalary,
    int? maxSalary,
  }) {
    if (city != null) _selectedCity = city;
    if (category != null) _selectedCategory = category;
    _selectedAcType = acType;
    _selectedBrand = brand;
    _selectedService = service;
    if (employmentType != null) _selectedEmploymentType = employmentType;
    _minSalary = minSalary;
    _maxSalary = maxSalary;
    loadJobs();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCity = 'All Cities';
    _selectedCategory = 'All Categories';
    _selectedAcType = null;
    _selectedBrand = null;
    _selectedService = null;
    _selectedEmploymentType = 'All Types';
    _minSalary = null;
    _maxSalary = null;
    _sortBy = 'recommended';
    loadJobs();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    loadJobs();
  }

  Future<void> toggleSaveJob(String jobId) async {
    try {
      await _repository.toggleSaveJob(jobId);
      final index = _jobs.indexWhere((j) => j.id == jobId);
      if (index != -1) {
        _jobs[index] = _jobs[index].copyWith(isSaved: !_jobs[index].isSaved);
      }
      await loadSavedJobs();
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling saved job: $e');
    }
  }

  Future<void> loadSavedJobs() async {
    try {
      _savedJobs = await _repository.getSavedJobs();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved jobs: $e');
    }
  }

  Future<void> loadJobAlerts() async {
    try {
      _jobAlerts = await _repository.getJobAlerts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading job alerts: $e');
    }
  }

  Future<void> createJobAlert(JobAlert alert) async {
    try {
      await _repository.createJobAlert(alert);
      await loadJobAlerts();
    } catch (e) {
      debugPrint('Error creating job alert: $e');
    }
  }

  Future<void> deleteJobAlert(String alertId) async {
    try {
      await _repository.deleteJobAlert(alertId);
      await loadJobAlerts();
    } catch (e) {
      debugPrint('Error deleting job alert: $e');
    }
  }
}
