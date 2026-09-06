import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/job.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/sornet_search_bar.dart';
import '../common/empty_state.dart';
import '../common/shimmer_loading.dart';
import '../common/confirm_dialog.dart';
import 'job_detail_screen.dart';

class JobsListScreen extends StatefulWidget {
  final bool showAppBar;
  const JobsListScreen({super.key, this.showAppBar = true});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: const Text('Job Management'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => provider.loadJobs(),
                    ),
                  ],
                )
              : null,
          body: Column(
            children: [
              // Search & Status Tabs
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                color: AppColors.surface,
                child: Column(
                  children: [
                    SornetSearchBar(
                      hintText: 'Search job title, company, location, category...',
                      controller: _searchController,
                      onChanged: (val) => provider.setSearchQuery(val),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'All (${provider.jobs.length})',
                            isSelected: provider.statusFilter == null,
                            onTap: () => provider.setStatusFilter(null),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Open (${provider.openCount})',
                            isSelected: provider.statusFilter == JobStatus.open,
                            selectedColor: AppColors.successBg,
                            selectedTextColor: AppColors.success,
                            onTap: () => provider.setStatusFilter(JobStatus.open),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Interviewing (${provider.interviewCount})',
                            isSelected: provider.statusFilter == JobStatus.interview,
                            selectedColor: AppColors.purpleBg,
                            selectedTextColor: AppColors.purple,
                            onTap: () => provider.setStatusFilter(JobStatus.interview),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Filled (${provider.filledCount})',
                            isSelected: provider.statusFilter == JobStatus.filled,
                            selectedColor: const Color(0xFFCCFBF1),
                            selectedTextColor: const Color(0xFF0D9488),
                            onTap: () => provider.setStatusFilter(JobStatus.filled),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Closed (${provider.closedCount})',
                            isSelected: provider.statusFilter == JobStatus.closed,
                            selectedColor: AppColors.surfaceSecondary,
                            selectedTextColor: AppColors.textSecondary,
                            onTap: () => provider.setStatusFilter(JobStatus.closed),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Draft (${provider.draftCount})',
                            isSelected: provider.statusFilter == JobStatus.draft,
                            selectedColor: AppColors.warningBg,
                            selectedTextColor: AppColors.warning,
                            onTap: () => provider.setStatusFilter(JobStatus.draft),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Jobs List
              Expanded(
                child: provider.isLoading && provider.jobs.isEmpty
                    ? const ListShimmerLoading(itemCount: 5)
                    : provider.jobs.isEmpty
                        ? EmptyState(
                            icon: Icons.work_outline_rounded,
                            title: 'No Jobs Found',
                            description: 'No job postings match your active search and status filter.',
                            actionText: 'Reset Search',
                            onAction: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                              provider.setStatusFilter(null);
                            },
                          )
                        : RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () => provider.loadJobs(),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.jobs.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final job = provider.jobs[index];
                                return _buildJobCard(context, job, provider);
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
    Color? selectedTextColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (selectedColor ?? AppColors.primaryLight) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? (selectedTextColor ?? AppColors.primary) : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? (selectedTextColor ?? AppColors.primary) : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Job job, JobsProvider provider) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => JobDetailScreen(jobId: job.id),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.businessName,
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromJobStatus(job.status, isSmall: true),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(job.location, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                const Icon(Icons.work_history_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(job.experienceRequired, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(width: 12),
                const Icon(Icons.badge_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(job.employmentType, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              job.salary,
              style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: const Color(0xFF0F766E)),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.group_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${job.applicantsCount} Applicants • ${job.positionsCount} Openings',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (job.status == JobStatus.draft) ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () async {
                          final confirm = await ConfirmDialog.show(
                            context,
                            title: 'Approve Job Posting',
                            message: 'Approve and publish "${job.title}" to technicians marketplace?',
                            confirmText: 'Approve Job',
                          );
                          if (confirm == true) {
                            await provider.approveJob(job.id);
                          }
                        },
                        child: const Text('Approve', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => JobDetailScreen(jobId: job.id)),
                      ),
                      child: const Text('View', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
