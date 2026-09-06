import 'package:flutter/material.dart';
import '../data/models/technician.dart';
import '../data/repositories/sornet_technician_repository.dart';

class TechnicianProfileProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  Technician? _technician;
  bool _isLoading = false;

  TechnicianProfileProvider(this._repository) {
    loadProfile();
  }

  Technician? get technician => _technician;
  bool get isLoading => _isLoading;

  int get profileStrength {
    if (_technician == null) return 0;
    var score = 0;
    if (_technician!.fullName.isNotEmpty && _technician!.mobileNumber.isNotEmpty) score += 20;
    if (_technician!.experiences.isNotEmpty) score += 20;
    if (_technician!.certificates.isNotEmpty) score += 15;
    if (_technician!.documents.isNotEmpty) score += 15;
    if (_technician!.acTypes.isNotEmpty && _technician!.brands.isNotEmpty) score += 15;
    if (_technician!.availability.preferredLocations.isNotEmpty) score += 15;
    return score.clamp(0, 100);
  }

  int get profileCompleteness => profileStrength;
  int get trustScore => _technician?.trustScore ?? 92;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _technician = await _repository.getCurrentTechnician();
    } catch (e) {
      debugPrint('Error loading technician profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Technician updated) async {
    _isLoading = true;
    notifyListeners();

    try {
      _technician = await _repository.updateTechnicianProfile(updated);
    } catch (e) {
      debugPrint('Error updating profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBio(String bio) async {
    if (_technician != null) {
      final updated = _technician!.copyWith(aboutMe: bio);
      await updateProfile(updated);
    }
  }

  Future<void> updateSkills(List<String> skills) async {
    if (_technician != null) {
      final updated = _technician!.copyWith(services: skills);
      await updateProfile(updated);
    }
  }

  Future<void> updateBrands(List<String> brands) async {
    if (_technician != null) {
      final updated = _technician!.copyWith(brands: brands);
      await updateProfile(updated);
    }
  }

  Future<void> addExperience(TechnicianExperience experience) async {
    try {
      _technician = await _repository.addExperience(experience);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding experience: $e');
    }
  }

  Future<void> updateExperience(TechnicianExperience experience) async {
    try {
      _technician = await _repository.updateExperience(experience);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating experience: $e');
    }
  }

  Future<void> deleteExperience(String id) async {
    try {
      _technician = await _repository.deleteExperience(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting experience: $e');
    }
  }

  Future<void> addCertificate(TechnicianCertificate cert) async {
    try {
      _technician = await _repository.addCertificate(cert);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding certificate: $e');
    }
  }

  Future<void> deleteCertificate(String id) async {
    try {
      _technician = await _repository.deleteCertificate(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting certificate: $e');
    }
  }

  Future<void> uploadDocument(TechnicianDocument doc) async {
    try {
      _technician = await _repository.uploadDocument(doc);
      notifyListeners();
    } catch (e) {
      debugPrint('Error uploading document: $e');
    }
  }

  Future<void> addDocument(TechnicianDocument doc) async {
    await uploadDocument(doc);
  }

  Future<void> updateAvailability(TechnicianAvailability availability) async {
    try {
      _technician = await _repository.updateAvailability(availability);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating availability: $e');
    }
  }

  Future<void> updatePrivacy(TechnicianPrivacySettings privacy) async {
    try {
      _technician = await _repository.updatePrivacy(privacy);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating privacy: $e');
    }
  }

  Future<void> updatePrivacySettings(TechnicianPrivacySettings privacy) async {
    await updatePrivacy(privacy);
  }
}
