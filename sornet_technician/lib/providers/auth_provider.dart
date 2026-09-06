import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../data/models/technician.dart';
import '../data/repositories/sornet_technician_repository.dart';

enum AuthStatus {
  unauthenticated,
  authenticating,
  authenticated,
  registrationInProgress,
}

class AuthProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  AuthStatus _status = AuthStatus.unauthenticated;
  Technician? _currentTechnician;
  String? _errorMessage;

  // 8-Step Registration Draft Data
  int _registrationCurrentStep = 0;
  final Map<String, dynamic> _registrationData = {};

  AuthProvider(this._repository) {
    _init();
  }

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.authenticating;
  Technician? get currentTechnician => _currentTechnician;
  String? get errorMessage => _errorMessage;
  int get registrationCurrentStep => _registrationCurrentStep;
  Map<String, dynamic> get registrationData => _registrationData;

  Future<void> _init() async {
    // Check initial state
    try {
      _currentTechnician = await _repository.getCurrentTechnician();
    } catch (_) {}
  }

  Future<bool> login(String emailOrPhone, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedInput = emailOrPhone.trim().toLowerCase();
    final normalizedDemoEmail = AppConstants.demoEmail.toLowerCase();
    final demoPhoneDigits = AppConstants.demoPhone.replaceAll(RegExp(r'\D'), '');
    final inputDigits = emailOrPhone.replaceAll(RegExp(r'\D'), '');

    if ((normalizedInput == normalizedDemoEmail || (inputDigits.isNotEmpty && inputDigits == demoPhoneDigits)) &&
        password == AppConstants.demoPassword) {
      _currentTechnician = await _repository.getCurrentTechnician();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = 'Invalid credentials. Use demo: ${AppConstants.demoEmail} / ${AppConstants.demoPassword}';
      notifyListeners();
      return false;
    }
  }

  void loginAsDemo() {
    login(AppConstants.demoEmail, AppConstants.demoPassword);
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (otp == '123456' || otp == '000000') {
      _currentTechnician = await _repository.getCurrentTechnician();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _status = AuthStatus.unauthenticated;
      _errorMessage = 'Invalid verification code. Please enter 123456.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  // Registration Multi-Step Management
  void setRegistrationStep(int step) {
    _registrationCurrentStep = step;
    notifyListeners();
  }

  void updateRegistrationData(String key, dynamic value) {
    _registrationData[key] = value;
    notifyListeners();
  }

  void resetRegistration() {
    _registrationCurrentStep = 0;
    _registrationData.clear();
    notifyListeners();
  }

  Future<bool> submitRegistration() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    // Construct new technician profile from registration data
    final newTech = Technician(
      id: 'tech-${DateTime.now().millisecondsSinceEpoch}',
      fullName: _registrationData['fullName'] as String? ?? 'New Technician',
      photoUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200',
      mobileNumber: _registrationData['mobileNumber'] as String? ?? '+91 98402 11223',
      email: _registrationData['email'] as String? ?? 'technician@sornet.com',
      gender: _registrationData['gender'] as String? ?? 'Male',
      dateOfBirth: _registrationData['dateOfBirth'] as String? ?? '1996-01-01',
      currentCity: _registrationData['city'] as String? ?? 'Chennai',
      state: _registrationData['state'] as String? ?? 'Tamil Nadu',
      pincode: _registrationData['pincode'] as String? ?? '600001',
      primaryTrade: _registrationData['primaryTrade'] as String? ?? 'AC Technician',
      experienceYears: double.tryParse(_registrationData['experienceYears']?.toString() ?? '3.0') ?? 3.0,
      educationQualification: _registrationData['educationQualification'] as String? ?? 'ITI - RAC',
      aboutMe: _registrationData['aboutMe'] as String? ?? 'Experienced technician passionate about high quality AC service.',
      professionalSummary: _registrationData['professionalSummary'] as String? ?? 'Skilled AC technician specialized in Split and Inverter systems.',
      acTypes: (_registrationData['acTypes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Split AC', 'Window AC'],
      acTechnologies: (_registrationData['acTechnologies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Inverter', 'Non-Inverter'],
      brands: (_registrationData['brands'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Voltas', 'LG', 'Daikin'],
      services: (_registrationData['services'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Installation', 'General Servicing', 'Gas Charging'],
      languages: (_registrationData['languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Tamil', 'English'],
      experiences: [],
      certificates: [],
      documents: [],
      verification: TechnicianVerification(
        phoneVerified: true,
        emailVerified: true,
        identityVerified: false,
        experienceVerified: false,
        certificateVerified: false,
        platformVerified: false,
        overallStatus: VerificationStatus.underReview,
      ),
      availability: TechnicianAvailability(
        status: _registrationData['availabilityStatus'] as String? ?? 'Available Now',
        preferredLocations: [_registrationData['city'] as String? ?? 'Chennai'],
        preferredEmploymentType: _registrationData['employmentPreference'] as String? ?? 'Full Time',
        expectedSalaryMonthly: int.tryParse(_registrationData['expectedSalary']?.toString() ?? '25000') ?? 25000,
        expectedDailyRate: 1200,
      ),
      privacy: TechnicianPrivacySettings(),
      trustScore: 70,
      rating: 5.0,
      reviewCount: 0,
      profileStrengthPercentage: 75,
      joinedDate: DateTime.now(),
    );

    await _repository.updateTechnicianProfile(newTech);
    _currentTechnician = newTech;
    _status = AuthStatus.authenticated;
    notifyListeners();
    return true;
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }
}
