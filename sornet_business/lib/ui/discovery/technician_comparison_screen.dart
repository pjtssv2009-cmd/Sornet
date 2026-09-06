import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_provider.dart';
import '../../providers/job_provider.dart';
import '../common/status_badge.dart';
import '../interviews/schedule_interview_screen.dart';
import '../offers/create_offer_screen.dart';

class TechnicianComparisonScreen extends StatelessWidget {
  final List<Technician> technicians;

  const TechnicianComparisonScreen({super.key, required this.technicians});

  @override
  Widget build(BuildContext context) {
    final techProvider = context.watch<TechnicianProvider>();

    if (technicians.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Compare Candidates')),
        body: const Center(
          child: Text('No candidates selected for comparison.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Compare Candidates (${technicians.length}/4)'),
        actions: [
          TextButton(
            onPressed: () {
              techProvider.clearComparison();
              Navigator.of(context).pop();
            },
            child: const Text('Clear All', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Candidate Headers Horizontal Scroll
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: technicians.map((tech) {
                    return Container(
                      width: 240,
                      margin: const EdgeInsets.only(right: 12),
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
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppTheme.primaryLight,
                                child: Text(
                                  tech.name.isNotEmpty ? tech.name[0] : 'T',
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tech.name,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${tech.city} • ${tech.experienceYears} yrs',
                                      style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          StatusBadge.trustScore(tech.trustScore),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: AppTheme.borderLight),
                          const SizedBox(height: 10),

                          _buildComparisonMetric('Rating', '${tech.rating}★ (${tech.reviewsCount})'),
                          _buildComparisonMetric('Expected Salary', '${Formatters.formatCurrency(tech.expectedSalaryMonthly)}/mo'),
                          _buildComparisonMetric('Daily Rate', '${Formatters.formatCurrency(tech.dailyRate)}/day'),
                          _buildComparisonMetric('Availability', tech.availability),

                          const SizedBox(height: 10),
                          const Text('AC Systems', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textTertiary)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tech.acExpertise.map((ac) => _buildPill(ac, AppTheme.primaryLight, AppTheme.primary)).toList(),
                          ),

                          const SizedBox(height: 10),
                          const Text('Top Brands', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textTertiary)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tech.brands.map((b) => _buildPill(b, AppTheme.surfaceMuted, AppTheme.textSecondary)).toList(),
                          ),

                          const SizedBox(height: 10),
                          const Text('Key Services', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textTertiary)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: tech.services.take(4).map((s) => _buildPill(s, AppTheme.successBg, AppTheme.successText)).toList(),
                          ),

                          const SizedBox(height: 16),

                          // Direct Actions
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                final jobs = context.read<JobProvider>().activeJobs;
                                final defaultJob = jobs.isNotEmpty ? jobs.first : null;
                                if (defaultJob != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ScheduleInterviewScreen(
                                        technician: tech,
                                        job: defaultJob,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              child: const Text('Schedule Interview'),
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                final jobs = context.read<JobProvider>().activeJobs;
                                final defaultJob = jobs.isNotEmpty ? jobs.first : null;
                                if (defaultJob != null) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CreateOfferScreen(
                                        technician: tech,
                                        job: defaultJob,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              child: const Text('Send Offer'),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonMetric(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}
