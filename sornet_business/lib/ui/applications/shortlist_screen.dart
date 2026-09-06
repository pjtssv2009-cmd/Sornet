import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_provider.dart';
import '../../providers/job_provider.dart';
import '../common/empty_state.dart';
import '../discovery/technician_detail_screen.dart';
import '../discovery/technician_comparison_screen.dart';
import '../interviews/schedule_interview_screen.dart';
import '../messaging/chat_conversation_screen.dart';

class ShortlistScreen extends StatelessWidget {
  const ShortlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final techProvider = context.watch<TechnicianProvider>();
    final shortlisted = techProvider.shortlistedTechnicians;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text('Shortlisted Technicians (${shortlisted.length})'),
        actions: [
          if (shortlisted.length >= 2)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TechnicianComparisonScreen(technicians: shortlisted.take(4).toList()),
                  ),
                );
              },
              icon: const Icon(Icons.compare_arrows_rounded, size: 18),
              label: const Text('Compare All'),
            ),
        ],
      ),
      body: SafeArea(
        child: shortlisted.isEmpty
            ? const EmptyState(
                icon: Icons.star_outline_rounded,
                title: 'No Shortlisted Technicians',
                message: 'Tap the star icon on any technician profile or application card to save them here.',
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: shortlisted.length,
                itemBuilder: (context, index) {
                  final tech = shortlisted[index];
                  return _buildShortlistCard(context, tech, techProvider);
                },
              ),
      ),
    );
  }

  Widget _buildShortlistCard(BuildContext context, Technician tech, TechnicianProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              tech.name,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (tech.isVerified)
                            const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 15),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${tech.experienceYears} yrs exp • ${tech.city}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 2),
                          Text('${tech.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Text(
                            '${Formatters.formatCurrency(tech.expectedSalaryMonthly)} / mo',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.star_rounded, color: AppTheme.purple, size: 24),
                  tooltip: 'Remove from Shortlist',
                  onPressed: () {
                    provider.toggleShortlist(tech.id);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...tech.acExpertise.take(3).map((ac) => _buildPill(ac, AppTheme.primaryLight, AppTheme.primary)),
                ...tech.brands.take(3).map((b) => _buildPill(b, AppTheme.surfaceMuted, AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),

            const Divider(height: 1, color: AppTheme.borderLight),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: tech)),
                    );
                  },
                  child: const Text('View Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat_outlined, color: AppTheme.primary, size: 20),
                      tooltip: 'Send Message',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatConversationScreen(technician: tech),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton.icon(
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
                      icon: const Icon(Icons.event_available_rounded, size: 14),
                      label: const Text('Schedule Interview'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
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

  Widget _buildPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}
