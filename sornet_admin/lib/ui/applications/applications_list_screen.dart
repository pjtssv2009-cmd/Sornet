import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/application.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/shimmer_loading.dart';
import '../technicians/technician_detail_screen.dart';

class ApplicationsListScreen extends StatefulWidget {
  final String? jobIdFilter;
  final bool showAppBar;
  const ApplicationsListScreen({super.key, this.jobIdFilter, this.showAppBar = true});

  @override
  State<ApplicationsListScreen> createState() => _ApplicationsListScreenState();
}

class _ApplicationsListScreenState extends State<ApplicationsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ApplicationsProvider>(context, listen: false);
      if (widget.jobIdFilter != null) {
        provider.setJobIdFilter(widget.jobIdFilter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: const Text('Applications Pipeline'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => provider.loadApplications(),
                    ),
                  ],
                )
              : null,
          body: Column(
            children: [
              // Status Filters Carousel
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: AppColors.surface,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All (${provider.applications.length})',
                        isSelected: provider.statusFilter == null,
                        onTap: () => provider.setStatusFilter(null),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Applied',
                        isSelected: provider.statusFilter == ApplicationStatus.applied,
                        onTap: () => provider.setStatusFilter(ApplicationStatus.applied),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Shortlisted',
                        isSelected: provider.statusFilter == ApplicationStatus.shortlisted,
                        selectedColor: AppColors.primaryLight,
                        selectedTextColor: AppColors.primary,
                        onTap: () => provider.setStatusFilter(ApplicationStatus.shortlisted),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Interview',
                        isSelected: provider.statusFilter == ApplicationStatus.interview,
                        selectedColor: AppColors.purpleBg,
                        selectedTextColor: AppColors.purple,
                        onTap: () => provider.setStatusFilter(ApplicationStatus.interview),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Selected',
                        isSelected: provider.statusFilter == ApplicationStatus.selected,
                        selectedColor: AppColors.successBg,
                        selectedTextColor: AppColors.success,
                        onTap: () => provider.setStatusFilter(ApplicationStatus.selected),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Rejected',
                        isSelected: provider.statusFilter == ApplicationStatus.rejected,
                        selectedColor: AppColors.errorBg,
                        selectedTextColor: AppColors.error,
                        onTap: () => provider.setStatusFilter(ApplicationStatus.rejected),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),

              // Applications List
              Expanded(
                child: provider.isLoading && provider.applications.isEmpty
                    ? const ListShimmerLoading(itemCount: 5)
                    : provider.applications.isEmpty
                        ? EmptyState(
                            icon: Icons.assignment_outlined,
                            title: 'No Applications Found',
                            description: 'No candidates in this pipeline stage.',
                            actionText: 'View All',
                            onAction: () {
                              provider.setStatusFilter(null);
                              provider.setJobIdFilter(null);
                            },
                          )
                        : RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () => provider.loadApplications(),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.applications.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final app = provider.applications[index];
                                return _buildApplicationCard(context, app, provider);
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

  Widget _buildApplicationCard(BuildContext context, Application app, ApplicationsProvider provider) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  app.technicianName.isNotEmpty ? app.technicianName[0] : 'T',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            app.technicianName,
                            style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                        StatusBadge.fromApplicationStatus(app.status, isSmall: true),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${app.technicianSkill} • ${app.technicianExperience} Yrs Exp • ${app.technicianLocation}',
                      style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                        const SizedBox(width: 3),
                        Text(
                          '${app.technicianRating} Rating',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          // Applied Job
          Row(
            children: [
              const Icon(Icons.work_outline_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.jobTitle,
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(
                      '${app.businessName} • Applied: ${AppFormatters.formatDate(app.appliedDate)}',
                      style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (app.coverNote.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '"${app.coverNote}"',
                style: GoogleFonts.inter(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
              ),
            ),
          ],
          const Divider(height: 20),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exp: ${app.expectedSalary}',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF0F766E)),
              ),
              Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TechnicianDetailScreen(technicianId: app.technicianId),
                      ),
                    ),
                    child: const Text('View Tech Profile', style: TextStyle(fontSize: 11.5)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    onPressed: () => _showStatusChangeSheet(context, app, provider),
                    child: const Text('Change Stage', style: TextStyle(fontSize: 11.5)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showStatusChangeSheet(BuildContext context, Application app, ApplicationsProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Pipeline Stage',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...ApplicationStatus.values.map((status) {
              final isSel = app.status == status;
              return ListTile(
                title: Text(status.label, style: GoogleFonts.inter(fontWeight: isSel ? FontWeight.w700 : FontWeight.w500)),
                trailing: StatusBadge.fromApplicationStatus(status, isSmall: true),
                onTap: () async {
                  await provider.updateStatus(app.id, status);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
