import 'package:flutter/foundation.dart';
import '../data/models/hiring.dart';
import '../data/models/review.dart';
import '../data/repositories/sornet_business_repository.dart';

class HiringProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<HiredTechnician> _hiredTechnicians = [];
  List<TechnicianReview> _submittedReviews = [];

  HiringProvider(this._repository) {
    loadHiredTechnicians();
  }

  bool get isLoading => _isLoading;
  List<HiredTechnician> get hiredTechnicians => _hiredTechnicians;
  List<TechnicianReview> get submittedReviews => _submittedReviews;

  List<HiredTechnician> get activeHired =>
      _hiredTechnicians.where((h) => h.status == HiringStatus.active).toList();

  List<HiredTechnician> get upcomingHired =>
      _hiredTechnicians.where((h) => h.status == HiringStatus.upcoming).toList();

  List<HiredTechnician> get completedHired =>
      _hiredTechnicians.where((h) => h.status == HiringStatus.completed).toList();

  Future<void> loadHiredTechnicians() async {
    _isLoading = true;
    notifyListeners();

    try {
      _hiredTechnicians = await _repository.getHiredTechnicians();
      _submittedReviews = await _repository.getReviews();
    } catch (e) {
      debugPrint('Error loading hired technicians: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool canReviewTechnician(String hiringId) {
    final record = _hiredTechnicians.firstWhere(
      (h) => h.id == hiringId,
      orElse: () => HiredTechnician(
        id: '',
        technicianId: '',
        technicianName: '',
        technicianPhoto: '',
        technicianPhone: '',
        jobId: '',
        jobTitle: '',
        position: '',
        salary: 0,
        employmentType: '',
        joiningDate: DateTime.now(),
        location: '',
      ),
    );
    return record.id.isNotEmpty && !record.hasBeenReviewed;
  }

  Future<TechnicianReview> submitReview({
    required String hiringId,
    required String technicianId,
    required String technicianName,
    required String jobTitle,
    required double technicalSkillRating,
    required double professionalismRating,
    required double communicationRating,
    required double punctualityRating,
    required double qualityOfWorkRating,
    required String reviewText,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final overall = TechnicianReview.calculateOverall(
        technicalSkillRating,
        professionalismRating,
        communicationRating,
        punctualityRating,
        qualityOfWorkRating,
      );

      final review = TechnicianReview(
        id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
        technicianId: technicianId,
        technicianName: technicianName,
        businessId: 'biz-101',
        businessName: 'CoolFlow Air Conditioning & Facility Services',
        hiringId: hiringId,
        jobTitle: jobTitle,
        technicalSkillRating: technicalSkillRating,
        professionalismRating: professionalismRating,
        communicationRating: communicationRating,
        punctualityRating: punctualityRating,
        qualityOfWorkRating: qualityOfWorkRating,
        overallRating: double.parse(overall.toStringAsFixed(2)),
        reviewText: reviewText.trim(),
        createdAt: DateTime.now(),
      );

      final created = await _repository.submitReview(review);
      _submittedReviews.insert(0, created);

      final index = _hiredTechnicians.indexWhere((h) => h.id == hiringId);
      if (index != -1) {
        _hiredTechnicians[index] = _hiredTechnicians[index].copyWith(
          hasBeenReviewed: true,
          rating: created.overallRating,
        );
      }

      return created;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
