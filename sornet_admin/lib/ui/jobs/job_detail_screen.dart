import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/confirm_dialog.dart';
import '../applications/applications_list_screen.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobId;

  const JobDetailScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsProvider>(
      builder: (context, provider, child) {
        final job = provider.jobs.cast<Job?>().firstWhere(
              (j) => j?.id == jobId,
              orElse: () => null,
            );

        if (job == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Job Details')),
            body: const Center(child: Text('Job posting not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Job Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditDialog(context, job, provider),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) => _handleMenuAction(context, val, job, provider),
                itemBuilder: (context) => [
                  if (job.status == JobStatus.draft)
                    const PopupMenuItem(value: 'approve', child: Text('Approve & Publish')),
                  if (job.status == JobStatus.open)
                    const PopupMenuItem(value: 'close', child: Text('Close Job')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete Job', style: TextStyle(color: AppColors.error))),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              job.title,
                              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                          ),
                          StatusBadge.fromJobStatus(job.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.businessName,
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF99F6E4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Offered Compensation',
                              style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w500, color: const Color(0xFF0F766E)),
                            ),
                            Text(
                              job.salary,
                              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: const Color(0xFF0F766E)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Job Details Card
                _buildSectionCard(
                  title: 'Job Requirements & Overview',
                  icon: Icons.info_outline_rounded,
                  children: [
                    _buildRow('Category', job.category),
                    const Divider(height: 14),
                    _buildRow('Location', job.location),
                    const Divider(height: 14),
                    _buildRow('Experience Required', job.experienceRequired),
                    const Divider(height: 14),
                    _buildRow('Employment Type', job.employmentType),
                    const Divider(height: 14),
                    _buildRow('Technicians Required', '${job.positionsCount} Openings'),
                    const Divider(height: 14),
                    _buildRow('Expected Joining Date', AppFormatters.formatDate(job.joiningDate)),
                    const Divider(height: 14),
                    _buildRow('Posted Date', AppFormatters.formatDate(job.createdDate)),
                  ],
                ),
                const SizedBox(height: 16),

                // AC Expertise & Brands Card
                _buildSectionCard(
                  title: 'AC Expertise & Technical Scope',
                  icon: Icons.ac_unit_rounded,
                  children: [
                    _buildRow('Inverter / Non-Inverter', job.inverterType),
                    const SizedBox(height: 12),
                    Text('Required AC Types:', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: job.acExpertise.map((ac) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(ac, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text('Brands Supported:', style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: job.brands.map((b) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(b, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description Card
                _buildSectionCard(
                  title: 'Job Description',
                  icon: Icons.description_outlined,
                  children: [
                    Text(
                      job.description,
                      style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textPrimary, height: 1.5),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Applications Counter Card
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ApplicationsListScreen(jobIdFilter: job.id)),
                  ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFB2CCFF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 22),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${job.applicantsCount} Candidate Applications',
                                  style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                                ),
                                Text(
                                  'Tap to view and manage candidate pipeline',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Admin Action Buttons
                _buildAdminActionButtons(context, job, provider),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminActionButtons(BuildContext context, Job job, JobsProvider provider) {
    return Row(
      children: [
        if (job.status == JobStatus.draft) ...[
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Approve & Publish'),
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context,
                  title: 'Publish Job',
                  message: 'Approve and publish this job to marketplace?',
                  confirmText: 'Approve',
                );
                if (confirm == true) {
                  await provider.approveJob(job.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job approved and published!'), backgroundColor: AppColors.success),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
        if (job.status == JobStatus.open) ...[
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.warning,
                side: const BorderSide(color: AppColors.warningBorder),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.lock_clock_rounded, size: 18),
              label: const Text('Close Job'),
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context,
                  title: 'Close Job Posting',
                  message: 'Are you sure you want to close this job? Candidates will no longer be able to apply.',
                  confirmText: 'Close Job',
                );
                if (confirm == true) {
                  await provider.closeJob(job.id);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
        IconButton.filled(
          style: IconButton.styleFrom(backgroundColor: AppColors.errorBg, foregroundColor: AppColors.error),
          icon: const Icon(Icons.delete_outline_rounded),
          onPressed: () async {
            final confirm = await ConfirmDialog.show(
              context,
              title: 'Delete Job',
              message: 'Are you sure you want to permanently delete this job posting?',
              confirmText: 'Delete',
              isDangerous: true,
            );
            if (confirm == true) {
              await provider.deleteJob(job.id);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Job posting deleted.'), backgroundColor: AppColors.error),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action, Job job, JobsProvider provider) async {
    if (action == 'approve') {
      await provider.approveJob(job.id);
    } else if (action == 'close') {
      await provider.closeJob(job.id);
    } else if (action == 'delete') {
      final confirm = await ConfirmDialog.show(
        context,
        title: 'Delete Job Posting',
        message: 'Permanently remove this job from database?',
        confirmText: 'Delete',
        isDangerous: true,
      );
      if (confirm == true) {
        await provider.deleteJob(job.id);
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }

  void _showEditDialog(BuildContext context, Job job, JobsProvider provider) {
    final titleCtrl = TextEditingController(text: job.title);
    final salaryCtrl = TextEditingController(text: job.salary);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Job Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Job Title')),
            const SizedBox(height: 12),
            TextField(controller: salaryCtrl, decoration: const InputDecoration(labelText: 'Salary/Compensation')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = job.copyWith(
                title: titleCtrl.text.trim(),
                salary: salaryCtrl.text.trim(),
              );
              provider.saveJob(updated);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Job updated!')));
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
