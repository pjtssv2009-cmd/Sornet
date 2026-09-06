import 'package:flutter/foundation.dart';
import '../data/models/business.dart';
import '../data/repositories/sornet_business_repository.dart';

class BusinessProfileProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  Business? _business;

  BusinessProfileProvider(this._repository) {
    loadProfile();
  }

  bool get isLoading => _isLoading;
  Business? get business => _business;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _business = await _repository.getCurrentBusiness();
    } catch (e) {
      debugPrint('Error loading business profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Business updated) async {
    _isLoading = true;
    notifyListeners();

    try {
      _business = await _repository.updateBusinessProfile(updated);
    } catch (e) {
      debugPrint('Error updating profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadDocument(String title, String docType) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newDoc = BusinessDocument(
        id: 'doc-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        documentType: docType,
        fileUrl: 'https://example.com/docs/$title.pdf',
        uploadDate: DateTime.now(),
        isVerified: false,
      );
      _business = await _repository.uploadBusinessDocument(newDoc);
    } catch (e) {
      debugPrint('Error uploading doc: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
