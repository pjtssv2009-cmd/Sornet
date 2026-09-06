import '../models/admin_user.dart';
import '../models/technician.dart';
import '../models/business.dart';
import '../models/customer.dart';
import '../models/job.dart';
import '../models/application.dart';
import '../models/category.dart';
import '../models/module_feature.dart';
import '../models/promotion.dart';
import '../models/notification_item.dart';
import '../models/platform_stat.dart';
import '../models/activity_log.dart';
import '../mock/mock_data.dart';

abstract class ISornetRepository {
  // Stats
  Future<PlatformStat> getPlatformStats();
  Future<List<ActivityLog>> getRecentActivities();

  // Technicians
  Future<List<Technician>> getTechnicians({
    String? query,
    VerificationStatus? statusFilter,
    String? cityFilter,
  });
  Future<Technician?> getTechnicianById(String id);
  Future<void> updateTechnicianStatus(String id, VerificationStatus status, {String? reason});
  Future<void> updateTechnicianChecklist(String id, VerificationChecklist checklist);
  Future<void> updateTechDocumentStatus(String techId, String docId, VerificationStatus status, {String? note});
  Future<void> saveTechnician(Technician technician);

  // Businesses
  Future<List<Business>> getBusinesses({
    String? query,
    VerificationStatus? statusFilter,
    String? cityFilter,
  });
  Future<Business?> getBusinessById(String id);
  Future<void> updateBusinessStatus(String id, VerificationStatus status, {String? reason});
  Future<void> saveBusiness(Business business);

  // Customers
  Future<List<Customer>> getCustomers({String? query, bool? activeFilter});
  Future<Customer?> getCustomerById(String id);
  Future<void> toggleCustomerStatus(String id);

  // Jobs
  Future<List<Job>> getJobs({String? query, JobStatus? statusFilter, String? categoryFilter});
  Future<Job?> getJobById(String id);
  Future<void> updateJobStatus(String id, JobStatus status);
  Future<void> saveJob(Job job);
  Future<void> deleteJob(String id);

  // Applications
  Future<List<Application>> getApplications({String? jobId, ApplicationStatus? statusFilter});
  Future<Application?> getApplicationById(String id);
  Future<void> updateApplicationStatus(String id, ApplicationStatus status);

  // Categories
  Future<List<ServiceCategory>> getCategories();
  Future<void> saveCategory(ServiceCategory category);
  Future<void> toggleCategoryStatus(String id);
  Future<void> deleteCategory(String id);

  // Modules
  Future<List<PlatformModule>> getModules();
  Future<void> toggleModule(String id, bool isEnabled);

  // Marketing
  Future<List<Promotion>> getPromotions();
  Future<void> savePromotion(Promotion promotion);
  Future<void> deletePromotion(String id);

  // Admin Users & RBAC
  Future<List<AdminUser>> getAdminUsers();
  Future<void> saveAdminUser(AdminUser user);
  Future<void> updateAdminRole(String userId, AdminRole newRole);

  // Notifications
  Future<List<NotificationItem>> getNotifications();
  Future<void> markNotificationAsRead(String id);
  Future<void> markAllNotificationsAsRead();
}

class SornetRepository implements ISornetRepository {
  List<Technician> _technicians = [];
  List<Business> _businesses = [];
  List<Customer> _customers = [];
  List<Job> _jobs = [];
  List<Application> _applications = [];
  List<ServiceCategory> _categories = [];
  List<PlatformModule> _modules = [];
  List<Promotion> _promotions = [];
  List<NotificationItem> _notifications = [];
  List<ActivityLog> _activities = [];
  List<AdminUser> _adminUsers = [];

  bool _initialized = false;

  SornetRepository() {
    _init();
  }

  void _init() {
    if (_initialized) return;
    _technicians = List.from(MockData.getTechnicians());
    _businesses = List.from(MockData.getBusinesses());
    _customers = List.from(MockData.getCustomers());
    _jobs = List.from(MockData.getJobs());
    _applications = List.from(MockData.getApplications());
    _categories = List.from(MockData.getCategories());
    _modules = List.from(MockData.getPlatformModules());
    _promotions = List.from(MockData.getPromotions());
    _notifications = List.from(MockData.getNotifications());
    _activities = List.from(MockData.getRecentActivities());
    _adminUsers = List.from(MockData.getAdminUsers());
    _initialized = true;
  }

  @override
  Future<PlatformStat> getPlatformStats() async {
    final totalTechs = _technicians.length + 12438; // base benchmark + active
    final verifiedTechs = _technicians.where((t) => t.verificationStatus == VerificationStatus.verified).length + 8913;
    final pendingTechs = _technicians.where((t) => t.verificationStatus == VerificationStatus.pending).length + 239;
    final rejectedTechs = _technicians.where((t) => t.verificationStatus == VerificationStatus.rejected).length + 140;
    final suspendedTechs = _technicians.where((t) => t.verificationStatus == VerificationStatus.suspended).length + 120;

    final totalBiz = _businesses.length + 1234;
    final verifiedBiz = _businesses.where((b) => b.verificationStatus == VerificationStatus.verified).length + 1082;
    final pendingBiz = _businesses.where((b) => b.verificationStatus == VerificationStatus.pending).length + 42;
    final rejectedBiz = _businesses.where((b) => b.verificationStatus == VerificationStatus.rejected).length + 28;

    final totalCust = _customers.length + 3840;
    final activeCust = _customers.where((c) => c.isActive).length + 3720;

    final totalJobsCount = _jobs.length + 418;
    final activeJobsCount = _jobs.where((j) => j.status == JobStatus.open || j.status == JobStatus.interview || j.status == JobStatus.shortlisted).length + 390;
    final pendingJobsCount = _jobs.where((j) => !j.isApprovedByAdmin || j.status == JobStatus.draft).length + 28;
    final filledJobsCount = _jobs.where((j) => j.status == JobStatus.filled).length + 180;
    final closedJobsCount = _jobs.where((j) => j.status == JobStatus.closed).length + 95;

    final totalAppsCount = _applications.length + 3105;
    final selectedAppsCount = _applications.where((a) => a.status == ApplicationStatus.selected).length + 650;
    final interviewAppsCount = _applications.where((a) => a.status == ApplicationStatus.interview).length + 240;

    return PlatformStat(
      totalTechnicians: totalTechs,
      verifiedTechnicians: verifiedTechs,
      pendingTechVerifications: pendingTechs,
      rejectedTechnicians: rejectedTechs,
      suspendedTechnicians: suspendedTechs,
      totalBusinesses: totalBiz,
      verifiedBusinesses: verifiedBiz,
      pendingBusinessVerifications: pendingBiz,
      rejectedBusinesses: rejectedBiz,
      totalCustomers: totalCust,
      activeCustomers: activeCust,
      totalJobs: totalJobsCount,
      activeJobs: activeJobsCount,
      pendingJobs: pendingJobsCount,
      filledJobs: filledJobsCount,
      closedJobs: closedJobsCount,
      totalApplications: totalAppsCount,
      selectedApplications: selectedAppsCount,
      interviewApplications: interviewAppsCount,
      techGrowthPercentage: 14.8,
      businessGrowthPercentage: 9.4,
      jobsGrowthPercentage: 18.2,
      appsGrowthPercentage: 22.6,
    );
  }

  @override
  Future<List<ActivityLog>> getRecentActivities() async {
    return List.unmodifiable(_activities);
  }

  // --- Technicians ---
  @override
  Future<List<Technician>> getTechnicians({
    String? query,
    VerificationStatus? statusFilter,
    String? cityFilter,
  }) async {
    var result = List<Technician>.from(_technicians);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((t) {
        return t.name.toLowerCase().contains(q) ||
            t.phone.contains(q) ||
            t.email.toLowerCase().contains(q) ||
            t.primarySkill.toLowerCase().contains(q) ||
            t.location.toLowerCase().contains(q) ||
            t.city.toLowerCase().contains(q);
      }).toList();
    }

    if (statusFilter != null) {
      result = result.where((t) => t.verificationStatus == statusFilter).toList();
    }

    if (cityFilter != null && cityFilter != 'All Cities') {
      result = result.where((t) => t.city.toLowerCase() == cityFilter.toLowerCase()).toList();
    }

    return result;
  }

  @override
  Future<Technician?> getTechnicianById(String id) async {
    try {
      return _technicians.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateTechnicianStatus(String id, VerificationStatus status, {String? reason}) async {
    final index = _technicians.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = _technicians[index];
      final newChecklist = status == VerificationStatus.verified
          ? current.verificationChecklist.copyWith(
              phoneVerified: true,
              identityVerified: true,
              experienceVerified: true,
              certificateVerified: true,
              adminVerified: true,
            )
          : current.verificationChecklist;

      _technicians[index] = current.copyWith(
        verificationStatus: status,
        rejectionReason: status == VerificationStatus.rejected ? reason : null,
        suspensionReason: status == VerificationStatus.suspended ? reason : null,
        verificationChecklist: newChecklist,
        trustScore: status == VerificationStatus.verified ? 95 : (status == VerificationStatus.rejected ? 40 : 60),
      );

      _activities.insert(
        0,
        ActivityLog(
          id: 'act_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Technician Status Updated',
          description: '${current.name} status changed to ${status.label}',
          type: status == VerificationStatus.verified ? ActivityType.technicianVerified : ActivityType.systemUpdate,
          timestamp: DateTime.now(),
          entityId: current.id,
          entityType: 'technician',
        ),
      );
    }
  }

  @override
  Future<void> updateTechnicianChecklist(String id, VerificationChecklist checklist) async {
    final index = _technicians.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = _technicians[index];
      final isAllChecked = checklist.phoneVerified &&
          checklist.identityVerified &&
          checklist.experienceVerified &&
          checklist.certificateVerified &&
          checklist.adminVerified;

      _technicians[index] = current.copyWith(
        verificationChecklist: checklist,
        verificationStatus: isAllChecked ? VerificationStatus.verified : current.verificationStatus,
      );
    }
  }

  @override
  Future<void> updateTechDocumentStatus(String techId, String docId, VerificationStatus status, {String? note}) async {
    final techIndex = _technicians.indexWhere((t) => t.id == techId);
    if (techIndex != -1) {
      final current = _technicians[techIndex];
      final updatedDocs = current.documents.map((doc) {
        if (doc.id == docId) {
          return doc.copyWith(status: status, rejectionNote: note);
        }
        return doc;
      }).toList();

      _technicians[techIndex] = current.copyWith(documents: updatedDocs);
    }
  }

  @override
  Future<void> saveTechnician(Technician technician) async {
    final index = _technicians.indexWhere((t) => t.id == technician.id);
    if (index != -1) {
      _technicians[index] = technician;
    } else {
      _technicians.insert(0, technician);
    }
  }

  // --- Businesses ---
  @override
  Future<List<Business>> getBusinesses({
    String? query,
    VerificationStatus? statusFilter,
    String? cityFilter,
  }) async {
    var result = List<Business>.from(_businesses);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((b) {
        return b.businessName.toLowerCase().contains(q) ||
            b.contactPerson.toLowerCase().contains(q) ||
            b.phone.contains(q) ||
            b.email.toLowerCase().contains(q) ||
            b.registrationNumber.toLowerCase().contains(q) ||
            b.businessType.toLowerCase().contains(q) ||
            b.city.toLowerCase().contains(q);
      }).toList();
    }

    if (statusFilter != null) {
      result = result.where((b) => b.verificationStatus == statusFilter).toList();
    }

    if (cityFilter != null && cityFilter != 'All Cities') {
      result = result.where((b) => b.city.toLowerCase() == cityFilter.toLowerCase()).toList();
    }

    return result;
  }

  @override
  Future<Business?> getBusinessById(String id) async {
    try {
      return _businesses.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateBusinessStatus(String id, VerificationStatus status, {String? reason}) async {
    final index = _businesses.indexWhere((b) => b.id == id);
    if (index != -1) {
      final current = _businesses[index];
      _businesses[index] = current.copyWith(
        verificationStatus: status,
        rejectionReason: status == VerificationStatus.rejected ? reason : null,
        suspensionReason: status == VerificationStatus.suspended ? reason : null,
      );

      _activities.insert(
        0,
        ActivityLog(
          id: 'act_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Business Verification Updated',
          description: '${current.businessName} status changed to ${status.label}',
          type: status == VerificationStatus.verified ? ActivityType.businessVerified : ActivityType.systemUpdate,
          timestamp: DateTime.now(),
          entityId: current.id,
          entityType: 'business',
        ),
      );
    }
  }

  @override
  Future<void> saveBusiness(Business business) async {
    final index = _businesses.indexWhere((b) => b.id == business.id);
    if (index != -1) {
      _businesses[index] = business;
    } else {
      _businesses.insert(0, business);
    }
  }

  // --- Customers ---
  @override
  Future<List<Customer>> getCustomers({String? query, bool? activeFilter}) async {
    var result = List<Customer>.from(_customers);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((c) {
        return c.name.toLowerCase().contains(q) ||
            c.phone.contains(q) ||
            c.email.toLowerCase().contains(q) ||
            c.city.toLowerCase().contains(q);
      }).toList();
    }

    if (activeFilter != null) {
      result = result.where((c) => c.isActive == activeFilter).toList();
    }

    return result;
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> toggleCustomerStatus(String id) async {
    final index = _customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      final current = _customers[index];
      _customers[index] = current.copyWith(isActive: !current.isActive);
    }
  }

  // --- Jobs ---
  @override
  Future<List<Job>> getJobs({String? query, JobStatus? statusFilter, String? categoryFilter}) async {
    var result = List<Job>.from(_jobs);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      result = result.where((j) {
        return j.title.toLowerCase().contains(q) ||
            j.businessName.toLowerCase().contains(q) ||
            j.location.toLowerCase().contains(q) ||
            j.category.toLowerCase().contains(q);
      }).toList();
    }

    if (statusFilter != null) {
      result = result.where((j) => j.status == statusFilter).toList();
    }

    if (categoryFilter != null && categoryFilter != 'All Categories') {
      result = result.where((j) => j.category.toLowerCase() == categoryFilter.toLowerCase()).toList();
    }

    return result;
  }

  @override
  Future<Job?> getJobById(String id) async {
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateJobStatus(String id, JobStatus status) async {
    final index = _jobs.indexWhere((j) => j.id == id);
    if (index != -1) {
      final current = _jobs[index];
      _jobs[index] = current.copyWith(
        status: status,
        isApprovedByAdmin: status != JobStatus.draft && status != JobStatus.cancelled,
      );
    }
  }

  @override
  Future<void> saveJob(Job job) async {
    final index = _jobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      _jobs[index] = job;
    } else {
      _jobs.insert(0, job);
      _activities.insert(
        0,
        ActivityLog(
          id: 'act_${DateTime.now().millisecondsSinceEpoch}',
          title: 'New Job Created',
          description: '${job.businessName} posted "${job.title}"',
          type: ActivityType.newJobPosted,
          timestamp: DateTime.now(),
          entityId: job.id,
          entityType: 'job',
        ),
      );
    }
  }

  @override
  Future<void> deleteJob(String id) async {
    _jobs.removeWhere((j) => j.id == id);
    _applications.removeWhere((a) => a.jobId == id);
  }

  // --- Applications ---
  @override
  Future<List<Application>> getApplications({String? jobId, ApplicationStatus? statusFilter}) async {
    var result = List<Application>.from(_applications);

    if (jobId != null) {
      result = result.where((a) => a.jobId == jobId).toList();
    }

    if (statusFilter != null) {
      result = result.where((a) => a.status == statusFilter).toList();
    }

    return result;
  }

  @override
  Future<Application?> getApplicationById(String id) async {
    try {
      return _applications.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateApplicationStatus(String id, ApplicationStatus status) async {
    final index = _applications.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = _applications[index];
      _applications[index] = current.copyWith(status: status);

      if (status == ApplicationStatus.selected) {
        _activities.insert(
          0,
          ActivityLog(
            id: 'act_${DateTime.now().millisecondsSinceEpoch}',
            title: 'Technician Hired',
            description: '${current.businessName} selected ${current.technicianName} for "${current.jobTitle}"',
            type: ActivityType.hiredTechnician,
            timestamp: DateTime.now(),
            entityId: current.id,
            entityType: 'application',
          ),
        );
      }
    }
  }

  // --- Categories ---
  @override
  Future<List<ServiceCategory>> getCategories() async {
    return List.unmodifiable(_categories);
  }

  @override
  Future<void> saveCategory(ServiceCategory category) async {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    } else {
      _categories.add(category);
    }
  }

  @override
  Future<void> toggleCategoryStatus(String id) async {
    final index = _categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      final current = _categories[index];
      _categories[index] = current.copyWith(isActive: !current.isActive);
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((c) => c.id == id);
  }

  // --- Modules ---
  @override
  Future<List<PlatformModule>> getModules() async {
    return List.unmodifiable(_modules);
  }

  @override
  Future<void> toggleModule(String id, bool isEnabled) async {
    final index = _modules.indexWhere((m) => m.id == id);
    if (index != -1) {
      final current = _modules[index];
      _modules[index] = current.copyWith(isEnabled: isEnabled);

      _activities.insert(
        0,
        ActivityLog(
          id: 'act_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Platform Module ${isEnabled ? 'Enabled' : 'Disabled'}',
          description: 'Module "${current.name}" was ${isEnabled ? 'enabled' : 'disabled'} by Admin.',
          type: ActivityType.systemUpdate,
          timestamp: DateTime.now(),
          entityId: current.id,
          entityType: 'module',
        ),
      );
    }
  }

  // --- Marketing ---
  @override
  Future<List<Promotion>> getPromotions() async {
    return List.unmodifiable(_promotions);
  }

  @override
  Future<void> savePromotion(Promotion promotion) async {
    final index = _promotions.indexWhere((p) => p.id == promotion.id);
    if (index != -1) {
      _promotions[index] = promotion;
    } else {
      _promotions.insert(0, promotion);
    }
  }

  @override
  Future<void> deletePromotion(String id) async {
    _promotions.removeWhere((p) => p.id == id);
  }

  // --- Admin Users ---
  @override
  Future<List<AdminUser>> getAdminUsers() async {
    return List.unmodifiable(_adminUsers);
  }

  @override
  Future<void> saveAdminUser(AdminUser user) async {
    final index = _adminUsers.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _adminUsers[index] = user;
    } else {
      _adminUsers.add(user);
    }
  }

  @override
  Future<void> updateAdminRole(String userId, AdminRole newRole) async {
    final index = _adminUsers.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _adminUsers[index] = _adminUsers[index].copyWith(role: newRole);
    }
  }

  // --- Notifications ---
  @override
  Future<List<NotificationItem>> getNotifications() async {
    return List.unmodifiable(_notifications);
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
  }
}
