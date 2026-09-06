import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/job_provider.dart';
import '../common/empty_state.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Saved Jobs'),
      ),
      body: SafeArea(
        child: jobProvider.savedJobs.isEmpty
            ? EmptyState(
                icon: Icons.bookmark_border_rounded,
                title: 'No Saved Jobs',
                description: 'Bookmark jobs while searching to easily review and apply to them later.',
                actionText: 'Browse Jobs',
                onAction: () => Navigator.of(context).pop(),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: jobProvider.savedJobs.length,
                itemBuilder: (context, index) {
                  final saved = jobProvider.savedJobs[index];
                  final job = saved.job;

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
                              radius: 20,
                              backgroundColor: AppTheme.primaryLight,
                              child: const Icon(Icons.business_rounded, color: AppTheme.primary, size: 20),
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
                                  Text(
                                    job.businessName,
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark_rounded, color: AppTheme.primary),
                              onPressed: () => jobProvider.toggleSaveJob(job.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textTertiary),
                            const SizedBox(width: 4),
                            Text(job.city, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            const SizedBox(width: 16),
                            const Icon(Icons.currency_rupee_rounded, size: 14, color: AppTheme.textTertiary),
                            Text(
                              Formatters.formatSalaryRange(job.minSalary, job.maxSalary),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Saved ${Formatters.timeAgo(saved.savedAt)}',
                              style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('View & Apply', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
