import 'package:flutter/material.dart';
import '../data/models/support_ticket.dart';
import '../data/repositories/sornet_technician_repository.dart';

class SupportFAQ {
  final String question;
  final String answer;

  const SupportFAQ({required this.question, required this.answer});
}

class SupportProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<SupportTicket> _tickets = [];
  bool _isLoading = false;

  final List<SupportFAQ> _faqs = [
    const SupportFAQ(
      question: 'How do I get my SORNET Technician profile verified?',
      answer:
          'Go to Profile > Verification Center. Complete your Phone and Email OTP verification, and upload your Government ID (Aadhaar or Driving License) and Trade certificates. Our verification officers approve valid documents within 2-4 business hours.',
    ),
    const SupportFAQ(
      question: 'How do I apply for commercial HVAC & technician jobs?',
      answer:
          'Browse available vacancies on the Jobs tab, filter by trade, location, or equipment category (VRV, Ductable, Chiller), and tap "Apply Now". You can propose your expected compensation and write a personalized cover note.',
    ),
    const SupportFAQ(
      question: 'How are technician salaries and payments settled?',
      answer:
          'SORNET ensures transparent salary agreements. Employers deposit payments directly to your verified bank account on agreed payroll dates (monthly or weekly contract milestone settlements).',
    ),
    const SupportFAQ(
      question: 'How does the Trust Score system work?',
      answer:
          'Your Trust Score (up to 100) is dynamically computed based on profile completeness, verified credentials, ITI/OEM trade certificates, background checks, and employer performance reviews.',
    ),
    const SupportFAQ(
      question: 'Can I reschedule an upcoming employer interview?',
      answer:
          'Yes. Open the interview details card under the Interviews tab, tap "Request Reschedule", and select your proposed date and time with a brief reason.',
    ),
  ];

  SupportProvider(this._repository) {
    loadTickets();
  }

  List<SupportTicket> get tickets => _tickets;
  List<SupportFAQ> get faqs => _faqs;
  bool get isLoading => _isLoading;

  Future<void> loadTickets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tickets = await _repository.getSupportTickets();
    } catch (e) {
      debugPrint('Error loading support tickets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTicket(SupportTicket ticket) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.createSupportTicket(ticket);
      await loadTickets();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SupportTicket> submitTicket({
    required String technicianId,
    required TicketCategory category,
    required String subject,
    required String description,
    String? attachmentUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTicket = SupportTicket(
        id: 'tkt-${DateTime.now().millisecondsSinceEpoch}',
        technicianId: technicianId,
        category: category,
        subject: subject,
        description: description,
        attachmentUrl: attachmentUrl,
        status: TicketStatus.open,
        createdAt: DateTime.now(),
      );

      final created = await _repository.createSupportTicket(newTicket);
      await loadTickets();
      return created;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
