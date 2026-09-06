import 'package:flutter/material.dart';
import '../data/models/offer.dart';
import '../data/repositories/sornet_technician_repository.dart';

class OfferProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<JobOffer> _offers = [];
  bool _isLoading = false;

  OfferProvider(this._repository) {
    loadOffers();
  }

  List<JobOffer> get offers => _offers;
  bool get isLoading => _isLoading;

  List<JobOffer> get pendingOffers =>
      _offers.where((o) => o.status == OfferStatus.pending).toList();
  List<JobOffer> get acceptedOffers =>
      _offers.where((o) => o.status == OfferStatus.accepted).toList();
  List<JobOffer> get rejectedOffers =>
      _offers.where((o) => o.status == OfferStatus.rejected).toList();
  List<JobOffer> get expiredOffers =>
      _offers.where((o) => o.status == OfferStatus.expired).toList();

  JobOffer? getOfferById(String id) {
    try {
      return _offers.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

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

  Future<JobOffer> acceptOffer(String offerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.acceptOffer(offerId);
      await loadOffers();
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<JobOffer> rejectOffer(String offerId, [String reason = 'Declined by technician']) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updated = await _repository.rejectOffer(offerId, reason);
      await loadOffers();
      return updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
