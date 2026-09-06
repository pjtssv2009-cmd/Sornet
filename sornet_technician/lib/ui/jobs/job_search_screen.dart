import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/job_provider.dart';
import '../common/sornet_search_bar.dart';
import '../common/empty_state.dart';
import '../common/filter_bottom_sheet.dart';
import 'job_detail_screen.dart';
import 'apply_job_sheet.dart';
import 'saved_jobs_screen.dart';
import 'job_alerts_screen.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(JobProvider provider) {
    FilterBottomSheet.show(
      context,
      currentCity: provider.selectedCity,
      currentAcType: provider.selectedAcType,
      currentBrand: provider.selectedBrand,
      currentService: provider.selectedService,
      currentEmploymentType: provider.selectedEmploymentType,
      currentMinSalary: provider.minSalary,
      onApply: ({
        required city,
        required acType,
        required brand,
        required service,
        required employmentType,
        required minSalary,
      }) {
        provider.setFilters(
          city: city,
          acType: acType,
          brand: brand,
          service: service,
          employmentType: employmentType,
          minSalary: minSalary,
        );
      },
    );
  }

  void _openSortSheet(JobProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort Jobs By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _buildSortOption(ctx, provider, 'Recommended', 'recommended'),
            _buildSortOption(ctx, provider, 'Newest First', 'newest'),
            _buildSortOption(ctx, provider, 'Salary: High to Low', 'salary_high'),
            _buildSortOption(ctx, provider, 'Nearest Distance', 'distance'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext ctx, JobProvider provider, String title, String value) {
    final isSelected = provider.sortBy == value;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary) : null,
      onTap: () {
        provider.setSortBy(value);
        Navigator.of(ctx).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Find Technician Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            tooltip: 'Saved Jobs',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SavedJobsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notification_add_outlined),
            tooltip: 'Job Alerts',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const JobAlertsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                children: [
                  SornetSearchBar(
                    controller: _searchController,
                    onChanged: (val) => jobProvider.setSearchQuery(val),
                    onFilterTap: () => _openFilterSheet(jobProvider),
                    activeFilterCount: jobProvider.activeFiltersCount,
                  ),
                  const SizedBox(height: 10),

                  // Filter Chips & Sort Button Bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Sort Button
                        InkWell(
                          onTap: () => _openSortSheet(jobProvider),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.swap_vert_rounded, size: 16, color: AppTheme.primary),
                                SizedBox(width: 4),
                                Text('Sort', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // City Chip
                        _buildQuickFilterChip(
                          label: jobProvider.selectedCity,
                          isActive: jobProvider.selectedCity != 'All Cities',
                          onTap: () => _openFilterSheet(jobProvider),
                        ),
                        const SizedBox(width: 8),

                        // AC Type Chip
                        if (jobProvider.selectedAcType != null) ...[
                          _buildQuickFilterChip(
                            label: jobProvider.selectedAcType!,
                            isActive: true,
                            onTap: () => _openFilterSheet(jobProvider),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Brand Chip
                        if (jobProvider.selectedBrand != null) ...[
                          _buildQuickFilterChip(
                            label: jobProvider.selectedBrand!,
                            isActive: true,
                            onTap: () => _openFilterSheet(jobProvider),
                          ),
                          const SizedBox(width: 8),
                        ],

                        // Clear All Filters
                        if (jobProvider.activeFiltersCount > 0)
                          InkWell(
                            onTap: () {
                              _searchController.clear();
                              jobProvider.clearFilters();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                'Clear',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.error),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Results Counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${jobProvider.jobs.length} jobs available',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
                  ),
                  Text(
                    'Sorted by: ${jobProvider.sortBy.replaceAll('_', ' ').toUpperCase()}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textTertiary),
                  ),
                ],
              ),
            ),

            // Job List
            Expanded(
              child: jobProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : jobProvider.jobs.isEmpty
                      ? EmptyState(
                          icon: Icons.search_off_rounded,
                          title: 'No Jobs Matching Your Filter',
                          description: 'Try adjusting your city, AC specialization, or salary filters to view more opportunities.',
                          actionText: 'Reset Filters',
                          onAction: () {
                            _searchController.clear();
                            jobProvider.clearFilters();
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemCount: jobProvider.jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobProvider.jobs[index];
                            return _buildJobCard(context, job, jobProvider);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryLight : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isActive ? AppTheme.primary : AppTheme.border),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: isActive ? AppTheme.primary : AppTheme.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, Job job, JobProvider jobProvider) {
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
                radius: 22,
                backgroundColor: AppTheme.primaryLight,
                child: const Icon(Icons.business_rounded, color: AppTheme.primary, size: 22),
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
                    const SizedBox(height: 2),
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
          const SizedBox(height: 12),

          // Location, Experience, Salary Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildTag(Icons.location_on_outlined, '${job.city} (${job.distanceKm} km)'),
              _buildTag(Icons.work_history_outlined, job.experienceRequired),
              _buildTag(Icons.currency_rupee_rounded, Formatters.formatSalaryRange(job.minSalary, job.maxSalary)),
              _buildTag(Icons.people_outline_rounded, '${job.positionsCount} Positions'),
            ],
          ),
          const SizedBox(height: 12),

          // Skills & AC Matrix Tags
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...job.acTypes.map((t) => _buildChip(t, AppTheme.primaryLight, AppTheme.primary)),
              ...job.brands.take(3).map((b) => _buildChip(b, AppTheme.surfaceSubtle, AppTheme.textSecondary)),
            ],
          ),
          const SizedBox(height: 14),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posted ${Formatters.timeAgo(job.postedDate)}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(90, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Details', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: job.hasApplied
                        ? null
                        : () => ApplyJobSheet.show(context, job),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(job.hasApplied ? 'Applied ✓' : 'Apply Now', style: const TextStyle(fontSize: 12)),
                  ),
                ],
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
          Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)),
        ],
      ),
    );
  }

  Widget _buildChip(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textCol)),
    );
  }
}
