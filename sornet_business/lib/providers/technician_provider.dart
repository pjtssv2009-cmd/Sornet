import 'package:flutter/foundation.dart';
import '../data/models/technician.dart';
import '../data/repositories/sornet_business_repository.dart';

class TechnicianProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<Technician> _technicians = [];
  String _searchQuery = '';
  String _selectedCity = 'All Cities';
  double _minExperience = 0;
  double _minRating = 0;
  bool _verifiedOnly = false;
  List<String> _selectedAcTypes = [];
  List<String> _selectedBrands = [];
  List<String> _selectedServices = [];
  String _sortBy = 'Recommended';

  // Side-by-side Candidate Comparison (2 to 4 candidates)
  final List<Technician> _selectedForComparison = [];

  TechnicianProvider(this._repository) {
    loadTechnicians();
  }

  bool get isLoading => _isLoading;
  List<Technician> get technicians => _technicians;
  String get searchQuery => _searchQuery;
  String get selectedCity => _selectedCity;
  double get minExperience => _minExperience;
  double get minRating => _minRating;
  bool get verifiedOnly => _verifiedOnly;
  List<String> get selectedAcTypes => _selectedAcTypes;
  List<String> get selectedBrands => _selectedBrands;
  List<String> get selectedServices => _selectedServices;
  String get sortBy => _sortBy;
  List<Technician> get selectedForComparison => _selectedForComparison;

  List<Technician> get shortlistedTechnicians =>
      _technicians.where((t) => t.isShortlisted).toList();

  int get activeFilterCount {
    int count = 0;
    if (_selectedCity != 'All Cities') count++;
    if (_minExperience > 0) count++;
    if (_minRating > 0) count++;
    if (_verifiedOnly) count++;
    count += _selectedAcTypes.length;
    count += _selectedBrands.length;
    count += _selectedServices.length;
    return count;
  }

  Future<void> loadTechnicians() async {
    _isLoading = true;
    notifyListeners();

    try {
      _technicians = await _repository.getTechnicians(
        query: _searchQuery,
        city: _selectedCity,
        minExperience: _minExperience,
        minRating: _minRating,
        verifiedOnly: _verifiedOnly,
        acTypes: _selectedAcTypes.isNotEmpty ? _selectedAcTypes : null,
        brands: _selectedBrands.isNotEmpty ? _selectedBrands : null,
        services: _selectedServices.isNotEmpty ? _selectedServices : null,
        sortBy: _sortBy,
      );
    } catch (e) {
      debugPrint('Error loading technicians: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadTechnicians();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    loadTechnicians();
  }

  void applyFilters({
    required String city,
    required double minExperience,
    required double minRating,
    required bool verifiedOnly,
    required List<String> acTypes,
    required List<String> brands,
    required List<String> services,
  }) {
    _selectedCity = city;
    _minExperience = minExperience;
    _minRating = minRating;
    _verifiedOnly = verifiedOnly;
    _selectedAcTypes = List.from(acTypes);
    _selectedBrands = List.from(brands);
    _selectedServices = List.from(services);
    loadTechnicians();
  }

  void resetFilters() {
    _selectedCity = 'All Cities';
    _minExperience = 0;
    _minRating = 0;
    _verifiedOnly = false;
    _selectedAcTypes.clear();
    _selectedBrands.clear();
    _selectedServices.clear();
    loadTechnicians();
  }

  Future<bool> toggleShortlist(String technicianId) async {
    final newStatus = await _repository.toggleShortlistTechnician(technicianId);
    final index = _technicians.indexWhere((t) => t.id == technicianId);
    if (index != -1) {
      _technicians[index] = _technicians[index].copyWith(isShortlisted: newStatus);
      notifyListeners();
    }
    return newStatus;
  }

  // Comparison Management
  bool isCandidateSelectedForComparison(String technicianId) {
    return _selectedForComparison.any((t) => t.id == technicianId);
  }

  bool toggleComparisonCandidate(Technician technician) {
    if (isCandidateSelectedForComparison(technician.id)) {
      _selectedForComparison.removeWhere((t) => t.id == technician.id);
      notifyListeners();
      return false;
    } else {
      if (_selectedForComparison.length < 4) {
        _selectedForComparison.add(technician);
        notifyListeners();
        return true;
      }
      return false; // Max 4 reached
    }
  }

  void clearComparison() {
    _selectedForComparison.clear();
    notifyListeners();
  }
}
