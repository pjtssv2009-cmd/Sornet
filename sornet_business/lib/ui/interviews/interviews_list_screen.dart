import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/interview.dart';
import '../../providers/interview_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/technician_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/confirm_dialog.dart';
import '../offers/create_offer_screen.dart';

class InterviewsListScreen extends StatefulWidget {
  final int initialTab;

  const InterviewsListScreen({super.key, this.initialTab = 0});

  @override
  State<InterviewsListScreen> createState() => _InterviewsListScreenState();
}

class _InterviewsListScreenState extends State<InterviewsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interviewProvider = context.watch<InterviewProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Interviews'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Scheduled (${interviewProvider.scheduledInterviews.length})'),
            Tab(text: 'Completed (${interviewProvider.completedInterviews.length})'),
            Tab(text: 'Cancelled (${interviewProvider.cancelledInterviews.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(context, interviewProvider.scheduledInterviews, interviewProvider, InterviewStatus.scheduled),
          _buildList(context, interviewProvider.completedInterviews, interviewProvider, InterviewStatus.completed),
          _buildList(context, interviewProvider.cancelledInterviews, interviewProvider, InterviewStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Interview> list, InterviewProvider provider, InterviewStatus status) {
    if (list.isEmpty) {
      return EmptyState(
        icon: Icons.event_busy_rounded,
        title: status == InterviewStatus.scheduled
            ? 'No Upcoming Interviews'
            : status == InterviewStatus.completed
                ? 'No Completed Interviews'
                : 'No Cancelled Interviews',
        message: status == InterviewStatus.scheduled
            ? 'Shortlist candidate technicians and book interview slots from the application pipeline.'
            : 'Records will appear here once sessions are finalized.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final interview = list[index];
        return _buildInterviewCard(context, interview, provider);
      },
    );
  }

  Widget _buildInterviewCard(BuildContext context, Interview interview, InterviewProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    interview.technicianName.isNotEmpty ? interview.technicianName[0] : 'T',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        interview.technicianName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      Text(
                        interview.jobTitle,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StatusBadge.interview(interview.status),
              ],
            ),
            const SizedBox(height: 12),

            // Time & Mode Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        Formatters.formatDateTime(interview.scheduledAt),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                      ),
                      const Spacer(),
                      Text('${interview.durationMinutes} mins', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        interview.type == InterviewType.videoCall
                            ? Icons.videocam_rounded
                            : interview.type == InterviewType.phoneCall
                                ? Icons.phone_rounded
                                : Icons.location_on_rounded,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          interview.locationOrLink,
                          style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (interview.notes != null && interview.notes!.isNotEmpty) ...[
              Text(
                'Notes: ${interview.notes}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
            ],

            if (interview.feedback != null && interview.feedback!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Feedback: ${interview.feedback}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.successText, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Actions
            if (interview.status == InterviewStatus.scheduled || interview.status == InterviewStatus.rescheduled) ...[
              const Divider(height: 1, color: AppTheme.borderLight),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      final confirmed = await ConfirmDialog.show(
                        context,
                        title: 'Cancel Interview?',
                        message: 'Are you sure you want to cancel the scheduled interview with ${interview.technicianName}?',
                        confirmText: 'Cancel Interview',
                        confirmColor: AppTheme.error,
                      );
                      if (confirmed == true) {
                        provider.cancel(interview.id);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      provider.markCompleted(interview.id, feedback: 'Strong technical aptitude and verified credentials.');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Mark Completed'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      final techProvider = context.read<TechnicianProvider>();
                      final tech = techProvider.technicians.firstWhere(
                        (t) => t.id == interview.technicianId,
                        orElse: () => techProvider.technicians.first,
                      );
                      final jobs = context.read<JobProvider>().activeJobs;
                      final job = jobs.firstWhere(
                        (j) => j.id == interview.jobId,
                        orElse: () => jobs.first,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CreateOfferScreen(technician: tech, job: job)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                    child: const Text('Send Offer'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
