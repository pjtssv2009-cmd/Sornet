import 'package:flutter/material.dart';
import '../data/models/work.dart';
import '../data/models/review.dart';
import '../data/repositories/sornet_technician_repository.dart';

class WorkProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<WorkRecord> _workRecords = [];
  List<EmployerRating> _reviewsReceived = [];
  bool _isLoading = false;

  WorkProvider(this._repository) {
    loadWorkRecords();
  }

  List<WorkRecord> get workRecords => _workRecords;
  List<EmployerRating> get reviewsReceived => _reviewsReceived;
  bool get isLoading => _isLoading;

  List<WorkRecord> get upcomingWork =>
      _workRecords.where((w) => w.status == WorkStatus.upcoming).toList();
  List<WorkRecord> get activeWork =>
      _workRecords.where((w) => w.status == WorkStatus.active).toList();
  List<WorkRecord> get completedWork =>
      _workRecords.where((w) => w.status == WorkStatus.completed).toList();
  int get totalHiredCount => _workRecords.length;

  WorkRecord? getWorkRecordById(String id) {
    try {
      return _workRecords.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadWorkRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workRecords = await _repository.getWorkRecords();
      // Generate sample employer reviews
      _reviewsReceived = [
        EmployerRating(
          id: 'er_1',
          workId: 'work_3',
          businessId: 'biz_1',
          businessName: 'Voltas Authorised Commercial Services',
          jobTitle: 'Senior HVAC Plant Technician',
          overallRating: 5.0,
          technicalSkillRating: 5.0,
          qualityOfWorkRating: 5.0,
          punctualityRating: 5.0,
          safetyAdherenceRating: 5.0,
          communicationRating: 4.8,
          reviewText:
              'Arun handled our 40TR VRV plant overhauling with exceptional diligence. Excellent chiller diagnosis and prompt daily logging.',
          wouldHireAgain: true,
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
        ),
        EmployerRating(
          id: 'er_2',
          workId: 'work_4',
          businessId: 'biz_2',
          businessName: 'Carrier Comfort Solutions Pvt Ltd',
          jobTitle: 'Ductable AC Commissioning Specialist',
          overallRating: 4.8,
          technicalSkillRating: 4.9,
          qualityOfWorkRating: 4.8,
          punctualityRating: 4.7,
          safetyAdherenceRating: 5.0,
          communicationRating: 4.8,
          reviewText:
              'Very knowledgeable technician. Worked flawlessly during nighttime mall shutdown operations.',
          wouldHireAgain: true,
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
        ),
      ];
    } catch (e) {
      debugPrint('Error loading work records: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeWork(String recordId) async {
    final index = _workRecords.indexWhere((w) => w.id == recordId);
    if (index != -1) {
      _workRecords[index] = _workRecords[index].copyWith(
        status: WorkStatus.completed,
        completionDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> rateBusiness(String recordId, BusinessReview review) async {
    final index = _workRecords.indexWhere((w) => w.id == recordId);
    if (index != -1) {
      _workRecords[index] = _workRecords[index].copyWith(
        isRatedByTechnician: true,
      );
      notifyListeners();
    }
  }

  Future<EmployerRating> submitEmployerRating({
    required String workId,
    required String businessId,
    required String businessName,
    required String technicianId,
    required double professionalismRating,
    required double communicationRating,
    required double paymentRating,
    required double workEnvironmentRating,
    required String reviewText,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final overall = EmployerRating.calculateOverall(
        professionalismRating,
        communicationRating,
        paymentRating,
        workEnvironmentRating,
      );

      final rating = EmployerRating(
        id: 'rate-${DateTime.now().millisecondsSinceEpoch}',
        workId: workId,
        businessId: businessId,
        businessName: businessName,
        technicianId: technicianId,
        professionalismRating: professionalismRating,
        communicationRating: communicationRating,
        paymentRating: paymentRating,
        workEnvironmentRating: workEnvironmentRating,
        overallRating: overall,
        reviewText: reviewText,
        createdAt: DateTime.now(),
      );

      final saved = await _repository.submitEmployerRating(rating);
      await loadWorkRecords();
      return saved;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
