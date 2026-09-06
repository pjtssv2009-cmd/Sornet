import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/job_provider.dart';
import '../../providers/dashboard_provider.dart';

class JobPreviewScreen extends StatefulWidget {
  final Job job;

  const JobPreviewScreen({super.key, required this.job});

  @override
  State<JobPreviewScreen> createState() => _JobPreviewScreenState();
}

class _JobPreviewScreenState extends State<JobPreviewScreen> {
  bool _isPublishing = false;

  void _handlePublish() async {
    setState(() => _isPublishing = true);
    final jobProvider = context.read<JobProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    await jobProvider.publishJob(widget.job);
    await dashboardProvider.loadDashboardData();

    if (mounted) {
      setState(() => _isPublishing = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: AppTheme.surface,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppTheme.successText, size: 44),
              ),
              const SizedBox(height: 16),
              const Text(
                'Job Published Successfully!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your requirement for "${widget.job.title}" is now active on the SORNET marketplace.',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop(); // Back from preview
                    Navigator.of(context).pop(); // Back from post job
                  },
                  child: const Text('View in My Jobs'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.job;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Job Preview'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  j.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceMuted,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  j.technicianType,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            j.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.business_rounded, size: 14, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  j.businessName,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${j.location}, ${j.city}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quick Specs Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSpecBox('Salary Range', Formatters.formatSalaryRange(j.minSalary, j.maxSalary, period: j.salaryPeriod)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSpecBox('Positions', '${j.positionsCount} Openings'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSpecBox('Experience', j.experienceRequired),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildSpecBox('Joining Date', Formatters.formatDate(j.joiningDate)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // AC Systems & Skills
                    _buildDetailCard(
                      title: 'AC Systems & Specialization',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: j.skillsRequired
                            .map((s) => Chip(
                                  label: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                                  backgroundColor: AppTheme.primaryLight,
                                  side: BorderSide.none,
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Technical Expertise & Brands
                    _buildDetailCard(
                      title: 'Brand & Technical Specialization',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (j.technicalExpertise.isNotEmpty) ...[
                            Text('Technology: ${j.technicalExpertise.join(', ')}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                            const SizedBox(height: 8),
                          ],
                          Text('Brands: ${j.brands.join(', ')}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text('Services: ${j.requiredServices.join(', ')}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Job Description
                    _buildDetailCard(
                      title: 'Job Description',
                      child: Text(
                        j.description,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Benefits
                    if (j.benefits.isNotEmpty) ...[
                      _buildDetailCard(
                        title: 'Perks & Benefits',
                        child: Column(
                          children: j.benefits
                              .map((b) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline_rounded, color: AppTheme.success, size: 16),
                                        const SizedBox(width: 8),
                                        Text(b, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // Additional Requirements
                    if (j.additionalRequirements.isNotEmpty) ...[
                      _buildDetailCard(
                        title: 'Additional Requirements',
                        child: Text(
                          j.additionalRequirements,
                          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isPublishing ? null : _handlePublish,
                      icon: _isPublishing
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                          : const Icon(Icons.publish_rounded, size: 18),
                      label: const Text('Publish Requirement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildDetailCard({required String title, required Widget child}) {
    return Container(
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
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
