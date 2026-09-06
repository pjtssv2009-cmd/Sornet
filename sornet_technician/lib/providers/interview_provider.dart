import 'package:flutter/material.dart';
import '../data/models/interview.dart';
import '../data/repositories/sornet_technician_repository.dart';

class InterviewProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<Interview> _interviews = [];
  bool _isLoading = false;

  InterviewProvider(this._repository) {
    loadInterviews();
  }

  List<Interview> get interviews => _interviews;
  bool get isLoading => _isLoading;

  List<Interview> get upcomingInterviews => _interviews
      .where((i) =>
          i.status == InterviewStatus.scheduled ||
          i.status == InterviewStatus.rescheduled)
      .toList();

  List<Interview> get completedInterviews =>
      _interviews.where((i) => i.status == InterviewStatus.completed).toList();

  List<Interview> get cancelledInterviews =>
      _interviews.where((i) => i.status == InterviewStatus.cancelled).toList();

  Interview? getInterviewById(String id) {
    try {
      return _interviews.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadInterviews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _interviews = await _repository.getInterviews();
    } catch (e) {
      debugPrint('Error loading interviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Interview> rescheduleInterview(
      String interviewId, DateTime newDateTime, [String? reason]) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.rescheduleInterview(
          interviewId, newDateTime);
      await loadInterviews();
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Interview> cancelInterview(String interviewId, String reason) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.cancelInterview(interviewId, reason);
      await loadInterviews();
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
