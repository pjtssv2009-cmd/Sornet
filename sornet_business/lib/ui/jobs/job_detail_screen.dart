import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../data/models/application.dart';
import '../../providers/job_provider.dart';
import '../../providers/application_provider.dart';
import '../common/status_badge.dart';
import '../common/confirm_dialog.dart';
import '../applications/applications_list_screen.dart';
import '../discovery/technician_detail_screen.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<ApplicationProvider>();
    final jobApps = appProvider.applications.where((a) => a.jobId == job.id).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Job Requirement Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job posting link copied to clipboard.')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(18),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            job.category,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        StatusBadge.job(job.status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${job.location}, ${job.city}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Posted on ${Formatters.formatDate(job.postedDate)}',
                      style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4 Stat Metric Badges for this Job
              Row(
                children: [
                  Expanded(
                    child: _buildJobStatBox(
                      'Applicants',
                      '${jobApps.isNotEmpty ? jobApps.length : job.applicantsCount}',
                      AppTheme.primary,
                      AppTheme.primaryLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildJobStatBox(
                      'Shortlisted',
                      '${jobApps.where((a) => a.status == ApplicationStatus.shortlisted).length}',
                      AppTheme.purple,
                      AppTheme.purpleBg,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildJobStatBox(
                      'Interviews',
                      '${jobApps.where((a) => a.status == ApplicationStatus.interviewScheduled).length}',
                      AppTheme.warning,
                      AppTheme.warningBg,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildJobStatBox(
                      'Hired',
                      '${jobApps.where((a) => a.status == ApplicationStatus.selected).length}',
                      AppTheme.success,
                      AppTheme.successBg,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Job Specifications
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Job Specifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _buildSpecRow('Salary', Formatters.formatSalaryRange(job.minSalary, job.maxSalary, period: job.salaryPeriod)),
                    _buildSpecRow('Employment Type', job.technicianType),
                    _buildSpecRow('Positions Open', '${job.positionsCount} Vacancies'),
                    _buildSpecRow('Experience Required', job.experienceRequired),
                    _buildSpecRow('Joining Date', Formatters.formatDate(job.joiningDate)),
                    _buildSpecRow('Working Hours', job.workingHours),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // AC Systems & Brands
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Required AC Specialization', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.skillsRequired
                          .map((s) => Chip(
                                label: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                                backgroundColor: AppTheme.primaryLight,
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Text('Brands: ${job.brands.join(', ')}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Text('Services: ${job.requiredServices.join(', ')}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Description & Benefits
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Job Description', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(job.description, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
                    if (job.benefits.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      const Text('Perks & Benefits', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ...job.benefits.map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, size: 14, color: AppTheme.success),
                                const SizedBox(width: 6),
                                Text(b, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                              ],
                            ),
                          )),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Candidate Applications Pipeline Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Candidates Applied (${jobApps.length})',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ApplicationsListScreen(filterJobTitle: job.title),
                        ),
                      );
                    },
                    child: const Text('View All in Pipeline', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (jobApps.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Center(
                    child: Text('No applications received for this job yet.', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  ),
                )
              else
                Column(
                  children: jobApps.take(4).map((app) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border),
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
                              radius: 18,
                              backgroundColor: AppTheme.primaryLight,
                              child: Text(app.technician.name[0], style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(app.technician.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                  Text('${app.technician.experienceYears} yrs exp • ${app.technician.city}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                ],
                              ),
                            ),
                            StatusBadge.application(app.status),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ApplicationsListScreen(filterJobTitle: job.title),
                    ),
                  );
                },
                child: const Text('View All Applicants'),
              ),
            ),
            const SizedBox(width: 12),
            if (job.status == JobStatus.active)
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.show(
                      context,
                      title: 'Close Job Requirement?',
                      message: 'This will stop new applications for "${job.title}".',
                      confirmText: 'Close Job',
                      confirmColor: AppTheme.error,
                    );
                    if (confirmed == true && context.mounted) {
                      context.read<JobProvider>().closeJob(job.id);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                  child: const Text('Close Job'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobStatBox(String label, String value, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}
