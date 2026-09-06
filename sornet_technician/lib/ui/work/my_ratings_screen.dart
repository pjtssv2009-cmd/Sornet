import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/review.dart';
import '../../providers/auth_provider.dart';
import '../../providers/work_provider.dart';
import '../common/empty_state.dart';
import '../common/rating_stars.dart';

class MyRatingsScreen extends StatelessWidget {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkProvider>(context);
    final technician = Provider.of<AuthProvider>(context).currentTechnician;
    final reviews = workProvider.reviewsReceived;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Ratings & Reviews'),
      ),
      body: reviews.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.star_outline_rounded,
                title: 'No reviews yet',
                subtitle:
                    'When employers complete engagements with you and leave reviews, they will be listed here.',
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Rating Scorecard
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    (technician?.rating ?? 4.9)
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ),
                                  RatingStars(
                                    rating: technician?.rating ?? 4.9,
                                    size: 18,
                                    color: AppTheme.accentOrange,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${technician?.totalReviews ?? reviews.length} Reviews',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppTheme.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildScoreBar('Technical Knowledge', 4.9),
                                    const SizedBox(height: 6),
                                    _buildScoreBar('Work Quality', 4.9),
                                    const SizedBox(height: 6),
                                    _buildScoreBar('Punctuality', 4.8),
                                    const SizedBox(height: 6),
                                    _buildScoreBar('Safety Adherence', 5.0),
                                    const SizedBox(height: 6),
                                    _buildScoreBar('Communication', 4.8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Employer Reviews',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return _EmployerReviewCard(review: review);
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildScoreBar(String label, double score) {
    final percent = score / 5.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
            ),
            Text(
              score.toStringAsFixed(1),
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark),
            ),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 5,
            backgroundColor: AppTheme.borderLight,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.accentOrange),
          ),
        ),
      ],
    );
  }
}

class _EmployerReviewCard extends StatelessWidget {
  final EmployerRating review;

  const _EmployerReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.business_rounded,
                      size: 20, color: AppTheme.primaryBlue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.businessName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        review.jobTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingStars(
                      rating: review.overallRating,
                      size: 14,
                      color: AppTheme.accentOrange,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.formatRelativeTime(review.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.reviewText,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textDark,
                height: 1.4,
              ),
            ),
            if (review.wouldHireAgain) ...[
              const SizedBox(height: 10),
              Row(
                children: const [
                  Icon(Icons.thumb_up_alt_outlined,
                      size: 14, color: AppTheme.accentGreen),
                  SizedBox(width: 6),
                  Text(
                    'Would hire again for future projects',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
