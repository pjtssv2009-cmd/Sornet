import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/messaging_provider.dart';
import '../common/metric_card.dart';
import '../common/status_badge.dart';
import '../jobs/post_job_screen.dart';
import '../jobs/my_jobs_screen.dart';
import '../discovery/technician_search_screen.dart';
import '../discovery/technician_detail_screen.dart';
import '../applications/applications_list_screen.dart';
import '../interviews/interviews_list_screen.dart';
import '../offers/offers_list_screen.dart';
import '../hiring/my_technicians_screen.dart';
import '../notifications/notifications_screen.dart';
import '../messaging/chats_list_screen.dart';
import '../profile/business_verification_screen.dart';
import '../settings/business_settings_screen.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final notifProvider = context.watch<NotificationProvider>();
    final messagingProvider = context.watch<MessagingProvider>();
    final business = auth.currentBusiness;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: AppTheme.accentGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.handshake_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'SORNET',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        actions: [
          // Messages Action
          IconButton(
            icon: Badge(
              isLabelVisible: messagingProvider.totalUnreadMessages > 0,
              label: Text('${messagingProvider.totalUnreadMessages}'),
              child: const Icon(Icons.chat_bubble_outline_rounded),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatsListScreen()),
              );
            },
          ),
          // Notifications Action
          IconButton(
            icon: Badge(
              isLabelVisible: notifProvider.unreadCount > 0,
              label: Text('${notifProvider.unreadCount}'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          // Profile Avatar Action
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BusinessSettingsScreen()),
                );
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  business != null && business.businessName.isNotEmpty
                      ? business.businessName[0]
                      : 'B',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await dashboard.loadDashboardData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner & Business Card
              _buildWelcomeCard(context, business),
              const SizedBox(height: 18),

              // Verification Status Bar (if not fully approved)
              if (business != null && !business.verification.isFullyVerified) ...[
                _buildVerificationBanner(context, business),
                const SizedBox(height: 18),
              ],

              // Quick Action Buttons
              _buildQuickActions(context),
              const SizedBox(height: 22),

              // Business Overview Header & Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Business Overview',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Live Marketplace Stats',
                    style: TextStyle(fontSize: 12, color: AppTheme.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 6 Grid Metric Cards
              _buildMetricsGrid(context, dashboard),
              const SizedBox(height: 24),

              // Upcoming Interviews Section
              _buildUpcomingInterviewsSection(context, dashboard),
              const SizedBox(height: 24),

              // Recent Applications Section
              _buildRecentApplicationsSection(context, dashboard),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, dynamic business) {
    final businessName = business?.businessName ?? 'CoolFlow Air Conditioning';
    final city = business?.city ?? 'Chennai';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppTheme.heroCardGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.activeShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.business_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Good Morning,',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, color: AppTheme.secondary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      business?.subscriptionTier ?? 'Professional',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            businessName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: Colors.white.withValues(alpha: 0.8)),
              const SizedBox(width: 4),
              Text(
                '$city Hub • Active Hiring',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationBanner(BuildContext context, dynamic business) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BusinessVerificationScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.warningBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_user_outlined, color: AppTheme.warningText, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Business Verification in Progress',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.warningText,
                    ),
                  ),
                  Text(
                    '${business.verification.verifiedCount}/6 Checks Completed • Tap to complete',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.warningText.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppTheme.warningText),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Prominent CTA
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PostJobScreen()),
              );
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
            label: const Text(
              '+ Post Technician Requirement',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 3 Secondary Quick Action Buttons
        Row(
          children: [
            Expanded(
              child: _buildSecondaryActionCard(
                icon: Icons.person_search_rounded,
                label: 'Find Techs',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TechnicianSearchScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSecondaryActionCard(
                icon: Icons.assignment_rounded,
                label: 'Applications',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ApplicationsListScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildSecondaryActionCard(
                icon: Icons.calendar_month_rounded,
                label: 'Interviews',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InterviewsListScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
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
              Icon(icon, color: AppTheme.primary, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, DashboardProvider dashboard) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        MetricCard(
          title: 'Active Jobs',
          value: '${dashboard.activeJobsCount}',
          icon: Icons.work_rounded,
          iconColor: AppTheme.primary,
          iconBgColor: AppTheme.primaryLight,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyJobsScreen()),
            );
          },
        ),
        MetricCard(
          title: 'Total Applications',
          value: '${dashboard.totalApplicationsCount}',
          icon: Icons.assignment_rounded,
          iconColor: const Color(0xFF0284C7),
          iconBgColor: AppTheme.infoBg,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ApplicationsListScreen()),
            );
          },
        ),
        MetricCard(
          title: 'Shortlisted Techs',
          value: '${dashboard.shortlistedCount}',
          icon: Icons.star_rounded,
          iconColor: AppTheme.purple,
          iconBgColor: AppTheme.purpleBg,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ApplicationsListScreen(initialTab: 2),
              ),
            );
          },
        ),
        MetricCard(
          title: 'Interviews Booked',
          value: '${dashboard.interviewsCount}',
          icon: Icons.event_available_rounded,
          iconColor: AppTheme.warning,
          iconBgColor: AppTheme.warningBg,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const InterviewsListScreen()),
            );
          },
        ),
        MetricCard(
          title: 'Offers Sent',
          value: '${dashboard.offersSentCount}',
          icon: Icons.send_rounded,
          iconColor: const Color(0xFF4338CA),
          iconBgColor: const Color(0xFFE0E7FF),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const OffersListScreen()),
            );
          },
        ),
        MetricCard(
          title: 'Technicians Hired',
          value: '${dashboard.techniciansHiredCount}',
          icon: Icons.handshake_rounded,
          iconColor: AppTheme.success,
          iconBgColor: AppTheme.successBg,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyTechniciansScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUpcomingInterviewsSection(BuildContext context, DashboardProvider dashboard) {
    final interviews = dashboard.upcomingInterviews;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Interviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InterviewsListScreen()),
                );
              },
              child: const Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (interviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Center(
              child: Text(
                'No interviews scheduled for today.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            ),
          )
        else
          Column(
            children: interviews.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        item.technicianName.isNotEmpty ? item.technicianName[0] : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.technicianName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.jobTitle,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 13, color: AppTheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                Formatters.formatDateTime(item.scheduledAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StatusBadge.interview(item.status),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildRecentApplicationsSection(BuildContext context, DashboardProvider dashboard) {
    final recent = dashboard.recentApplications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Applications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ApplicationsListScreen()),
                );
              },
              child: const Text('View Pipeline', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Column(
          children: recent.map((app) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.cardShadow,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TechnicianDetailScreen(technician: app.technician),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        app.technician.name.isNotEmpty ? app.technician.name[0] : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                app.technician.name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (app.technician.isVerified)
                                const Icon(Icons.verified_rounded, size: 14, color: AppTheme.primary),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${app.technician.experienceYears} yrs exp • ${app.technician.city}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Applied for: ${app.jobTitle}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textTertiary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusBadge.application(app.status),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.timeAgo(app.appliedDate),
                          style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
