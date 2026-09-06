import '../mock/mock_data.dart';
import '../models/business.dart';
import '../models/technician.dart';
import '../models/job.dart';
import '../models/application.dart';
import '../models/interview.dart';
import '../models/message.dart';
import '../models/offer.dart';
import '../models/hiring.dart';
import '../models/review.dart';
import '../models/notification_item.dart';

abstract class ISornetBusinessRepository {
  // Business
  Future<Business> getCurrentBusiness();
  Future<Business> updateBusinessProfile(Business business);
  Future<Business> uploadBusinessDocument(BusinessDocument document);

  // Technicians
  Future<List<Technician>> getTechnicians({
    String? query,
    String? city,
    double? minExperience,
    double? minRating,
    bool? verifiedOnly,
    List<String>? acTypes,
    List<String>? brands,
    List<String>? services,
    String? sortBy,
  });
  Future<Technician?> getTechnicianById(String id);
  Future<bool> toggleShortlistTechnician(String id);
  Future<List<Technician>> getShortlistedTechnicians();

  // Jobs
  Future<List<Job>> getJobs({JobStatus? status, String? query});
  Future<Job?> getJobById(String id);
  Future<Job> createJob(Job job);
  Future<Job> updateJob(Job job);
  Future<bool> closeJob(String id);

  // Applications
  Future<List<Application>> getApplications({String? jobId, ApplicationStatus? status});
  Future<Application?> getApplicationById(String id);
  Future<Application> updateApplicationStatus(String applicationId, ApplicationStatus newStatus, {String? reason});

  // Interviews
  Future<List<Interview>> getInterviews();
  Future<Interview> scheduleInterview(Interview interview);
  Future<Interview> updateInterviewStatus(String id, InterviewStatus status, {String? feedback});
  Future<Interview> rescheduleInterview(String id, DateTime newDateTime);

  // Messages
  Future<List<ConversationThread>> getConversations();
  Future<List<ChatMessage>> getMessages(String technicianId);
  Future<ChatMessage> sendMessage(ChatMessage message);

  // Offers
  Future<List<JobOffer>> getOffers({OfferStatus? status});
  Future<JobOffer> sendOffer(JobOffer offer);
  Future<bool> cancelOffer(String offerId);
  Future<HiredTechnician> acceptOfferAndHire(String offerId);

  // Hiring & Reviews
  Future<List<HiredTechnician>> getHiredTechnicians({HiringStatus? status});
  Future<TechnicianReview> submitReview(TechnicianReview review);
  Future<List<TechnicianReview>> getReviews({String? technicianId, String? businessId});

  // Notifications
  Future<List<NotificationItem>> getNotifications();
  Future<bool> markNotificationAsRead(String id);
  Future<bool> markAllNotificationsAsRead();
}

class SornetBusinessRepository implements ISornetBusinessRepository {
  // In-memory data store seeded from MockData
  Business _currentBusiness = MockData.currentBusiness;
  final List<Technician> _technicians = List.from(MockData.sampleTechnicians);
  final List<Job> _jobs = List.from(MockData.sampleJobs);
  final List<Application> _applications = List.from(MockData.sampleApplications);
  final List<Interview> _interviews = List.from(MockData.sampleInterviews);
  final List<ConversationThread> _conversations = List.from(MockData.sampleThreads);
  final Map<String, List<ChatMessage>> _messages = Map.from(MockData.sampleMessages);
  final List<JobOffer> _offers = List.from(MockData.sampleOffers);
  final List<HiredTechnician> _hiredTechnicians = List.from(MockData.sampleHiredTechnicians);
  final List<TechnicianReview> _reviews = List.from(MockData.sampleReviews);
  final List<NotificationItem> _notifications = List.from(MockData.sampleNotifications);

  // Business Methods
  @override
  Future<Business> getCurrentBusiness() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _currentBusiness;
  }

  @override
  Future<Business> updateBusinessProfile(Business business) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentBusiness = business;
    return _currentBusiness;
  }

  @override
  Future<Business> uploadBusinessDocument(BusinessDocument document) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final updatedDocs = List<BusinessDocument>.from(_currentBusiness.documents)..add(document);
    _currentBusiness = _currentBusiness.copyWith(documents: updatedDocs);
    return _currentBusiness;
  }

  // Technician Methods
  @override
  Future<List<Technician>> getTechnicians({
    String? query,
    String? city,
    double? minExperience,
    double? minRating,
    bool? verifiedOnly,
    List<String>? acTypes,
    List<String>? brands,
    List<String>? services,
    String? sortBy,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var results = List<Technician>.from(_technicians);

    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((t) {
        return t.name.toLowerCase().contains(q) ||
            t.city.toLowerCase().contains(q) ||
            t.location.toLowerCase().contains(q) ||
            t.acExpertise.any((ac) => ac.toLowerCase().contains(q)) ||
            t.brands.any((b) => b.toLowerCase().contains(q)) ||
            t.services.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    if (city != null && city.isNotEmpty && city != 'All Cities') {
      results = results.where((t) => t.city.toLowerCase() == city.toLowerCase()).toList();
    }

    if (minExperience != null && minExperience > 0) {
      results = results.where((t) => t.experienceYears >= minExperience).toList();
    }

    if (minRating != null && minRating > 0) {
      results = results.where((t) => t.rating >= minRating).toList();
    }

    if (verifiedOnly == true) {
      results = results.where((t) => t.isVerified).toList();
    }

    if (acTypes != null && acTypes.isNotEmpty) {
      results = results.where((t) => acTypes.any((type) => t.acExpertise.contains(type))).toList();
    }

    if (brands != null && brands.isNotEmpty) {
      results = results.where((t) => brands.any((b) => t.brands.contains(b))).toList();
    }

    if (services != null && services.isNotEmpty) {
      results = results.where((t) => services.any((s) => t.services.contains(s))).toList();
    }

    // Sorting
    if (sortBy == 'Experience') {
      results.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
    } else if (sortBy == 'Rating') {
      results.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (sortBy == 'Trust Score') {
      results.sort((a, b) => b.trustScore.compareTo(a.trustScore));
    } else if (sortBy == 'Salary (Low to High)') {
      results.sort((a, b) => a.expectedSalaryMonthly.compareTo(b.expectedSalaryMonthly));
    }

    return results;
  }

  @override
  Future<Technician?> getTechnicianById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _technicians.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> toggleShortlistTechnician(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _technicians.indexWhere((t) => t.id == id);
    if (index != -1) {
      final current = _technicians[index];
      final newStatus = !current.isShortlisted;
      _technicians[index] = current.copyWith(isShortlisted: newStatus);

      // Also update any matching applications
      for (int i = 0; i < _applications.length; i++) {
        if (_applications[i].technician.id == id) {
          if (newStatus && _applications[i].status == ApplicationStatus.newApplication) {
            _applications[i] = _applications[i].copyWith(
              status: ApplicationStatus.shortlisted,
              statusUpdatedAt: DateTime.now(),
            );
          }
        }
      }

      if (newStatus) {
        _notifications.insert(
          0,
          NotificationItem(
            id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
            title: 'Technician Shortlisted',
            message: '${current.name} was added to your shortlisted candidates list.',
            type: NotificationType.technicianShortlisted,
            timestamp: DateTime.now(),
            referenceId: current.id,
          ),
        );
      }
      return newStatus;
    }
    return false;
  }

  @override
  Future<List<Technician>> getShortlistedTechnicians() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _technicians.where((t) => t.isShortlisted).toList();
  }

  // Job Methods
  @override
  Future<List<Job>> getJobs({JobStatus? status, String? query}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var results = List<Job>.from(_jobs);
    if (status != null) {
      results = results.where((j) => j.status == status).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      results = results.where((j) => j.title.toLowerCase().contains(q) || j.location.toLowerCase().contains(q)).toList();
    }
    return results;
  }

  @override
  Future<Job?> getJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Job> createJob(Job job) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _jobs.insert(0, job);

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Job Published Successfully',
        message: 'Your requirement for "${job.title}" is now active and receiving technician applications.',
        type: NotificationType.generalAlert,
        timestamp: DateTime.now(),
        referenceId: job.id,
      ),
    );
    return job;
  }

  @override
  Future<Job> updateJob(Job job) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _jobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      _jobs[index] = job;
      return job;
    }
    return job;
  }

  @override
  Future<bool> closeJob(String id) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _jobs.indexWhere((j) => j.id == id);
    if (index != -1) {
      _jobs[index] = _jobs[index].copyWith(status: JobStatus.closed);
      return true;
    }
    return false;
  }

  // Application Methods
  @override
  Future<List<Application>> getApplications({String? jobId, ApplicationStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var results = List<Application>.from(_applications);
    if (jobId != null) {
      results = results.where((a) => a.jobId == jobId).toList();
    }
    if (status != null) {
      results = results.where((a) => a.status == status).toList();
    }
    return results;
  }

  @override
  Future<Application?> getApplicationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _applications.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Application> updateApplicationStatus(
    String applicationId,
    ApplicationStatus newStatus, {
    String? reason,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      final current = _applications[index];
      final updated = current.copyWith(
        status: newStatus,
        rejectionReason: reason ?? current.rejectionReason,
        statusUpdatedAt: DateTime.now(),
      );
      _applications[index] = updated;

      // Update technician shortlisted status if needed
      if (newStatus == ApplicationStatus.shortlisted) {
        final tIndex = _technicians.indexWhere((t) => t.id == updated.technician.id);
        if (tIndex != -1) {
          _technicians[tIndex] = _technicians[tIndex].copyWith(isShortlisted: true);
        }
      }

      // Update job statistics
      final jobIndex = _jobs.indexWhere((j) => j.id == updated.jobId);
      if (jobIndex != -1) {
        final job = _jobs[jobIndex];
        final appsForJob = _applications.where((a) => a.jobId == job.id);
        _jobs[jobIndex] = job.copyWith(
          shortlistedCount: appsForJob.where((a) => a.status == ApplicationStatus.shortlisted).length,
          interviewsCount: appsForJob.where((a) => a.status == ApplicationStatus.interviewScheduled).length,
          hiredCount: appsForJob.where((a) => a.status == ApplicationStatus.selected).length,
        );
      }

      return updated;
    }
    throw Exception('Application not found');
  }

  // Interview Methods
  @override
  Future<List<Interview>> getInterviews() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_interviews)..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  @override
  Future<Interview> scheduleInterview(Interview interview) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _interviews.insert(0, interview);

    // Update application state to interviewScheduled
    for (int i = 0; i < _applications.length; i++) {
      if (_applications[i].technician.id == interview.technicianId && _applications[i].jobId == interview.jobId) {
        _applications[i] = _applications[i].copyWith(
          status: ApplicationStatus.interviewScheduled,
          statusUpdatedAt: DateTime.now(),
        );
      }
    }

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Interview Scheduled',
        message: 'Interview booked with ${interview.technicianName} for ${interview.jobTitle}.',
        type: NotificationType.interviewReminder,
        timestamp: DateTime.now(),
        referenceId: interview.id,
      ),
    );

    return interview;
  }

  @override
  Future<Interview> updateInterviewStatus(String id, InterviewStatus status, {String? feedback}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _interviews.indexWhere((i) => i.id == id);
    if (index != -1) {
      final updated = _interviews[index].copyWith(status: status, feedback: feedback);
      _interviews[index] = updated;
      return updated;
    }
    throw Exception('Interview not found');
  }

  @override
  Future<Interview> rescheduleInterview(String id, DateTime newDateTime) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _interviews.indexWhere((i) => i.id == id);
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

  // Messaging Methods
  @override
  Future<List<ConversationThread>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_conversations)..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  @override
  Future<List<ChatMessage>> getMessages(String technicianId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _messages[technicianId] ?? [];
  }

  @override
  Future<ChatMessage> sendMessage(ChatMessage message) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final techId = message.receiverId;
    if (!_messages.containsKey(techId)) {
      _messages[techId] = [];
    }
    _messages[techId]!.add(message);

    // Update conversation thread
    final threadIndex = _conversations.indexWhere((t) => t.technicianId == techId);
    if (threadIndex != -1) {
      _conversations[threadIndex] = _conversations[threadIndex].copyWith(
        lastMessage: message.message,
        lastMessageTime: message.timestamp,
      );
    }

    return message;
  }

  // Offer Methods
  @override
  Future<List<JobOffer>> getOffers({OfferStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (status != null) {
      return _offers.where((o) => o.status == status).toList();
    }
    return List.from(_offers);
  }

  @override
  Future<JobOffer> sendOffer(JobOffer offer) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _offers.insert(0, offer);

    // Update matching application
    for (int i = 0; i < _applications.length; i++) {
      if (_applications[i].technician.id == offer.technicianId && _applications[i].jobId == offer.jobId) {
        _applications[i] = _applications[i].copyWith(
          status: ApplicationStatus.offerSent,
          statusUpdatedAt: DateTime.now(),
        );
      }
    }

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Offer Sent Successfully',
        message: 'Hiring offer sent to ${offer.technicianName} for ${offer.position}.',
        type: NotificationType.generalAlert,
        timestamp: DateTime.now(),
        referenceId: offer.id,
      ),
    );

    return offer;
  }

  @override
  Future<bool> cancelOffer(String offerId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _offers.indexWhere((o) => o.id == offerId);
    if (index != -1) {
      _offers[index] = _offers[index].copyWith(status: OfferStatus.cancelled);
      return true;
    }
    return false;
  }

  @override
  Future<HiredTechnician> acceptOfferAndHire(String offerId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final offerIndex = _offers.indexWhere((o) => o.id == offerId);
    if (offerIndex == -1) throw Exception('Offer not found');

    final offer = _offers[offerIndex];
    _offers[offerIndex] = offer.copyWith(
      status: OfferStatus.accepted,
      responseRemarks: 'Offer accepted by technician.',
      responseDate: DateTime.now(),
    );

    // Create HiredTechnician record
    final hired = HiredTechnician(
      id: 'hire-${DateTime.now().millisecondsSinceEpoch}',
      technicianId: offer.technicianId,
      technicianName: offer.technicianName,
      technicianPhoto: offer.technicianPhoto,
      technicianPhone: offer.technicianPhone,
      jobId: offer.jobId,
      jobTitle: offer.jobTitle,
      position: offer.position,
      salary: offer.salaryAmount,
      salaryPeriod: offer.salaryPeriod,
      employmentType: offer.employmentType,
      joiningDate: offer.joiningDate,
      status: HiringStatus.upcoming,
      location: offer.location,
    );
    _hiredTechnicians.insert(0, hired);

    // Update application status to selected
    for (int i = 0; i < _applications.length; i++) {
      if (_applications[i].technician.id == offer.technicianId && _applications[i].jobId == offer.jobId) {
        _applications[i] = _applications[i].copyWith(
          status: ApplicationStatus.selected,
          statusUpdatedAt: DateTime.now(),
        );
      }
    }

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Technician Hired! 🎉',
        message: '${offer.technicianName} accepted your offer for ${offer.position}.',
        type: NotificationType.offerAccepted,
        timestamp: DateTime.now(),
        referenceId: hired.id,
      ),
    );

    return hired;
  }

  // Hiring & Reviews
  @override
  Future<List<HiredTechnician>> getHiredTechnicians({HiringStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (status != null) {
      return _hiredTechnicians.where((h) => h.status == status).toList();
    }
    return List.from(_hiredTechnicians);
  }

  @override
  Future<TechnicianReview> submitReview(TechnicianReview review) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _reviews.insert(0, review);

    // Mark hired technician as reviewed
    final hiredIndex = _hiredTechnicians.indexWhere((h) => h.id == review.hiringId);
    if (hiredIndex != -1) {
      _hiredTechnicians[hiredIndex] = _hiredTechnicians[hiredIndex].copyWith(
        hasBeenReviewed: true,
        rating: review.overallRating,
      );
    }

    // Update technician rating
    final techIndex = _technicians.indexWhere((t) => t.id == review.technicianId);
    if (techIndex != -1) {
      final tech = _technicians[techIndex];
      final newCount = tech.reviewsCount + 1;
      final newRating = ((tech.rating * tech.reviewsCount) + review.overallRating) / newCount;
      _technicians[techIndex] = tech.copyWith(
        reviewsCount: newCount,
        rating: double.parse(newRating.toStringAsFixed(2)),
      );
    }

    _notifications.insert(
      0,
      NotificationItem(
        id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Review Submitted',
        message: 'Your rating and feedback for ${review.technicianName} was saved.',
        type: NotificationType.generalAlert,
        timestamp: DateTime.now(),
        referenceId: review.id,
      ),
    );

    return review;
  }

  @override
  Future<List<TechnicianReview>> getReviews({String? technicianId, String? businessId}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var results = List<TechnicianReview>.from(_reviews);
    if (technicianId != null) {
      results = results.where((r) => r.technicianId == technicianId).toList();
    }
    if (businessId != null) {
      results = results.where((r) => r.businessId == businessId).toList();
    }
    return results;
  }

  // Notifications
  @override
  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.from(_notifications);
  }

  @override
  Future<bool> markNotificationAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      return true;
    }
    return false;
  }

  @override
  Future<bool> markAllNotificationsAsRead() async {
    await Future.delayed(const Duration(milliseconds: 150));
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    return true;
  }
}
