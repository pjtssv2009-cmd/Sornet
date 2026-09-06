import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/offer.dart';
import '../../providers/offer_provider.dart';
import '../common/confirm_dialog.dart';
import '../common/status_badge.dart';
import '../messaging/chat_conversation_screen.dart';

class OfferDetailScreen extends StatefulWidget {
  final String offerId;

  const OfferDetailScreen({super.key, required this.offerId});

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  final TextEditingController _rejectReasonController =
      TextEditingController();

  @override
  void dispose() {
    _rejectReasonController.dispose();
    super.dispose();
  }

  void _handleAcceptOffer(JobOffer offer) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Accept Job Offer?',
        message:
            'You are accepting the offer for ${offer.jobTitle} at ${offer.businessName} with a salary of ${Formatters.formatSalary(offer.offeredSalary, offer.salaryPeriod)}. Your onboarding will commence on ${Formatters.formatDate(offer.joiningDate)}.',
        confirmText: 'Yes, Accept Offer',
        cancelText: 'Cancel',
        confirmColor: AppTheme.accentGreen,
        onConfirm: () {
          Provider.of<OfferProvider>(context, listen: false)
              .acceptOffer(offer.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Congratulations! You accepted the offer.'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        },
      ),
    );
  }

  void _handleRejectOffer(JobOffer offer) {
    _rejectReasonController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Decline Job Offer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to decline this job offer? The business will be informed.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _rejectReasonController,
              decoration: const InputDecoration(
                hintText: 'Reason for declining (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<OfferProvider>(context, listen: false).rejectOffer(
                offer.id,
                _rejectReasonController.text.trim().isEmpty
                    ? 'Declined by technician'
                    : _rejectReasonController.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You have declined this offer.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Decline Offer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final offerProvider = Provider.of<OfferProvider>(context);
    final offer = offerProvider.getOfferById(widget.offerId);

    if (offer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Offer Details')),
        body: const Center(child: Text('Offer not found')),
      );
    }

    final isPending = offer.status == OfferStatus.pending;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Offer Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: 'Message Employer',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatConversationScreen(
                    businessId: offer.businessId,
                    businessName: offer.businessName,
                    jobTitle: offer.jobTitle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: AppTheme.accentGreen,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer.jobTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                offer.businessName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          text: offer.status.label,
                          color: Color(offer.status.badgeColorValue),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.currency_rupee_rounded,
                              color: AppTheme.primaryBlue, size: 28),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Compensation Offered',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                              Text(
                                Formatters.formatSalary(
                                    offer.offeredSalary, offer.salaryPeriod),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Key terms
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Employment Terms',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      Icons.calendar_today_rounded,
                      'Joining Date',
                      Formatters.formatDate(offer.joiningDate),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.work_history_outlined,
                      'Job Type',
                      offer.jobType,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.location_on_outlined,
                      'Work Location',
                      offer.location,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.schedule_rounded,
                      'Working Hours',
                      offer.workingHours,
                    ),
                    if (offer.probationPeriod != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.hourglass_top_rounded,
                        'Probation Period',
                        offer.probationPeriod!,
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      Icons.alarm_outlined,
                      'Offer Valid Till',
                      Formatters.formatDate(offer.validUntil),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Benefits & Perks
            if (offer.benefits.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Benefits & Allowances',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...offer.benefits.map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: AppTheme.accentGreen, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (offer.specialInstructions != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Employer Note',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        offer.specialInstructions!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (isPending) ...[
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _handleAcceptOffer(offer),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Accept Offer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _handleRejectOffer(offer),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentRed,
                        side: const BorderSide(color: AppTheme.accentRed),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
