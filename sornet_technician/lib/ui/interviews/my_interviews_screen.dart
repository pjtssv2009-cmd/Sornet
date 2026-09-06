import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/interview.dart';
import '../../providers/interview_provider.dart';
import '../common/empty_state.dart';
import '../common/status_badge.dart';
import 'interview_detail_screen.dart';

class MyInterviewsScreen extends StatefulWidget {
  const MyInterviewsScreen({super.key});

  @override
  State<MyInterviewsScreen> createState() => _MyInterviewsScreenState();
}

class _MyInterviewsScreenState extends State<MyInterviewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<InterviewProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('My Interviews'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Upcoming (${interviewProvider.upcomingInterviews.length})'),
            Tab(text: 'Completed (${interviewProvider.completedInterviews.length})'),
            Tab(text: 'Cancelled (${interviewProvider.cancelledInterviews.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InterviewList(
            interviews: interviewProvider.upcomingInterviews,
            emptyTitle: 'No upcoming interviews',
            emptySubtitle: 'When employers schedule interviews with you, they will appear here.',
            emptyIcon: Icons.video_camera_front_outlined,
          ),
          _InterviewList(
            interviews: interviewProvider.completedInterviews,
            emptyTitle: 'No completed interviews',
            emptySubtitle: 'Your past interview history will be listed here.',
            emptyIcon: Icons.event_available_outlined,
          ),
          _InterviewList(
            interviews: interviewProvider.cancelledInterviews,
            emptyTitle: 'No cancelled interviews',
            emptySubtitle: 'Any cancelled interviews will appear here.',
            emptyIcon: Icons.event_busy_outlined,
          ),
        ],
      ),
    );
  }
}

class _InterviewList extends StatelessWidget {
  final List<Interview> interviews;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;

  const _InterviewList({
    required this.interviews,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (interviews.isEmpty) {
      return Center(
        child: EmptyState(
          icon: emptyIcon,
          title: emptyTitle,
          subtitle: emptySubtitle,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: interviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final interview = interviews[index];
        return _InterviewCard(interview: interview);
      },
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final Interview interview;

  const _InterviewCard({required this.interview});

  @override
  Widget build(BuildContext context) {
    final isUpcoming = interview.status == InterviewStatus.scheduled ||
        interview.status == InterviewStatus.rescheduled;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InterviewDetailScreen(interviewId: interview.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      interview.type == InterviewType.video
                          ? Icons.videocam_rounded
                          : interview.type == InterviewType.phone
                              ? Icons.phone_in_talk_rounded
                              : Icons.business_rounded,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          interview.jobTitle,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          interview.businessName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: interview.status.label,
                    color: Color(interview.status.badgeColorValue),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.formatDateTime(interview.scheduledAt),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          interview.type == InterviewType.video
                              ? Icons.laptop_mac_rounded
                              : interview.type == InterviewType.phone
                                  ? Icons.phone_android_rounded
                                  : Icons.location_on_rounded,
                          size: 13,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          interview.type.label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isUpcoming) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (interview.meetingLink != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InterviewDetailScreen(
                                    interviewId: interview.id),
                              ),
                            );
                          },
                          icon: const Icon(Icons.play_circle_outline, size: 16),
                          label: const Text('Join Interview'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            textStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    if (interview.meetingLink != null) const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InterviewDetailScreen(
                                  interviewId: interview.id),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
