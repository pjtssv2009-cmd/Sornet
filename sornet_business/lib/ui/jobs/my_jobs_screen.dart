import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/job_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/sornet_search_bar.dart';
import '../common/confirm_dialog.dart';
import 'post_job_screen.dart';
import 'job_detail_screen.dart';
import '../applications/applications_list_screen.dart';

class MyJobsScreen extends StatefulWidget {
  final int initialTab;

  const MyJobsScreen({super.key, this.initialTab = 0});

  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Job Postings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppTheme.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PostJobScreen()),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active (${jobProvider.activeJobs.length})'),
            Tab(text: 'Drafts (${jobProvider.draftJobs.length})'),
            Tab(text: 'Closed (${jobProvider.closedJobs.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SornetSearchBar(
              controller: _searchController,
              hintText: 'Search posted jobs by title, city...',
              onChanged: jobProvider.setSearchQuery,
              onClear: () => jobProvider.setSearchQuery(''),
            ),
          ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJobsList(jobProvider.activeJobs, JobStatus.active),
                _buildJobsList(jobProvider.draftJobs, JobStatus.draft),
                _buildJobsList(jobProvider.closedJobs, JobStatus.closed),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PostJobScreen()),
          );
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Requirement', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildJobsList(List<Job> jobs, JobStatus status) {
    if (jobs.isEmpty) {
      return EmptyState(
        icon: Icons.work_outline_rounded,
        title: status == JobStatus.active
            ? 'No Active Job Requirements'
            : status == JobStatus.draft
                ? 'No Saved Drafts'
                : 'No Closed Jobs',
        message: status == JobStatus.active
            ? 'Post a new technician requirement to start receiving verified applications.'
            : 'Jobs in this category will appear here.',
        buttonText: status == JobStatus.active ? '+ Post Requirement' : null,
        onButtonPressed: status == JobStatus.active
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PostJobScreen()),
                );
              }
            : null,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return _buildJobCard(context, job);
      },
    );
  }

  Widget _buildJobCard(BuildContext context, Job job) {
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
              MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textTertiary),
                              const SizedBox(width: 4),
                              Text(
                                '${job.location}, ${job.city}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StatusBadge.job(job.status),
                  ],
                ),
                const SizedBox(height: 12),

                // Tags row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildMiniBadge(job.experienceRequired, AppTheme.surfaceMuted, AppTheme.textSecondary),
                    _buildMiniBadge(job.technicianType, AppTheme.primaryLight, AppTheme.primary),
                    _buildMiniBadge(
                      Formatters.formatSalaryRange(job.minSalary, job.maxSalary, period: job.salaryPeriod),
                      AppTheme.successBg,
                      AppTheme.successText,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                const Divider(height: 1, color: AppTheme.borderLight),
                const SizedBox(height: 12),

                // Stats & Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildStatPill(Icons.people_outline_rounded, '${job.applicantsCount} Applicants', AppTheme.primary),
                        const SizedBox(width: 10),
                        _buildStatPill(Icons.star_outline_rounded, '${job.shortlistedCount} Shortlisted', AppTheme.purple),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppTheme.textSecondary),
                      onSelected: (val) async {
                        if (val == 'view_applicants') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ApplicationsListScreen(filterJobTitle: job.title),
                            ),
                          );
                        } else if (val == 'close_job') {
                          final confirmed = await ConfirmDialog.show(
                            context,
                            title: 'Close Job Requirement?',
                            message: 'This will stop new candidates from applying to "${job.title}".',
                            confirmText: 'Close Job',
                            confirmColor: AppTheme.error,
                          );
                          if (confirmed == true && context.mounted) {
                            context.read<JobProvider>().closeJob(job.id);
                          }
                        }
                      },
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'view_applicants',
                          child: Row(
                            children: [
                              Icon(Icons.assignment_outlined, size: 18, color: AppTheme.primary),
                              SizedBox(width: 8),
                              Text('View Applicants'),
                            ],
                          ),
                        ),
                        if (job.status == JobStatus.active)
                          const PopupMenuItem(
                            value: 'close_job',
                            child: Row(
                              children: [
                                Icon(Icons.lock_outline_rounded, size: 18, color: AppTheme.error),
                                SizedBox(width: 8),
                                Text('Close Job'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textCol),
      ),
    );
  }

  Widget _buildStatPill(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
