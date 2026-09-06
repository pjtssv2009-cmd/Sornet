enum TicketCategory {
  jobApplication,
  verification,
  paymentAndOffer,
  employerDispute,
  technicalIssue,
  generalInquiry;

  String get label {
    switch (this) {
      case TicketCategory.jobApplication:
        return 'Job Application';
      case TicketCategory.verification:
        return 'Verification & KYC';
      case TicketCategory.paymentAndOffer:
        return 'Payment & Offers';
      case TicketCategory.employerDispute:
        return 'Employer Dispute';
      case TicketCategory.technicalIssue:
        return 'App & Technical';
      case TicketCategory.generalInquiry:
        return 'General Inquiry';
    }
  }
}

enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed;

  String get label {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  int get badgeColorValue {
    switch (this) {
      case TicketStatus.open:
        return 0xFFF79009;
      case TicketStatus.inProgress:
        return 0xFF0BA5EC;
      case TicketStatus.resolved:
        return 0xFF12B76A;
      case TicketStatus.closed:
        return 0xFF64748B;
    }
  }
}

class SupportTicket {
  final String id;
  final String technicianId;
  final TicketCategory category;
  final String subject;
  final String description;
  final String? attachmentUrl;
  final TicketStatus status;
  final String? adminResponse;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  SupportTicket({
    required this.id,
    required this.technicianId,
    required this.category,
    required this.subject,
    required this.description,
    this.attachmentUrl,
    this.status = TicketStatus.open,
    this.adminResponse,
    required this.createdAt,
    this.resolvedAt,
  });

  SupportTicket copyWith({
    String? id,
    String? technicianId,
    TicketCategory? category,
    String? subject,
    String? description,
    String? attachmentUrl,
    TicketStatus? status,
    String? adminResponse,
    DateTime? createdAt,
    DateTime? resolvedAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      technicianId: technicianId ?? this.technicianId,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      status: status ?? this.status,
      adminResponse: adminResponse ?? this.adminResponse,
      createdAt: createdAt ?? this.createdAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}
