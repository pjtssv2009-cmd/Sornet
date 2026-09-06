import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/review.dart';
import '../../providers/auth_provider.dart';
import '../../providers/work_provider.dart';
import '../common/rating_stars.dart';

class RateBusinessScreen extends StatefulWidget {
  final String recordId;
  final String businessId;
  final String businessName;
  final String jobTitle;

  const RateBusinessScreen({
    super.key,
    required this.recordId,
    required this.businessId,
    required this.businessName,
    required this.jobTitle,
  });

  @override
  State<RateBusinessScreen> createState() => _RateBusinessScreenState();
}

class _RateBusinessScreenState extends State<RateBusinessScreen> {
  double _overallRating = 5.0;
  double _professionalism = 5.0;
  double _timelyPayment = 5.0;
  double _workEnvironment = 5.0;
  double _communication = 5.0;
  bool _wouldRecommend = true;

  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a brief review feedback')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final technician =
        Provider.of<AuthProvider>(context, listen: false).currentTechnician;

    final review = BusinessReview(
      id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
      technicianId: technician?.id ?? 'tech_1',
      technicianName: technician?.fullName ?? 'R. Arun Kumar',
      technicianTrade: technician?.primaryTrade ?? 'AC Technician',
      businessId: widget.businessId,
      businessName: widget.businessName,
      jobTitle: widget.jobTitle,
      overallRating: _overallRating,
      professionalismRating: _professionalism,
      timelyPaymentRating: _timelyPayment,
      workEnvironmentRating: _workEnvironment,
      communicationRating: _communication,
      reviewText: _reviewController.text.trim(),
      wouldRecommend: _wouldRecommend,
      createdAt: DateTime.now(),
    );

    await Provider.of<WorkProvider>(context, listen: false)
        .rateBusiness(widget.recordId, review);

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your employer review has been submitted.'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Rate Employer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business_rounded,
                          color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.businessName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            widget.jobTitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Rating card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Experience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: RatingStars(
                        rating: _overallRating,
                        size: 32,
                        color: AppTheme.accentOrange,
                        onRatingChanged: (val) =>
                            setState(() => _overallRating = val),
                      ),
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Detailed Evaluation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRatingRow('Professionalism & Respect', _professionalism,
                        (v) => setState(() => _professionalism = v)),
                    const SizedBox(height: 12),
                    _buildRatingRow('Timely & Transparent Payment',
                        _timelyPayment, (v) => setState(() => _timelyPayment = v)),
                    const SizedBox(height: 12),
                    _buildRatingRow('Safe Work Environment', _workEnvironment,
                        (v) => setState(() => _workEnvironment = v)),
                    const SizedBox(height: 12),
                    _buildRatingRow('Clear Communication & Support',
                        _communication, (v) => setState(() => _communication = v)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Written review
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Written Feedback',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Share honest feedback about working with this employer to help other technicians.',
                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _reviewController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. Prompt supervisor response, safe tools provided, payment settled on schedule...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Would you recommend working with this business?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      value: _wouldRecommend,
                      activeColor: AppTheme.primaryBlue,
                      onChanged: (val) => setState(() => _wouldRecommend = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit Employer Review',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingRow(
      String label, double rating, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textDark,
            ),
          ),
        ),
        RatingStars(
          rating: rating,
          size: 20,
          color: AppTheme.accentOrange,
          onRatingChanged: onChanged,
        ),
      ],
    );
  }
}
