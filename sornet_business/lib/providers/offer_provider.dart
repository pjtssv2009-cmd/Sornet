import 'package:flutter/foundation.dart';
import '../data/models/offer.dart';
import '../data/models/hiring.dart';
import '../data/repositories/sornet_business_repository.dart';

class OfferProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<JobOffer> _offers = [];

  OfferProvider(this._repository) {
    loadOffers();
  }

  bool get isLoading => _isLoading;
  List<JobOffer> get offers => _offers;

  List<JobOffer> get sentOffers => _offers.where((o) => o.status == OfferStatus.sent).toList();
  List<JobOffer> get acceptedOffers => _offers.where((o) => o.status == OfferStatus.accepted).toList();
  List<JobOffer> get rejectedOffers => _offers.where((o) => o.status == OfferStatus.rejected).toList();
  List<JobOffer> get expiredOffers => _offers.where((o) => o.status == OfferStatus.expired).toList();

  Future<void> loadOffers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _offers = await _repository.getOffers();
    } catch (e) {
      debugPrint('Error loading offers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<JobOffer> createAndSendOffer({
    required String technicianId,
    required String technicianName,
    required String technicianPhoto,
    required String technicianPhone,
    required String jobId,
    required String jobTitle,
    required String position,
    required int salaryAmount,
    String salaryPeriod = 'month',
    required String employmentType,
    required DateTime joiningDate,
    required String workingHours,
    required String location,
    required List<String> benefits,
    String? additionalTerms,
    String? personalMessage,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final offer = JobOffer(
        id: 'ofr-${DateTime.now().millisecondsSinceEpoch}',
        technicianId: technicianId,
        technicianName: technicianName,
        technicianPhoto: technicianPhoto,
        technicianPhone: technicianPhone,
        jobId: jobId,
        jobTitle: jobTitle,
        position: position,
        salaryAmount: salaryAmount,
        salaryPeriod: salaryPeriod,
        employmentType: employmentType,
        joiningDate: joiningDate,
        workingHours: workingHours,
        location: location,
        benefits: benefits,
        additionalTerms: additionalTerms,
        personalMessage: personalMessage,
        status: OfferStatus.sent,
        sentDate: DateTime.now(),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      );

      final created = await _repository.sendOffer(offer);
      _offers.insert(0, created);
      return created;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelOffer(String offerId) async {
    try {
      final success = await _repository.cancelOffer(offerId);
      if (success) {
        final index = _offers.indexWhere((o) => o.id == offerId);
        if (index != -1) {
          _offers[index] = _offers[index].copyWith(status: OfferStatus.cancelled);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error cancelling offer: $e');
    }
  }

  Future<HiredTechnician> acceptOffer(String offerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final hired = await _repository.acceptOfferAndHire(offerId);
      final index = _offers.indexWhere((o) => o.id == offerId);
      if (index != -1) {
        _offers[index] = _offers[index].copyWith(status: OfferStatus.accepted);
      }
      return hired;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
