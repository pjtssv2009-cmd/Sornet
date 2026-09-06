import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/job_provider.dart';
import '../../providers/application_provider.dart';
import '../messaging/chat_conversation_screen.dart';
import 'apply_job_sheet.dart';

class JobDetailScreen extends StatelessWidget {
  final Job job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final appProvider = context.watch<ApplicationProvider>();

    final isApplied = job.hasApplied || appProvider.applications.any((a) => a.jobId == job.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Job Details'),
        actions: [
          IconButton(
            icon: Icon(
              job.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: job.isSaved ? AppTheme.primary : AppTheme.textPrimary,
            ),
            onPressed: () => jobProvider.toggleSaveJob(job.id),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job link copied to clipboard.')),
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
              // Employer Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppTheme.primaryLight,
                      child: const Icon(Icons.business_rounded, color: AppTheme.primary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  job.businessName,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                ),
                              ),
                              if (job.isBusinessVerified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, size: 16, color: AppTheme.success),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF79009)),
                              const SizedBox(width: 2),
                              Text(
                                '${job.businessRating} Rating • Verified Employer',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_outlined, color: AppTheme.primary),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatConversationScreen(
                              businessId: job.businessId,
                              businessName: job.businessName,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Job Title & Salary Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppTheme.skyGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.primaryButtonShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.category.toUpperCase(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      job.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      Formatters.formatSalaryRange(job.minSalary, job.maxSalary),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${job.technicianType} • ${job.positionsCount} Positions Available',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Key Specifications Grid
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  children: [
                    _buildSpecRow(Icons.location_on_outlined, 'Location', '${job.location}, ${job.city} (${job.distanceKm} km away)'),
                    const Divider(height: 18),
                    _buildSpecRow(Icons.work_history_outlined, 'Experience Required', job.experienceRequired),
                    const Divider(height: 18),
                    _buildSpecRow(Icons.access_time_rounded, 'Working Hours', job.workingHours),
                    const Divider(height: 18),
                    _buildSpecRow(Icons.event_available_rounded, 'Joining Timeline', Formatters.formatDate(job.joiningDate)),
                    const Divider(height: 18),
                    _buildSpecRow(Icons.timer_outlined, 'Application Deadline', Formatters.formatDate(job.applicationDeadline)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // AC & Trade Expertise
              const Text('AC & Technical Specializations', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...job.acTypes.map((t) => _buildChip(t, AppTheme.primaryLight, AppTheme.primary)),
                  ...job.acTechnologies.map((tech) => _buildChip(tech, AppTheme.infoBg, AppTheme.infoText)),
                ],
              ),
              const SizedBox(height: 18),

              // Brands
              const Text('Required Brands Knowledge', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.brands.map((b) => _buildChip(b, AppTheme.surfaceSubtle, AppTheme.textPrimary)).toList(),
              ),
              const SizedBox(height: 18),

              // Required Services
              const Text('Services to be Performed', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.requiredServices.map((s) => _buildChip(s, AppTheme.purpleBg, AppTheme.purpleText)).toList(),
              ),
              const SizedBox(height: 20),

              // Job Description
              const Text('Role Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                job.description,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 18),

              // Requirements
              const Text('Candidate Requirements', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                job.requirements,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 18),

              // Benefits
              const Text('Perks & Company Benefits', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              ...job.benefits.map((benefit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          benefit,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                );
              }),
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
        child: ElevatedButton(
          onPressed: isApplied
              ? null
              : () => ApplyJobSheet.show(context, job),
          child: Text(isApplied ? 'Application Already Submitted ✓' : 'Apply For This Position'),
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 12),
        SizedBox(
          width: 130,
          child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textCol)),
    );
  }
}
