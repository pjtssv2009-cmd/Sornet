import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_profile_provider.dart';
import '../common/rating_stars.dart';
import '../common/status_badge.dart';

class PublicProfilePreviewScreen extends StatelessWidget {
  final Technician? technician;

  const PublicProfilePreviewScreen({super.key, this.technician});

  @override
  Widget build(BuildContext context) {
    final tech = technician ??
        Provider.of<TechnicianProfileProvider>(context).technician ??
        MockData.currentTechnician;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Public Profile Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Notice
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.visibility_rounded,
                      color: AppTheme.primaryBlue, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is how hiring businesses view your profile on SORNET.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Header Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryLight,
                            border: Border.all(
                              color: AppTheme.primaryBlue,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      tech.fullName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ),
                                  if (tech.isVerified)
                                    StatusBadge(
                                      text: 'Verified',
                                      color: AppTheme.accentGreen,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tech.primaryTrade,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 14, color: AppTheme.textMuted),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${tech.city}, ${tech.state}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  RatingStars(
                                    rating: tech.rating,
                                    size: 14,
                                    color: AppTheme.accentOrange,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${tech.rating.toStringAsFixed(1)} (${tech.totalReviews} reviews)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                            'Experience', '${tech.totalExperienceYears} yrs'),
                        _buildStat('Completed', '${tech.completedJobsCount} jobs'),
                        _buildStat('Trust Score', '${tech.trustScore}/100'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bio
            if (tech.bio != null && tech.bio!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Technician',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tech.bio!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textDark,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Skills
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Technical Skills & Specialties',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tech.skills.map((s) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Brand Experience
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Brand Experience',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tech.brandExperience.map((b) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundSoft,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.borderLight),
                          ),
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Work Experience
            if (tech.experiences.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Work History',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...tech.experiences.map((exp) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: AppTheme.primaryBlue, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${exp.jobTitle} • ${exp.companyName}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                    Text(
                                      '${Formatters.formatDate(exp.startDate)} - ${exp.isCurrent ? "Present" : exp.endDate != null ? Formatters.formatDate(exp.endDate!) : ""}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.textMuted,
                                      ),
                                    ),
                                    if (exp.description != null) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        exp.description!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}
