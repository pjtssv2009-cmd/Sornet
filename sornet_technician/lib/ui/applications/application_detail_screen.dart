import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/application.dart';
import '../../providers/application_provider.dart';
import '../common/status_badge.dart';
import '../common/timeline_view.dart';
import '../common/confirm_dialog.dart';
import '../messaging/chat_conversation_screen.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final Application? application;
  final String? applicationId;

  const ApplicationDetailScreen({
    super.key,
    this.application,
    this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<ApplicationProvider>();
    final targetId = application?.id ?? applicationId;
    final currentApp = appProvider.applications.firstWhere(
      (a) => a.id == targetId,
      orElse: () =>
          application ??
          Application(
            id: targetId ?? 'app_unknown',
            jobId: 'job_1',
            jobTitle: 'HVAC Technician',
            businessId: 'biz_1',
            businessName: 'Voltas Services',
            businessLogo: '',
            isBusinessVerified: true,
            location: 'Chennai, Tamil Nadu',
            city: 'Chennai',
            minSalary: 25000,
            maxSalary: 35000,
            salaryPeriod: 'month',
            technicianType: 'Full Time',
            appliedDate: DateTime.now(),
            status: ApplicationStatus.applied,
            expectedSalary: 30000,
            availability: 'Immediate',
            timeline: [],
          ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Application Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatConversationScreen(
                    businessId: currentApp.businessId,
                    businessName: currentApp.businessName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employer Card Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: AppTheme.primaryLight,
                          child: Icon(Icons.business_rounded,
                              color: AppTheme.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentApp.jobTitle,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary),
                              ),
                              Row(
                                children: [
                                  Text(
                                    currentApp.businessName,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.textSecondary,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  if (currentApp.isBusinessVerified) ...[
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified_rounded,
                                        size: 14, color: AppTheme.success),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Application Status:',
                            style: TextStyle(
                                fontSize: 12, color: AppTheme.textTertiary)),
                        StatusBadge.application(currentApp.status),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Visual Application Timeline
              const Text(
                'Application Progress Timeline',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: ApplicationTimelineView(steps: currentApp.timeline),
              ),
              const SizedBox(height: 20),

              // Submitted Details
              const Text(
                'Your Submission Details',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Expected Salary',
                        '${Formatters.formatCurrency(currentApp.expectedSalary)}/month'),
                    const Divider(height: 16),
                    _buildDetailRow(
                        'Joining Availability', currentApp.availability),
                    const Divider(height: 16),
                    _buildDetailRow('Applied On',
                        Formatters.formatFullDate(currentApp.appliedDate)),
                    const Divider(height: 16),
                    _buildDetailRow('Application ID', currentApp.id),
                    if (currentApp.coverNote != null) ...[
                      const Divider(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cover Note Submitted:',
                              style: TextStyle(
                                  fontSize: 12, color: AppTheme.textTertiary)),
                          const SizedBox(height: 4),
                          Text(
                            currentApp.coverNote!,
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Withdraw Option
              if (currentApp.status != ApplicationStatus.withdrawn &&
                  currentApp.status != ApplicationStatus.rejected &&
                  currentApp.status != ApplicationStatus.hired)
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await ConfirmDialog.show(
                        context,
                        title: 'Withdraw Application?',
                        message:
                            'Are you sure you want to withdraw this application? This action cannot be undone.',
                        confirmText: 'Withdraw',
                        isDestructive: true,
                      );
                      if (confirm == true) {
                        await appProvider.withdrawApplication(currentApp.id);
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    icon: const Icon(Icons.undo_rounded,
                        size: 16, color: AppTheme.error),
                    label: const Text('Withdraw Application',
                        style: TextStyle(color: AppTheme.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.error),
                      minimumSize: const Size(200, 44),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: AppTheme.textTertiary)),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary)),
      ],
    );
  }
}
