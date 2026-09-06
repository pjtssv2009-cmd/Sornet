import 'package:flutter/foundation.dart';
import '../data/models/job.dart';
import '../data/repositories/sornet_business_repository.dart';

class JobProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<Job> _allJobs = [];
  String _searchQuery = '';
  Job? _draftJob;

  JobProvider(this._repository) {
    loadJobs();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  Job? get draftJob => _draftJob;

  List<Job> get activeJobs => _allJobs
      .where((j) => j.status == JobStatus.active && _matchesQuery(j))
      .toList();

  List<Job> get draftJobs => _allJobs
      .where((j) => j.status == JobStatus.draft && _matchesQuery(j))
      .toList();

  List<Job> get closedJobs => _allJobs
      .where((j) => j.status == JobStatus.closed && _matchesQuery(j))
      .toList();

  bool _matchesQuery(Job j) {
    if (_searchQuery.isEmpty) return true;
    final q = _searchQuery.toLowerCase();
    return j.title.toLowerCase().contains(q) ||
        j.location.toLowerCase().contains(q) ||
        j.city.toLowerCase().contains(q) ||
        j.category.toLowerCase().contains(q);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allJobs = await _repository.getJobs();
    } catch (e) {
      debugPrint('Error loading jobs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDraftJob(Job job) {
    _draftJob = job;
    notifyListeners();
  }

  void clearDraftJob() {
    _draftJob = null;
    notifyListeners();
  }

  Future<Job> publishJob(Job job) async {
    _isLoading = true;
    notifyListeners();

    try {
      final created = await _repository.createJob(job);
      _allJobs.insert(0, created);
      _draftJob = null;
      return created;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> closeJob(String jobId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _repository.closeJob(jobId);
      if (success) {
        final index = _allJobs.indexWhere((j) => j.id == jobId);
        if (index != -1) {
          _allJobs[index] = _allJobs[index].copyWith(status: JobStatus.closed);
        }
      }
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Job> updateJob(Job job) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.updateJob(job);
      final index = _allJobs.indexWhere((j) => j.id == job.id);
      if (index != -1) {
        _allJobs[index] = updated;
      }
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
