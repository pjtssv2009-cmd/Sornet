import 'package:flutter/foundation.dart';
import '../data/models/interview.dart';
import '../data/repositories/sornet_business_repository.dart';

class InterviewProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<Interview> _interviews = [];

  InterviewProvider(this._repository) {
    loadInterviews();
  }

  bool get isLoading => _isLoading;
  List<Interview> get interviews => _interviews;

  List<Interview> get scheduledInterviews =>
      _interviews.where((i) => i.status == InterviewStatus.scheduled || i.status == InterviewStatus.rescheduled).toList();

  List<Interview> get completedInterviews =>
      _interviews.where((i) => i.status == InterviewStatus.completed).toList();

  List<Interview> get cancelledInterviews =>
      _interviews.where((i) => i.status == InterviewStatus.cancelled).toList();

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

  Future<Interview> scheduleNewInterview({
    required String technicianId,
    required String technicianName,
    required String technicianPhoto,
    required String technicianPhone,
    required String jobId,
    required String jobTitle,
    required DateTime scheduledAt,
    int durationMinutes = 30,
    required InterviewType type,
    required String locationOrLink,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final interview = Interview(
        id: 'int-${DateTime.now().millisecondsSinceEpoch}',
        technicianId: technicianId,
        technicianName: technicianName,
        technicianPhoto: technicianPhoto,
        technicianPhone: technicianPhone,
        jobId: jobId,
        jobTitle: jobTitle,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        type: type,
        locationOrLink: locationOrLink,
        notes: notes,
        status: InterviewStatus.scheduled,
        createdAt: DateTime.now(),
      );

      final created = await _repository.scheduleInterview(interview);
      _interviews.insert(0, created);
      return created;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reschedule(String id, DateTime newDateTime) async {
    try {
      final updated = await _repository.rescheduleInterview(id, newDateTime);
      final index = _interviews.indexWhere((i) => i.id == id);
      if (index != -1) {
        _interviews[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error rescheduling: $e');
    }
  }

  Future<void> markCompleted(String id, {String? feedback}) async {
    try {
      final updated = await _repository.updateInterviewStatus(
        id,
        InterviewStatus.completed,
        feedback: feedback,
      );
      final index = _interviews.indexWhere((i) => i.id == id);
      if (index != -1) {
        _interviews[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error completing interview: $e');
    }
  }

  Future<void> cancel(String id) async {
    try {
      final updated = await _repository.updateInterviewStatus(
        id,
        InterviewStatus.cancelled,
      );
      final index = _interviews.indexWhere((i) => i.id == id);
      if (index != -1) {
        _interviews[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error cancelling interview: $e');
    }
  }
}
