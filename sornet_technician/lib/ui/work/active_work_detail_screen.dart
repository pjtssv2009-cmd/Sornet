import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/work.dart';
import '../../providers/work_provider.dart';
import '../common/confirm_dialog.dart';
import '../common/status_badge.dart';
import '../messaging/chat_conversation_screen.dart';
import 'rate_business_screen.dart';

class ActiveWorkDetailScreen extends StatelessWidget {
  final String recordId;

  const ActiveWorkDetailScreen({super.key, required this.recordId});

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkProvider>(context);
    final record = workProvider.getWorkRecordById(recordId);

    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Engagement Details')),
        body: const Center(child: Text('Work record not found')),
      );
    }

    final isActive = record.status == WorkStatus.active;
    final isCompleted = record.status == WorkStatus.completed;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Work Engagement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: 'Chat with Employer',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatConversationScreen(
                    businessId: record.businessId,
                    businessName: record.businessName,
                    jobTitle: record.jobTitle,
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
            // Header card
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
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.engineering_rounded,
                            color: AppTheme.primaryBlue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                record.jobTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                record.businessName,
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
                          text: record.status.label,
                          color: Color(record.status.badgeColorValue),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _buildInfoRow(
                      Icons.currency_rupee_rounded,
                      'Agreed Pay',
                      Formatters.formatSalary(
                          record.agreedSalary, record.salaryPeriod),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.calendar_today_rounded,
                      'Start Date',
                      Formatters.formatDate(record.startDate),
                    ),
                    if (record.endDate != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.event_available_rounded,
                        'End Date',
                        Formatters.formatDate(record.endDate!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Site & Supervisor info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Workplace & Supervision',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.location_on_outlined,
                      'Work Site',
                      record.workAddress,
                    ),
                    if (record.supervisorName != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.person_outline,
                        'Supervisor',
                        record.supervisorName!,
                      ),
                    ],
                    if (record.supervisorContact != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        'Contact',
                        record.supervisorContact!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Key deliverables
            if (record.tasksSummary.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assigned Scope & Deliverables',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...record.tasksSummary.map(
                        (task) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Icon(Icons.check_circle_outline_rounded,
                                    size: 16, color: AppTheme.primaryBlue),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  task,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textDark,
                                    height: 1.4,
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

            if (record.notes != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contract Notes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        record.notes!,
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

            if (isActive) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => ConfirmDialog(
                        title: 'Mark Engagement Completed?',
                        message:
                            'Are you sure your scope of work with ${record.businessName} is completed? This will update your profile and enable you to leave a business review.',
                        confirmText: 'Yes, Mark Complete',
                        cancelText: 'Cancel',
                        confirmColor: AppTheme.accentGreen,
                        onConfirm: () {
                          Provider.of<WorkProvider>(context, listen: false)
                              .completeWork(record.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Engagement marked as completed!'),
                              backgroundColor: AppTheme.accentGreen,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Mark Engagement Completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            if (isCompleted && !record.hasReviewedBusiness) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RateBusinessScreen(
                          recordId: record.id,
                          businessId: record.businessId,
                          businessName: record.businessName,
                          jobTitle: record.jobTitle,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.star_rounded),
                  label: const Text('Rate & Review Employer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 100,
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
