import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/technician_profile_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/application_provider.dart';
import '../../providers/interview_provider.dart';
import '../../providers/offer_provider.dart';
import '../../providers/work_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/messaging_provider.dart';
import '../common/metric_card.dart';
import '../common/status_badge.dart';
import '../common/trust_score_widget.dart';
import '../common/profile_strength_card.dart';
import '../jobs/job_search_screen.dart';
import '../jobs/job_detail_screen.dart';
import '../applications/my_applications_screen.dart';
import '../interviews/my_interviews_screen.dart';
import '../interviews/interview_detail_screen.dart';
import '../offers/my_offers_screen.dart';
import '../work/my_work_screen.dart';
import '../messaging/chats_list_screen.dart';
import '../notifications/notifications_screen.dart';
import '../verification/verification_center_screen.dart';
import '../profile/technician_profile_screen.dart';
import '../profile/public_profile_preview_screen.dart';

class TechnicianDashboardScreen extends StatelessWidget {
  const TechnicianDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<TechnicianProfileProvider>();
    final jobProvider = context.watch<JobProvider>();
    final appProvider = context.watch<ApplicationProvider>();
    final interviewProvider = context.watch<InterviewProvider>();
    final offerProvider = context.watch<OfferProvider>();
    final workProvider = context.watch<WorkProvider>();
    final notifProvider = context.watch<NotificationProvider>();
    final messagingProvider = context.watch<MessagingProvider>();

    final tech = profileProvider.technician;
    final techName = tech?.fullName ?? 'Arun Kumar';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TechnicianProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  techName.isNotEmpty ? techName[0] : 'A',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppTheme.primary, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi, ${techName.split(' ').first}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified_rounded, size: 15, color: AppTheme.success),
                  ],
                ),
                Text(
                  tech?.primaryTrade ?? 'AC Technician',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: messagingProvider.totalUnreadMessages > 0,
              label: Text('${messagingProvider.totalUnreadMessages}'),
              backgroundColor: AppTheme.primary,
              child: const Icon(Icons.chat_bubble_outline_rounded, size: 22),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatsListScreen()),
              );
            },
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: notifProvider.unreadCount > 0,
              label: Text('${notifProvider.unreadCount}'),
              backgroundColor: AppTheme.error,
              child: const Icon(Icons.notifications_none_rounded, size: 24),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await profileProvider.loadProfile();
            await jobProvider.loadJobs();
            await appProvider.loadApplications();
            await interviewProvider.loadInterviews();
            await offerProvider.loadOffers();
            await workProvider.loadWorkRecords();
            await notifProvider.loadNotifications();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trust Score Banner
                TrustScoreWidget(
                  score: profileProvider.trustScore,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VerificationCenterScreen()),
                    );
                  },
                ),
                const SizedBox(height: 14),

                // Profile Strength Card
                ProfileStrengthCard(
                  percentage: profileProvider.profileStrength,
                  onCompleteTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const TechnicianProfileScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Primary CTA: Find Jobs Card Banner
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppTheme.heroGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: AppTheme.primaryButtonShadow,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🔥 20+ NEW VACANCIES TODAY',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Find High-Paying AC & HVAC Jobs',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Verified employers hiring in Chennai, Bengaluru & Coimbatore.',
                              style: TextStyle(fontSize: 11, color: Colors.white70),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const JobSearchScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primary,
                                minimumSize: const Size(130, 38),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Explore Jobs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.work_rounded, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // KPI Overview Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Application Statistics',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyApplicationsScreen()),
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.95,
                  children: [
                    MetricCard(
                      title: 'Applications',
                      value: '${appProvider.totalApplicationsCount}',
                      icon: Icons.assignment_outlined,
                      iconColor: AppTheme.primary,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyApplicationsScreen(initialTab: 0)),
                        );
                      },
                    ),
                    MetricCard(
                      title: 'Shortlisted',
                      value: '${appProvider.shortlistedCount}',
                      icon: Icons.star_outline_rounded,
                      iconColor: AppTheme.warning,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyApplicationsScreen(initialTab: 2)),
                        );
                      },
                    ),
                    MetricCard(
                      title: 'Interviews',
                      value: '${interviewProvider.upcomingInterviews.length}',
                      icon: Icons.calendar_today_rounded,
                      iconColor: AppTheme.info,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyInterviewsScreen()),
                        );
                      },
                    ),
                    MetricCard(
                      title: 'Job Offers',
                      value: '${offerProvider.pendingOffers.length}',
                      icon: Icons.card_giftcard_rounded,
                      iconColor: AppTheme.success,
                      subtitle: 'Action needed',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyOffersScreen()),
                        );
                      },
                    ),
                    MetricCard(
                      title: 'Hired Work',
                      value: '${workProvider.totalHiredCount}',
                      icon: Icons.engineering_rounded,
                      iconColor: AppTheme.purple,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MyWorkScreen()),
                        );
                      },
                    ),
                    MetricCard(
                      title: 'My Rating',
                      value: '${tech?.rating ?? 4.9}★',
                      icon: Icons.star_rounded,
                      iconColor: const Color(0xFFF79009),
                      subtitle: '${tech?.reviewCount ?? 28} reviews',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PublicProfilePreviewScreen()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Upcoming Interview Card (if any)
                if (interviewProvider.upcomingInterviews.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upcoming Interview',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MyInterviewsScreen()),
                          );
                        },
                        child: const Text(
                          'All Interviews',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildUpcomingInterviewCard(context, interviewProvider.upcomingInterviews.first),
                  const SizedBox(height: 24),
                ],

                // Quick Action Buttons
                const Text(
                  'Quick Navigation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildQuickActionBtn(
                      context,
                      'Find Jobs',
                      Icons.search_rounded,
                      AppTheme.primary,
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const JobSearchScreen())),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionBtn(
                      context,
                      'My Offers',
                      Icons.card_giftcard_rounded,
                      AppTheme.success,
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyOffersScreen())),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionBtn(
                      context,
                      'Verification',
                      Icons.verified_user_rounded,
                      AppTheme.info,
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VerificationCenterScreen())),
                    ),
                    const SizedBox(width: 8),
                    _buildQuickActionBtn(
                      context,
                      'Preview',
                      Icons.visibility_rounded,
                      AppTheme.purple,
                      () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PublicProfilePreviewScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 26),

                // Recommended Jobs Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended Jobs For You',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const JobSearchScreen()),
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...jobProvider.jobs.take(3).map((job) {
                  return _buildJobCard(context, job, jobProvider);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingInterviewCard(BuildContext context, dynamic interview) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.warningBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.video_call_rounded, color: AppTheme.warningText, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interview.jobTitle,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    Text(
                      interview.businessName,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              StatusBadge.interview(interview.status),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    Formatters.formatDateTime(interview.scheduledAt),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => InterviewDetailScreen(interview: interview)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Join / Details', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionBtn(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job, JobProvider jobProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryLight,
                child: const Icon(Icons.business_rounded, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    Row(
                      children: [
                        Text(
                          job.businessName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                        ),
                        if (job.isBusinessVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 13, color: AppTheme.success),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  job.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: job.isSaved ? AppTheme.primary : AppTheme.textTertiary,
                  size: 22,
                ),
                onPressed: () => jobProvider.toggleSaveJob(job.id),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Location, Experience, Salary Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag(Icons.location_on_outlined, '${job.city} (${job.distanceKm} km)'),
              _buildTag(Icons.work_history_outlined, job.experienceRequired),
              _buildTag(Icons.currency_rupee_rounded, Formatters.formatSalaryRange(job.minSalary, job.maxSalary)),
            ],
          ),
          const SizedBox(height: 12),

          // Skill Chips
          Wrap(
            spacing: 4,
            children: (job.skillsRequired as List<String>).take(3).map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatters.timeAgo(job.postedDate),
                style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(110, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('View Job', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}
