import 'package:flutter/material.dart';
import '../data/models/admin_user.dart';
import '../data/models/technician.dart';
import '../data/models/business.dart';
import '../data/models/customer.dart';
import '../data/models/job.dart';
import '../data/models/application.dart';
import '../data/models/category.dart';
import '../data/models/module_feature.dart';
import '../data/models/promotion.dart';
import '../data/models/notification_item.dart';
import '../data/models/platform_stat.dart';
import '../data/models/activity_log.dart';
import '../data/repositories/sornet_repository.dart';
import '../core/constants/app_constants.dart';

// --- Auth Provider ---
class AuthProvider extends ChangeNotifier {
  final ISornetRepository repository;
  AdminUser? _currentUser;
  bool _isLoggedIn = true; // Logged in with default demo account on launch
  bool _rememberMe = true;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({required this.repository}) {
    _initUser();
  }

  AdminUser? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void _initUser() async {
    final users = await repository.getAdminUsers();
    if (users.isNotEmpty) {
      _currentUser = users.first;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600)); // Smooth loading state

    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail == AppConstants.defaultAdminEmail && cleanPassword == AppConstants.defaultAdminPassword) {
      _isLoggedIn = true;
      final users = await repository.getAdminUsers();
      _currentUser = users.isNotEmpty ? users.first : null;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Invalid email or password. Use demo credentials: admin@sornet.com / Admin@123';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _errorMessage = null;
    notifyListeners();
  }

  void updateProfile({required String name, required String phone}) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(name: name, phone: phone);
      notifyListeners();
    }
  }
}

// --- Dashboard Provider ---
class DashboardProvider extends ChangeNotifier {
  final ISornetRepository repository;
  PlatformStat? _stats;
  List<ActivityLog> _recentActivities = [];
  String _selectedTimeRange = '30 Days'; // 'Today', '7 Days', '30 Days', '90 Days'
  bool _isLoading = false;

  DashboardProvider({required this.repository}) {
    loadDashboard();
  }

  PlatformStat? get stats => _stats;
  List<ActivityLog> get recentActivities => _recentActivities;
  String get selectedTimeRange => _selectedTimeRange;
  bool get isLoading => _isLoading;

  void setTimeRange(String range) {
    _selectedTimeRange = range;
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    _isLoading = true;
    notifyListeners();

    _stats = await repository.getPlatformStats();
    _recentActivities = await repository.getRecentActivities();

    _isLoading = false;
    notifyListeners();
  }
}

// --- Technicians Provider ---
class TechniciansProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<Technician> _technicians = [];
  String _searchQuery = '';
  VerificationStatus? _statusFilter;
  String _cityFilter = 'All Cities';
  bool _isLoading = false;

  TechniciansProvider({required this.repository}) {
    loadTechnicians();
  }

  List<Technician> get technicians => _technicians;
  String get searchQuery => _searchQuery;
  VerificationStatus? get statusFilter => _statusFilter;
  String get cityFilter => _cityFilter;
  bool get isLoading => _isLoading;

  int get verifiedCount => _technicians.where((t) => t.verificationStatus == VerificationStatus.verified).length;
  int get pendingCount => _technicians.where((t) => t.verificationStatus == VerificationStatus.pending).length;
  int get rejectedCount => _technicians.where((t) => t.verificationStatus == VerificationStatus.rejected).length;
  int get suspendedCount => _technicians.where((t) => t.verificationStatus == VerificationStatus.suspended).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadTechnicians();
  }

  void setStatusFilter(VerificationStatus? status) {
    _statusFilter = status;
    loadTechnicians();
  }

  void setCityFilter(String city) {
    _cityFilter = city;
    loadTechnicians();
  }

  Future<void> loadTechnicians() async {
    _isLoading = true;
    notifyListeners();

    _technicians = await repository.getTechnicians(
      query: _searchQuery,
      statusFilter: _statusFilter,
      cityFilter: _cityFilter,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyTechnician(String id) async {
    await repository.updateTechnicianStatus(id, VerificationStatus.verified);
    await loadTechnicians();
  }

  Future<void> rejectTechnician(String id, String reason) async {
    await repository.updateTechnicianStatus(id, VerificationStatus.rejected, reason: reason);
    await loadTechnicians();
  }

  Future<void> suspendTechnician(String id, String reason) async {
    await repository.updateTechnicianStatus(id, VerificationStatus.suspended, reason: reason);
    await loadTechnicians();
  }

  Future<void> restoreTechnician(String id) async {
    await repository.updateTechnicianStatus(id, VerificationStatus.verified);
    await loadTechnicians();
  }

  Future<void> updateChecklist(String id, VerificationChecklist checklist) async {
    await repository.updateTechnicianChecklist(id, checklist);
    await loadTechnicians();
  }

  Future<void> updateDocumentStatus(String techId, String docId, VerificationStatus status, {String? note}) async {
    await repository.updateTechDocumentStatus(techId, docId, status, note: note);
    await loadTechnicians();
  }
}

// --- Businesses Provider ---
class BusinessesProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<Business> _businesses = [];
  String _searchQuery = '';
  VerificationStatus? _statusFilter;
  String _cityFilter = 'All Cities';
  bool _isLoading = false;

  BusinessesProvider({required this.repository}) {
    loadBusinesses();
  }

  List<Business> get businesses => _businesses;
  String get searchQuery => _searchQuery;
  VerificationStatus? get statusFilter => _statusFilter;
  String get cityFilter => _cityFilter;
  bool get isLoading => _isLoading;

  int get verifiedCount => _businesses.where((b) => b.verificationStatus == VerificationStatus.verified).length;
  int get pendingCount => _businesses.where((b) => b.verificationStatus == VerificationStatus.pending).length;
  int get rejectedCount => _businesses.where((b) => b.verificationStatus == VerificationStatus.rejected).length;
  int get suspendedCount => _businesses.where((b) => b.verificationStatus == VerificationStatus.suspended).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadBusinesses();
  }

  void setStatusFilter(VerificationStatus? status) {
    _statusFilter = status;
    loadBusinesses();
  }

  void setCityFilter(String city) {
    _cityFilter = city;
    loadBusinesses();
  }

  Future<void> loadBusinesses() async {
    _isLoading = true;
    notifyListeners();

    _businesses = await repository.getBusinesses(
      query: _searchQuery,
      statusFilter: _statusFilter,
      cityFilter: _cityFilter,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyBusiness(String id) async {
    await repository.updateBusinessStatus(id, VerificationStatus.verified);
    await loadBusinesses();
  }

  Future<void> rejectBusiness(String id, String reason) async {
    await repository.updateBusinessStatus(id, VerificationStatus.rejected, reason: reason);
    await loadBusinesses();
  }

  Future<void> suspendBusiness(String id, String reason) async {
    await repository.updateBusinessStatus(id, VerificationStatus.suspended, reason: reason);
    await loadBusinesses();
  }

  Future<void> saveBusiness(Business business) async {
    await repository.saveBusiness(business);
    await loadBusinesses();
  }

  Future<void> restoreBusiness(String id) async {
    await repository.updateBusinessStatus(id, VerificationStatus.verified);
    await loadBusinesses();
  }
}

// --- Customers Provider ---
class CustomersProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<Customer> _customers = [];
  String _searchQuery = '';
  bool? _activeFilter;
  bool _isLoading = false;

  CustomersProvider({required this.repository}) {
    loadCustomers();
  }

  List<Customer> get customers => _customers;
  String get searchQuery => _searchQuery;
  bool? get activeFilter => _activeFilter;
  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadCustomers();
  }

  void setActiveFilter(bool? filter) {
    _activeFilter = filter;
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    _customers = await repository.getCustomers(
      query: _searchQuery,
      activeFilter: _activeFilter,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleCustomerStatus(String id) async {
    await repository.toggleCustomerStatus(id);
    await loadCustomers();
  }
}

// --- Jobs Provider ---
class JobsProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<Job> _jobs = [];
  String _searchQuery = '';
  JobStatus? _statusFilter;
  String _categoryFilter = 'All Categories';
  bool _isLoading = false;

  JobsProvider({required this.repository}) {
    loadJobs();
  }

  List<Job> get jobs => _jobs;
  String get searchQuery => _searchQuery;
  JobStatus? get statusFilter => _statusFilter;
  String get categoryFilter => _categoryFilter;
  bool get isLoading => _isLoading;

  int get openCount => _jobs.where((j) => j.status == JobStatus.open).length;
  int get interviewCount => _jobs.where((j) => j.status == JobStatus.interview || j.status == JobStatus.shortlisted).length;
  int get filledCount => _jobs.where((j) => j.status == JobStatus.filled).length;
  int get closedCount => _jobs.where((j) => j.status == JobStatus.closed).length;
  int get draftCount => _jobs.where((j) => j.status == JobStatus.draft).length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadJobs();
  }

  void setStatusFilter(JobStatus? status) {
    _statusFilter = status;
    loadJobs();
  }

  void setCategoryFilter(String category) {
    _categoryFilter = category;
    loadJobs();
  }

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    _jobs = await repository.getJobs(
      query: _searchQuery,
      statusFilter: _statusFilter,
      categoryFilter: _categoryFilter,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> approveJob(String id) async {
    await repository.updateJobStatus(id, JobStatus.open);
    await loadJobs();
  }

  Future<void> rejectJob(String id) async {
    await repository.updateJobStatus(id, JobStatus.cancelled);
    await loadJobs();
  }

  Future<void> closeJob(String id) async {
    await repository.updateJobStatus(id, JobStatus.closed);
    await loadJobs();
  }

  Future<void> deleteJob(String id) async {
    await repository.deleteJob(id);
    await loadJobs();
  }

  Future<void> saveJob(Job job) async {
    await repository.saveJob(job);
    await loadJobs();
  }
}

// --- Applications Provider ---
class ApplicationsProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<Application> _applications = [];
  ApplicationStatus? _statusFilter;
  String? _jobIdFilter;
  bool _isLoading = false;

  ApplicationsProvider({required this.repository}) {
    loadApplications();
  }

  List<Application> get applications => _applications;
  ApplicationStatus? get statusFilter => _statusFilter;
  bool get isLoading => _isLoading;

  void setStatusFilter(ApplicationStatus? status) {
    _statusFilter = status;
    loadApplications();
  }

  void setJobIdFilter(String? jobId) {
    _jobIdFilter = jobId;
    loadApplications();
  }

  Future<void> loadApplications() async {
    _isLoading = true;
    notifyListeners();

    _applications = await repository.getApplications(
      jobId: _jobIdFilter,
      statusFilter: _statusFilter,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateStatus(String id, ApplicationStatus status) async {
    await repository.updateApplicationStatus(id, status);
    await loadApplications();
  }
}

// --- Categories Provider ---
class CategoriesProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<ServiceCategory> _categories = [];
  bool _isLoading = false;

  CategoriesProvider({required this.repository}) {
    loadCategories();
  }

  List<ServiceCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    _categories = await repository.getCategories();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveCategory(ServiceCategory category) async {
    await repository.saveCategory(category);
    await loadCategories();
  }

  Future<void> toggleStatus(String id) async {
    await repository.toggleCategoryStatus(id);
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await repository.deleteCategory(id);
    await loadCategories();
  }
}

// --- Modules Provider ---
class ModulesProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<PlatformModule> _modules = [];
  bool _isLoading = false;

  ModulesProvider({required this.repository}) {
    loadModules();
  }

  List<PlatformModule> get modules => _modules;
  bool get isLoading => _isLoading;

  Future<void> loadModules() async {
    _isLoading = true;
    notifyListeners();

    _modules = await repository.getModules();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleModule(String id, bool isEnabled) async {
    await repository.toggleModule(id, isEnabled);
    await loadModules();
  }
}

// --- Marketing Provider ---
class MarketingProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<Promotion> _promotions = [];
  bool _isLoading = false;

  MarketingProvider({required this.repository}) {
    loadPromotions();
  }

  List<Promotion> get promotions => _promotions;
  bool get isLoading => _isLoading;

  Future<void> loadPromotions() async {
    _isLoading = true;
    notifyListeners();

    _promotions = await repository.getPromotions();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> savePromotion(Promotion promotion) async {
    await repository.savePromotion(promotion);
    await loadPromotions();
  }

  Future<void> deletePromotion(String id) async {
    await repository.deletePromotion(id);
    await loadPromotions();
  }
}

// --- Admin Users Provider ---
class AdminUsersProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<AdminUser> _adminUsers = [];
  bool _isLoading = false;

  AdminUsersProvider({required this.repository}) {
    loadAdminUsers();
  }

  List<AdminUser> get adminUsers => _adminUsers;
  bool get isLoading => _isLoading;

  Future<void> loadAdminUsers() async {
    _isLoading = true;
    notifyListeners();

    _adminUsers = await repository.getAdminUsers();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveAdminUser(AdminUser user) async {
    await repository.saveAdminUser(user);
    await loadAdminUsers();
  }

  Future<void> updateRole(String userId, AdminRole newRole) async {
    await repository.updateAdminRole(userId, newRole);
    await loadAdminUsers();
  }
}

// --- Notifications Provider ---
class NotificationsProvider extends ChangeNotifier {
  final ISornetRepository repository;
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;

  NotificationsProvider({required this.repository}) {
    loadNotifications();
  }

  List<NotificationItem> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    _notifications = await repository.getNotifications();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    await repository.markNotificationAsRead(id);
    await loadNotifications();
  }

  Future<void> markAllAsRead() async {
    await repository.markAllNotificationsAsRead();
    await loadNotifications();
  }
}

// --- Settings & API Configuration Provider ---
class SettingsProvider extends ChangeNotifier {
  String _apiBaseUrl = AppConstants.defaultApiUrl;
  String _apiKey = AppConstants.defaultApiKey;
  String _environment = AppConstants.defaultEnvironment;
  bool _biometricLogin = false;
  bool _twoFactorAuth = false;
  bool _pushNotifications = true;
  bool _smsAlerts = true;
  bool _isTestingConnection = false;
  String? _connectionStatusMessage;
  bool? _isConnectionSuccessful;

  String get apiBaseUrl => _apiBaseUrl;
  String get apiKey => _apiKey;
  String get environment => _environment;
  bool get biometricLogin => _biometricLogin;
  bool get twoFactorAuth => _twoFactorAuth;
  bool get pushNotifications => _pushNotifications;
  bool get smsAlerts => _smsAlerts;
  bool get isTestingConnection => _isTestingConnection;
  String? get connectionStatusMessage => _connectionStatusMessage;
  bool? get isConnectionSuccessful => _isConnectionSuccessful;

  void updateApiConfig({
    required String baseUrl,
    required String apiKey,
    required String environment,
  }) {
    _apiBaseUrl = baseUrl;
    _apiKey = apiKey;
    _environment = environment;
    notifyListeners();
  }

  void setBiometricLogin(bool value) {
    _biometricLogin = value;
    notifyListeners();
  }

  void setTwoFactorAuth(bool value) {
    _twoFactorAuth = value;
    notifyListeners();
  }

  void setPushNotifications(bool value) {
    _pushNotifications = value;
    notifyListeners();
  }

  void setSmsAlerts(bool value) {
    _smsAlerts = value;
    notifyListeners();
  }

  Future<void> testApiConnection() async {
    _isTestingConnection = true;
    _connectionStatusMessage = null;
    _isConnectionSuccessful = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    _isTestingConnection = false;
    _isConnectionSuccessful = true;
    _connectionStatusMessage = 'Connected successfully to ${_environment.toLowerCase()} API endpoint (Latency: 42ms)';
    notifyListeners();
  }
}
