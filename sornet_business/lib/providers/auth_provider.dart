import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../data/models/business.dart';
import '../data/mock/mock_data.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = true; // Default true with demo logged in for smooth preview
  bool _isLoading = false;
  String? _errorMessage;
  Business? _currentBusiness = MockData.currentBusiness;
  bool _rememberMe = true;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Business? get currentBusiness => _currentBusiness;
  bool get rememberMe => _rememberMe;

  void toggleRememberMe(bool? val) {
    _rememberMe = val ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    final cleanEmail = email.trim().toLowerCase();
    if ((cleanEmail == AppConstants.demoEmail.toLowerCase() && password == AppConstants.demoPassword) ||
        (cleanEmail.contains('@') && password.length >= 6)) {
      _isAuthenticated = true;
      _currentBusiness = MockData.currentBusiness;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      _errorMessage = 'Invalid email or password. Use demo credentials.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithDemo() async {
    return login(AppConstants.demoEmail, AppConstants.demoPassword);
  }

  Future<bool> verifyOtp(String phone, String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    if (otp.length == 4 || otp.length == 6) {
      _isAuthenticated = true;
      _currentBusiness = MockData.currentBusiness;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      _errorMessage = 'Invalid OTP. Enter 4 or 6 digits.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerBusiness({
    required String businessName,
    required String businessType,
    required String contactPerson,
    required String mobileNumber,
    required String email,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required List<String> operatingLocations,
    required int yearsInBusiness,
    required int numberOfEmployees,
    required List<String> servicesOffered,
    String? gstNumber,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    final newBusiness = Business(
      id: 'biz-${DateTime.now().millisecondsSinceEpoch}',
      businessName: businessName,
      businessType: businessType,
      contactPerson: contactPerson,
      mobileNumber: mobileNumber,
      email: email,
      address: address,
      city: city,
      state: state,
      pincode: pincode,
      operatingLocations: operatingLocations,
      yearsInBusiness: yearsInBusiness,
      numberOfEmployees: numberOfEmployees,
      servicesOffered: servicesOffered,
      gstNumber: gstNumber,
      verification: BusinessVerification(
        phoneVerified: true,
        emailVerified: true,
        businessIdentityVerified: true,
        registrationVerified: gstNumber != null && gstNumber.isNotEmpty,
        addressVerified: true,
        adminApproved: false,
        status: VerificationStatus.underReview,
      ),
      documents: [],
      subscriptionTier: 'Free',
      joinedAt: DateTime.now(),
    );

    _currentBusiness = newBusiness;
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _isAuthenticated = false;
    _currentBusiness = null;
    notifyListeners();
  }
}
