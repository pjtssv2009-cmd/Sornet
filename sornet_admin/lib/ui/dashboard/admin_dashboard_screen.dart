import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/sornet_providers.dart';
import '../../data/models/activity_log.dart';
import '../common/metric_card.dart';
import '../common/shimmer_loading.dart';
import '../technicians/technicians_list_screen.dart';
import '../technicians/technician_detail_screen.dart';
import '../businesses/businesses_list_screen.dart';
import '../jobs/jobs_list_screen.dart';
import '../applications/applications_list_screen.dart';
import '../verification/verification_center_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, child) {
        if (dashboard.isLoading && dashboard.stats == null) {
          return const ListShimmerLoading(itemCount: 6);
        }

        final stats = dashboard.stats;
        if (stats == null) {
          return const Center(child: Text('Unable to load dashboard data.'));
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => dashboard.loadDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting & Date Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x20155EEF),
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning, Admin 👋',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SORNET Marketplace Platform Overview',
                              style: GoogleFonts.inter(
                                color: const Color(0xFFD1E9FF),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          AppFormatters.formatDate(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section Header & Time Filters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overview',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    _buildTimeFilterMenu(context, dashboard),
                  ],
                ),
                const SizedBox(height: 14),

                // 8 Primary Stat Cards in a Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    MetricCard(
                      title: 'Total Technicians',
                      count: stats.totalTechnicians,
                      icon: Icons.engineering_rounded,
                      iconColor: AppColors.primary,
                      iconBgColor: AppColors.primaryLight,
                      trendText: '+${stats.techGrowthPercentage}%',
                      isPositiveTrend: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TechniciansListScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Verified Techs',
                      count: stats.verifiedTechnicians,
                      icon: Icons.verified_rounded,
                      iconColor: AppColors.success,
                      iconBgColor: AppColors.successBg,
                      subtitle: 'Active & Approved',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const TechniciansListScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Pending Verification',
                      count: stats.pendingTechVerifications,
                      icon: Icons.pending_actions_rounded,
                      iconColor: AppColors.warning,
                      iconBgColor: AppColors.warningBg,
                      subtitle: 'Action Needed',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const VerificationCenterScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Total Businesses',
                      count: stats.totalBusinesses,
                      icon: Icons.business_rounded,
                      iconColor: AppColors.purple,
                      iconBgColor: AppColors.purpleBg,
                      trendText: '+${stats.businessGrowthPercentage}%',
                      isPositiveTrend: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const BusinessesListScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Verified Businesses',
                      count: stats.verifiedBusinesses,
                      icon: Icons.verified_user_rounded,
                      iconColor: const Color(0xFF0D9488),
                      iconBgColor: const Color(0xFFCCFBF1),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const BusinessesListScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Active Jobs',
                      count: stats.activeJobs,
                      icon: Icons.work_rounded,
                      iconColor: AppColors.info,
                      iconBgColor: AppColors.infoBg,
                      trendText: '+${stats.jobsGrowthPercentage}%',
                      isPositiveTrend: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const JobsListScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Pending Jobs',
                      count: stats.pendingJobs,
                      icon: Icons.assignment_late_rounded,
                      iconColor: const Color(0xFFF97316),
                      iconBgColor: const Color(0xFFFFEDD5),
                      subtitle: 'Review required',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const JobsListScreen()),
                      ),
                    ),
                    MetricCard(
                      title: 'Total Applications',
                      count: stats.totalApplications,
                      icon: Icons.send_rounded,
                      iconColor: const Color(0xFFE11D48),
                      iconBgColor: const Color(0xFFFFE4E6),
                      trendText: '+${stats.appsGrowthPercentage}%',
                      isPositiveTrend: true,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ApplicationsListScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Analytics Charts Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Marketplace Analytics',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dashboard.selectedTimeRange,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // User Growth Chart
                _buildUserGrowthCard(),
                const SizedBox(height: 16),

                // Jobs & Applications Bar Chart
                _buildJobsApplicationsCard(),
                const SizedBox(height: 24),

                // Recent Live Activity Stream
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Activity',
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'Real-time',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRecentActivityList(context, dashboard.recentActivities),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeFilterMenu(BuildContext context, DashboardProvider dashboard) {
    final ranges = ['Today', '7 Days', '30 Days', '90 Days'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dashboard.selectedTimeRange,
          isDense: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 20),
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          items: ranges.map((r) {
            return DropdownMenuItem(value: r, child: Text(r));
          }).toList(),
          onChanged: (val) {
            if (val != null) dashboard.setTimeRange(val);
          },
        ),
      ),
    );
  }

  Widget _buildUserGrowthCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                'Registration Growth',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegend(AppColors.primary, 'Technicians'),
                  const SizedBox(width: 12),
                  _buildLegend(AppColors.secondary, 'Businesses'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: AppColors.borderLight,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (val, meta) {
                        if (val == 0 || val == 20 || val == 40 || val == 60) {
                          return Text(
                            '${val.toInt()}k',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (val.toInt() >= 0 && val.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[val.toInt()],
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 18),
                      FlSpot(1, 24),
                      FlSpot(2, 30),
                      FlSpot(3, 35),
                      FlSpot(4, 42),
                      FlSpot(5, 50),
                      FlSpot(6, 58),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.12),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 8),
                      FlSpot(1, 10),
                      FlSpot(2, 14),
                      FlSpot(3, 16),
                      FlSpot(4, 20),
                      FlSpot(5, 23),
                      FlSpot(6, 28),
                    ],
                    isCurved: true,
                    color: AppColors.secondary,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsApplicationsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Text(
                'Jobs & Applications',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLegend(const Color(0xFF0284C7), 'Jobs'),
                  const SizedBox(width: 12),
                  _buildLegend(const Color(0xFFE11D48), 'Applications'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (val) => FlLine(
                    color: AppColors.borderLight,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) {
                        if (val % 20 == 0) {
                          return Text(
                            val.toInt().toString(),
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = ['W1', 'W2', 'W3', 'W4'];
                        if (val.toInt() >= 0 && val.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              days[val.toInt()],
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 35, color: const Color(0xFF0284C7), width: 14, borderRadius: BorderRadius.circular(4)),
                    BarChartRodData(toY: 72, color: const Color(0xFFE11D48), width: 14, borderRadius: BorderRadius.circular(4)),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 48, color: const Color(0xFF0284C7), width: 14, borderRadius: BorderRadius.circular(4)),
                    BarChartRodData(toY: 88, color: const Color(0xFFE11D48), width: 14, borderRadius: BorderRadius.circular(4)),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 42, color: const Color(0xFF0284C7), width: 14, borderRadius: BorderRadius.circular(4)),
                    BarChartRodData(toY: 65, color: const Color(0xFFE11D48), width: 14, borderRadius: BorderRadius.circular(4)),
                  ]),
                  BarChartGroupData(x: 3, barRods: [
                    BarChartRodData(toY: 55, color: const Color(0xFF0284C7), width: 14, borderRadius: BorderRadius.circular(4)),
                    BarChartRodData(toY: 94, color: const Color(0xFFE11D48), width: 14, borderRadius: BorderRadius.circular(4)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityList(BuildContext context, List<ActivityLog> activities) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final act = activities[index];
          final (icon, color, bg) = _getActivityMeta(act.type);

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            title: Text(
              act.title,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              act.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Text(
              AppFormatters.formatRelativeTime(act.timestamp),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              if (act.entityType == 'technician' && act.entityId != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TechnicianDetailScreen(technicianId: act.entityId!),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  (IconData, Color, Color) _getActivityMeta(ActivityType type) {
    switch (type) {
      case ActivityType.newTechnician:
        return (Icons.person_add_rounded, AppColors.primary, AppColors.primaryLight);
      case ActivityType.technicianVerified:
        return (Icons.verified_rounded, AppColors.success, AppColors.successBg);
      case ActivityType.businessVerificationSubmitted:
        return (Icons.business_rounded, AppColors.warning, AppColors.warningBg);
      case ActivityType.businessVerified:
        return (Icons.verified_user_rounded, const Color(0xFF0D9488), const Color(0xFFCCFBF1));
      case ActivityType.newJobPosted:
        return (Icons.work_rounded, AppColors.info, AppColors.infoBg);
      case ActivityType.applicationReceived:
        return (Icons.send_rounded, const Color(0xFFE11D48), const Color(0xFFFFE4E6));
      case ActivityType.hiredTechnician:
        return (Icons.handshake_rounded, AppColors.success, AppColors.successBg);
      case ActivityType.systemUpdate:
        return (Icons.info_outline_rounded, AppColors.textSecondary, AppColors.surfaceSecondary);
    }
  }
}
