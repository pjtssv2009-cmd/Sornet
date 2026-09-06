import '../mock/mock_data.dart';
import '../models/technician.dart';
import '../models/job.dart';
import '../models/application.dart';
import '../models/interview.dart';
import '../models/message.dart';
import '../models/offer.dart';
import '../models/work.dart';
import '../models/review.dart';
import '../models/notification_item.dart';
import '../models/support_ticket.dart';

abstract class ISornetTechnicianRepository {
  // Technician Profile & Credentials
  Future<Technician> getCurrentTechnician();
  Future<Technician> updateTechnicianProfile(Technician technician);
  Future<Technician> addExperience(TechnicianExperience experience);
  Future<Technician> updateExperience(TechnicianExperience experience);
  Future<Technician> deleteExperience(String experienceId);
  Future<Technician> addCertificate(TechnicianCertificate certificate);
  Future<Technician> deleteCertificate(String certificateId);
  Future<Technician> uploadDocument(TechnicianDocument document);
  Future<Technician> updateAvailability(TechnicianAvailability availability);
  Future<Technician> updatePrivacy(TechnicianPrivacySettings privacy);

  // Jobs Discovery
  Future<List<Job>> getJobs({
    String? query,
    String? city,
    String? category,
    String? acType,
    String? brand,
    String? service,
    String? employmentType,
    int? minSalary,
    int? maxSalary,
    String? sortBy, // 'recommended', 'newest', 'salary_high', 'distance', 'experience'
  });
  Future<Job?> getJobById(String id);
  Future<bool> toggleSaveJob(String jobId);
  Future<List<SavedJob>> getSavedJobs();
  Future<List<JobAlert>> getJobAlerts();
  Future<JobAlert> createJobAlert(JobAlert alert);
  Future<bool> deleteJobAlert(String alertId);

  // Applications
  Future<List<Application>> getApplications({ApplicationStatus? status});
  Future<Application?> getApplicationById(String id);
  Future<Application> applyForJob({
    required String jobId,
    required int expectedSalary,
    required String availability,
    String? coverNote,
  });
  Future<bool> withdrawApplication(String applicationId);

  // Interviews
  Future<List<Interview>> getInterviews({InterviewStatus? status});
  Future<Interview?> getInterviewById(String id);
  Future<Interview> rescheduleInterview(String interviewId, DateTime newDateTime);
  Future<Interview> cancelInterview(String interviewId, String reason);

  // Job Offers
  Future<List<JobOffer>> getOffers({OfferStatus? status});
  Future<JobOffer?> getOfferById(String id);
  Future<JobOffer> acceptOffer(String offerId);
  Future<JobOffer> rejectOffer(String offerId, String reason);

  // Work & Hired Jobs
  Future<List<WorkRecord>> getWorkRecords({WorkStatus? status});
  Future<WorkRecord?> getWorkRecordById(String id);
  Future<EmployerRating> submitEmployerRating(EmployerRating rating);

  // Messaging
  Future<List<ConversationThread>> getConversations();
  Future<List<ChatMessage>> getMessages(String businessId);
  Future<ChatMessage> sendMessage(String businessId, String text);

  // Reviews & Ratings
  Future<List<BusinessReview>> getMyReviews();

  // Notifications
  Future<List<NotificationItem>> getNotifications();
  Future<bool> markNotificationAsRead(String notificationId);
  Future<bool> markAllNotificationsAsRead();

  // Support
  Future<List<SupportTicket>> getSupportTickets();
  Future<SupportTicket> createSupportTicket(SupportTicket ticket);
}

class SornetTechnicianRepository implements ISornetTechnicianRepository {
  // In-memory persistent data store
  Technician _technician = MockData.currentTechnician;
  final List<Job> _jobs = List.from(MockData.sampleJobs);
  final List<SavedJob> _savedJobs = List.from(MockData.sampleSavedJobs);
  final List<JobAlert> _jobAlerts = List.from(MockData.sampleJobAlerts);
  final List<Application> _applications = List.from(MockData.sampleApplications);
  final List<Interview> _interviews = List.from(MockData.sampleInterviews);
  final List<JobOffer> _offers = List.from(MockData.sampleOffers);
  final List<WorkRecord> _workRecords = List.from(MockData.sampleWorkRecords);
  final List<BusinessReview> _reviews = List.from(MockData.sampleReviews);
  final List<NotificationItem> _notifications = List.from(MockData.sampleNotifications);
  final List<ConversationThread> _threads = List.from(MockData.sampleThreads);
  final Map<String, List<ChatMessage>> _messages = Map.from(MockData.sampleMessages);
  final List<SupportTicket> _tickets = List.from(MockData.sampleTickets);

  // Profile Methods
  @override
  Future<Technician> getCurrentTechnician() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _technician;
  }

  @override
  Future<Technician> updateTechnicianProfile(Technician technician) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _technician = technician;
    return _technician;
  }

  @override
  Future<Technician> addExperience(TechnicianExperience experience) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedList = List<TechnicianExperience>.from(_technician.experiences)..insert(0, experience);
    _technician = _technician.copyWith(experiences: updatedList);
    return _technician;
  }

  @override
  Future<Technician> updateExperience(TechnicianExperience experience) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedList = _technician.experiences.map((e) => e.id == experience.id ? experience : e).toList();
    _technician = _technician.copyWith(experiences: updatedList);
    return _technician;
  }

  @override
  Future<Technician> deleteExperience(String experienceId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedList = _technician.experiences.where((e) => e.id != experienceId).toList();
    _technician = _technician.copyWith(experiences: updatedList);
    return _technician;
  }

  @override
  Future<Technician> addCertificate(TechnicianCertificate certificate) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedList = List<TechnicianCertificate>.from(_technician.certificates)..insert(0, certificate);
    _technician = _technician.copyWith(certificates: updatedList);
    return _technician;
  }

  @override
  Future<Technician> deleteCertificate(String certificateId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final updatedList = _technician.certificates.where((c) => c.id != certificateId).toList();
    _technician = _technician.copyWith(certificates: updatedList);
    return _technician;
  }

  @override
  Future<Technician> uploadDocument(TechnicianDocument document) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final updatedList = List<TechnicianDocument>.from(_technician.documents)..insert(0, document);
    _technician = _technician.copyWith(documents: updatedList);
    return _technician;
  }

  @override
  Future<Technician> updateAvailability(TechnicianAvailability availability) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _technician = _technician.copyWith(availability: availability);
    return _technician;
  }

  @override
  Future<Technician> updatePrivacy(TechnicianPrivacySettings privacy) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _technician = _technician.copyWith(privacy: privacy);
    return _technician;
  }

  // Jobs Methods
  @override
  Future<List<Job>> getJobs({
    String? query,
    String? city,
    String? category,
    String? acType,
    String? brand,
    String? service,
    String? employmentType,
    int? minSalary,
    int? maxSalary,
    String? sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var results = List<Job>.from(_jobs);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((j) {
        return j.title.toLowerCase().contains(q) ||
            j.businessName.toLowerCase().contains(q) ||
            j.city.toLowerCase().contains(q) ||
            j.skillsRequired.any((s) => s.toLowerCase().contains(q)) ||
            j.brands.any((b) => b.toLowerCase().contains(q));
      }).toList();
    }

    if (city != null && city.isNotEmpty && city != 'All Cities') {
      results = results.where((j) => j.city.toLowerCase() == city.toLowerCase()).toList();
    }

    if (category != null && category.isNotEmpty && category != 'All Categories') {
      results = results.where((j) => j.category.toLowerCase() == category.toLowerCase()).toList();
    }

    if (acType != null && acType.isNotEmpty) {
      results = results.where((j) => j.acTypes.any((t) => t.toLowerCase() == acType.toLowerCase())).toList();
    }

    if (brand != null && brand.isNotEmpty) {
      results = results.where((j) => j.brands.any((b) => b.toLowerCase() == brand.toLowerCase())).toList();
    }

    if (service != null && service.isNotEmpty) {
      results = results.where((j) => j.requiredServices.any((s) => s.toLowerCase() == service.toLowerCase())).toList();
    }

    if (employmentType != null && employmentType.isNotEmpty && employmentType != 'All Types') {
      results = results.where((j) => j.technicianType.toLowerCase() == employmentType.toLowerCase()).toList();
    }

    if (minSalary != null) {
      results = results.where((j) => j.maxSalary >= minSalary).toList();
    }

    if (maxSalary != null) {
      results = results.where((j) => j.minSalary <= maxSalary).toList();
    }

    if (sortBy != null) {
      switch (sortBy) {
        case 'salary_high':
          results.sort((a, b) => b.maxSalary.compareTo(a.maxSalary));
          break;
        case 'distance':
          results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          break;
        case 'newest':
          results.sort((a, b) => b.postedDate.compareTo(a.postedDate));
          break;
        case 'recommended':
        default:
          // Default sorting maintains quality balance
          break;
      }
    }

    return results;
  }

  @override
  Future<Job?> getJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> toggleSaveJob(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index != -1) {
      final updated = _jobs[index].copyWith(isSaved: !_jobs[index].isSaved);
      _jobs[index] = updated;

      if (updated.isSaved) {
        _savedJobs.add(SavedJob(id: 'saved-${DateTime.now().millisecondsSinceEpoch}', job: updated, savedAt: DateTime.now()));
      } else {
        _savedJobs.removeWhere((s) => s.job.id == jobId);
      }
      return updated.isSaved;
    }
    return false;
  }

  @override
  Future<List<SavedJob>> getSavedJobs() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _savedJobs;
  }

  @override
  Future<List<JobAlert>> getJobAlerts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _jobAlerts;
  }

  @override
  Future<JobAlert> createJobAlert(JobAlert alert) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _jobAlerts.insert(0, alert);
    return alert;
  }

  @override
  Future<bool> deleteJobAlert(String alertId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _jobAlerts.removeWhere((a) => a.id == alertId);
    return true;
  }

  // Applications Methods
  @override
  Future<List<Application>> getApplications({ApplicationStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (status != null) {
      return _applications.where((a) => a.status == status).toList();
    }
    return _applications;
  }

  @override
  Future<Application?> getApplicationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _applications.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Application> applyForJob({
    required String jobId,
    required int expectedSalary,
    required String availability,
    String? coverNote,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final job = _jobs.firstWhere(
      (j) => j.id == jobId,
      orElse: () => _jobs.first,
    );

    final jobIndex = _jobs.indexWhere((j) => j.id == jobId);
    if (jobIndex != -1) {
      _jobs[jobIndex] = _jobs[jobIndex].copyWith(hasApplied: true);
    }

    final newApplication = Application(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      jobId: job.id,
      jobTitle: job.title,
      businessId: job.businessId,
      businessName: job.businessName,
      businessLogo: job.businessLogo,
      isBusinessVerified: job.isBusinessVerified,
      location: job.location,
      city: job.city,
      minSalary: job.minSalary,
      maxSalary: job.maxSalary,
      salaryPeriod: job.salaryPeriod,
      technicianType: job.technicianType,
      appliedDate: DateTime.now(),
      status: ApplicationStatus.applied,
      expectedSalary: expectedSalary,
      availability: availability,
      coverNote: coverNote,
      timeline: [
        TimelineStep(
          title: 'Applied',
          description: 'Application successfully submitted to ${job.businessName}',
          timestamp: DateTime.now(),
          isCompleted: true,
          isCurrent: true,
        ),
        TimelineStep(
          title: 'Profile Reviewed',
          description: 'Employer review in progress',
          isCompleted: false,
        ),
        TimelineStep(
          title: 'Shortlisted',
          description: 'Awaiting shortlisting decision',
          isCompleted: false,
        ),
        TimelineStep(
          title: 'Interview',
          description: 'Interview round',
          isCompleted: false,
        ),
        TimelineStep(
          title: 'Offer',
          description: 'Formal job offer',
          isCompleted: false,
        ),
        TimelineStep(
          title: 'Hired',
          description: 'Final hiring & onboarding',
          isCompleted: false,
        ),
      ],
    );

    _applications.insert(0, newApplication);

    // Create notification
    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Application Submitted',
        message: 'Your application for "${job.title}" at ${job.businessName} was delivered.',
        type: NotificationType.applicationSubmitted,
        timestamp: DateTime.now(),
        targetId: newApplication.id,
      ),
    );

    return newApplication;
  }

  @override
  Future<bool> withdrawApplication(String applicationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(status: ApplicationStatus.withdrawn);
      return true;
    }
    return false;
  }

  // Interviews Methods
  @override
  Future<List<Interview>> getInterviews({InterviewStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (status != null) {
      return _interviews.where((i) => i.status == status).toList();
    }
    return _interviews;
  }

  @override
  Future<Interview?> getInterviewById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _interviews.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Interview> rescheduleInterview(String interviewId, DateTime newDateTime) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _interviews.indexWhere((i) => i.id == interviewId);
    if (index != -1) {
      final updated = _interviews[index].copyWith(
        scheduledAt: newDateTime,
        status: InterviewStatus.rescheduled,
      );
      _interviews[index] = updated;
      return updated;
    }
    throw Exception('Interview not found');
  }

  @override
  Future<Interview> cancelInterview(String interviewId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _interviews.indexWhere((i) => i.id == interviewId);
    if (index != -1) {
      final updated = _interviews[index].copyWith(
        status: InterviewStatus.cancelled,
        feedback: 'Cancelled by candidate: $reason',
      );
      _interviews[index] = updated;
      return updated;
    }
    throw Exception('Interview not found');
  }

  // Offers Methods
  @override
  Future<List<JobOffer>> getOffers({OfferStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (status != null) {
      return _offers.where((o) => o.status == status).toList();
    }
    return _offers;
  }

  @override
  Future<JobOffer?> getOfferById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _offers.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<JobOffer> acceptOffer(String offerId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final updated = _offers[index].copyWith(
        status: OfferStatus.accepted,
        responseDate: DateTime.now(),
      );
      _offers[index] = updated;

      // Add to work records
      _workRecords.insert(
        0,
        WorkRecord(
          id: 'work-${DateTime.now().millisecondsSinceEpoch}',
          offerId: updated.id,
          jobId: updated.jobId,
          jobTitle: updated.jobTitle,
          position: updated.position,
          businessId: updated.businessId,
          businessName: updated.businessName,
          businessLogo: updated.businessLogo,
          isBusinessVerified: updated.isBusinessVerified,
          contactPerson: 'Manager (${updated.businessName})',
          contactPhone: '+91 98401 23456',
          workLocation: updated.location,
          city: updated.city,
          salary: updated.offeredSalary,
          salaryPeriod: updated.salaryPeriod,
          employmentType: updated.employmentType,
          workingHours: updated.workingHours,
          startDate: updated.joiningDate,
          responsibilities: [
            'Lead field operations and customer service delivery',
            'Comply with safety protocols and equipment standards',
          ],
          workSummary: 'Offer accepted. Onboarding active.',
          status: WorkStatus.upcoming,
        ),
      );

      // Create notification
      _notifications.insert(
        0,
        NotificationItem(
          id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
          title: '🎉 Offer Accepted!',
          message: 'Congratulations! You accepted the offer from ${updated.businessName}. Start date: ${updated.joiningDate.day}/${updated.joiningDate.month}/${updated.joiningDate.year}.',
          type: NotificationType.offerAccepted,
          timestamp: DateTime.now(),
        ),
      );

      return updated;
    }
    throw Exception('Offer not found');
  }

  @override
  Future<JobOffer> rejectOffer(String offerId, String reason) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      final updated = _offers[index].copyWith(
        status: OfferStatus.rejected,
        responseRemarks: reason,
        responseDate: DateTime.now(),
      );
      _offers[index] = updated;
      return updated;
    }
    throw Exception('Offer not found');
  }

  // Work Records Methods
  @override
  Future<List<WorkRecord>> getWorkRecords({WorkStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (status != null) {
      return _workRecords.where((w) => w.status == status).toList();
    }
    return _workRecords;
  }

  @override
  Future<WorkRecord?> getWorkRecordById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _workRecords.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<EmployerRating> submitEmployerRating(EmployerRating rating) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final workIndex = _workRecords.indexWhere((w) => w.id == rating.workId);
    if (workIndex != -1) {
      _workRecords[workIndex] = _workRecords[workIndex].copyWith(isRatedByTechnician: true);
    }
    return rating;
  }

  // Messaging Methods
  @override
  Future<List<ConversationThread>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _threads;
  }

  @override
  Future<List<ChatMessage>> getMessages(String businessId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _messages[businessId] ?? [];
  }

  @override
  Future<ChatMessage> sendMessage(String businessId, String text) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final newMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderId: _technician.id,
      senderName: _technician.fullName,
      isFromTechnician: true,
      text: text,
      timestamp: DateTime.now(),
    );

    if (!_messages.containsKey(businessId)) {
      _messages[businessId] = [];
    }
    _messages[businessId]!.add(newMsg);

    // Update conversation thread last message
    final threadIndex = _threads.indexWhere((t) => t.businessId == businessId);
    if (threadIndex != -1) {
      _threads[threadIndex] = ConversationThread(
        id: _threads[threadIndex].id,
        businessId: _threads[threadIndex].businessId,
        businessName: _threads[threadIndex].businessName,
        businessLogo: _threads[threadIndex].businessLogo,
        isBusinessVerified: _threads[threadIndex].isBusinessVerified,
        lastMessage: text,
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
        relatedJobTitle: _threads[threadIndex].relatedJobTitle,
        isOnline: _threads[threadIndex].isOnline,
      );
    }

    return newMsg;
  }

  // Reviews & Ratings
  @override
  Future<List<BusinessReview>> getMyReviews() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _reviews;
  }

  // Notifications
  @override
  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _notifications;
  }

  @override
  Future<bool> markNotificationAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> markAllNotificationsAsRead() async {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    return true;
  }

  // Support
  @override
  Future<List<SupportTicket>> getSupportTickets() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _tickets;
  }

  @override
  Future<SupportTicket> createSupportTicket(SupportTicket ticket) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _tickets.insert(0, ticket);
    return ticket;
  }
}
