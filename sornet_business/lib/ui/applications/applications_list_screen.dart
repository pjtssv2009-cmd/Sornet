import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/application.dart';
import '../../providers/application_provider.dart';
import '../../providers/job_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/sornet_search_bar.dart';
import '../common/confirm_dialog.dart';
import '../discovery/technician_detail_screen.dart';
import '../interviews/schedule_interview_screen.dart';
import '../offers/create_offer_screen.dart';
import 'shortlist_screen.dart';

class ApplicationsListScreen extends StatefulWidget {
  final int initialTab;
  final String? filterJobTitle;

  const ApplicationsListScreen({
    super.key,
    this.initialTab = 0,
    this.filterJobTitle,
  });

  @override
  State<ApplicationsListScreen> createState() => _ApplicationsListScreenState();
}

class _ApplicationsListScreenState extends State<ApplicationsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: widget.initialTab);
    if (widget.filterJobTitle != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ApplicationProvider>().setJobFilter(widget.filterJobTitle);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<ApplicationProvider>();
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Applications Pipeline'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ShortlistScreen()),
              );
            },
            icon: const Icon(Icons.star_rounded, color: AppTheme.purple, size: 18),
            label: const Text('Shortlist', style: TextStyle(color: AppTheme.purple, fontWeight: FontWeight.w700)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: 'All (${appProvider.allApplications.length})'),
            Tab(text: 'New (${appProvider.newApplications.length})'),
            Tab(text: 'Shortlisted (${appProvider.shortlistedApplications.length})'),
            Tab(text: 'Interview (${appProvider.interviewApplications.length})'),
            Tab(text: 'Selected (${appProvider.selectedApplications.length})'),
            Tab(text: 'Rejected (${appProvider.rejectedApplications.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter by Job & Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                SornetSearchBar(
                  controller: _searchController,
                  hintText: 'Search candidate name, skill...',
                  onChanged: appProvider.setSearchQuery,
                  onClear: () => appProvider.setSearchQuery(''),
                ),
                if (jobProvider.activeJobs.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: appProvider.selectedJobFilter ?? 'All Jobs',
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                        items: ['All Jobs', ...jobProvider.activeJobs.map((j) => j.title)].map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(
                              t,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          appProvider.setJobFilter(val == 'All Jobs' ? null : val);
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Pipeline Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildApplicationList(context, appProvider.allApplications, appProvider),
                _buildApplicationList(context, appProvider.newApplications, appProvider),
                _buildApplicationList(context, appProvider.shortlistedApplications, appProvider),
                _buildApplicationList(context, appProvider.interviewApplications, appProvider),
                _buildApplicationList(context, appProvider.selectedApplications, appProvider),
                _buildApplicationList(context, appProvider.rejectedApplications, appProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationList(BuildContext context, List<Application> list, ApplicationProvider provider) {
    if (list.isEmpty) {
      return const EmptyState(
        icon: Icons.assignment_outlined,
        title: 'No Applications in this Stage',
        message: 'Candidates moving through this hiring stage will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final app = list[index];
        return _buildApplicationCard(context, app, provider);
      },
    );
  }

  Widget _buildApplicationCard(BuildContext context, Application app, ApplicationProvider provider) {
    final tech = app.technician;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: tech)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Candidate + Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        tech.name.isNotEmpty ? tech.name[0] : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  tech.name,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (tech.isVerified)
                                const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 15),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${tech.experienceYears} yrs exp • ${tech.city}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                              const SizedBox(width: 2),
                              Text('${tech.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.successBg,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${app.matchPercentage}% Match',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.successText),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StatusBadge.application(app.status),
                  ],
                ),
                const SizedBox(height: 10),

                // Applied Job Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.work_outline_rounded, size: 13, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          app.jobTitle,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        Formatters.timeAgo(app.appliedDate),
                        style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Cover Note if present
                if (app.coverNote != null && app.coverNote!.isNotEmpty) ...[
                  Text(
                    '"${app.coverNote}"',
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                ],

                // Action Bar
                const Divider(height: 1, color: AppTheme.borderLight),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // View Profile
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: tech)),
                        );
                      },
                      child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 6),

                    // Dynamic Actions according to status
                    if (app.status == ApplicationStatus.newApplication) ...[
                      OutlinedButton(
                        onPressed: () async {
                          final confirmed = await ConfirmDialog.show(
                            context,
                            title: 'Reject Application?',
                            message: 'Are you sure you want to mark ${tech.name} as rejected?',
                            confirmText: 'Reject',
                            confirmColor: AppTheme.error,
                          );
                          if (confirmed == true) {
                            provider.rejectApplication(app.id);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.error,
                          side: const BorderSide(color: AppTheme.errorBg, width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Reject'),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton(
                        onPressed: () {
                          provider.shortlistApplication(app.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                        child: const Text('Shortlist'),
                      ),
                    ] else if (app.status == ApplicationStatus.shortlisted) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          final jobs = context.read<JobProvider>().activeJobs;
                          final matchingJob = jobs.firstWhere((j) => j.id == app.jobId, orElse: () => jobs.first);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ScheduleInterviewScreen(technician: tech, job: matchingJob),
                            ),
                          );
                        },
                        icon: const Icon(Icons.event_available_rounded, size: 14),
                        label: const Text('Schedule Interview'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ] else if (app.status == ApplicationStatus.interviewScheduled) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          final jobs = context.read<JobProvider>().activeJobs;
                          final matchingJob = jobs.firstWhere((j) => j.id == app.jobId, orElse: () => jobs.first);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CreateOfferScreen(technician: tech, job: matchingJob),
                            ),
                          );
                        },
                        icon: const Icon(Icons.send_rounded, size: 14),
                        label: const Text('Send Offer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.success,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
