import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/hiring.dart';
import '../../providers/hiring_provider.dart';
import '../../providers/technician_provider.dart';
import '../common/rating_stars.dart';

class RateTechnicianScreen extends StatefulWidget {
  final HiredTechnician hiredTechnician;

  const RateTechnicianScreen({super.key, required this.hiredTechnician});

  @override
  State<RateTechnicianScreen> createState() => _RateTechnicianScreenState();
}

class _RateTechnicianScreenState extends State<RateTechnicianScreen> {
  double _technicalSkill = 5.0;
  double _professionalism = 5.0;
  double _communication = 4.0;
  double _punctuality = 5.0;
  double _qualityOfWork = 5.0;
  final _reviewTextController = TextEditingController(
    text: 'Highly satisfied with technician execution. Quick AC installation with proper vacuuming and spotless cleanup.',
  );
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewTextController.dispose();
    super.dispose();
  }

  double get _overallRating =>
      ((_technicalSkill + _professionalism + _communication + _punctuality + _qualityOfWork) / 5.0);

  void _submitReview() async {
    if (_reviewTextController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please share a few words about the technician’s performance.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final hiringProvider = context.read<HiringProvider>();
    final techProvider = context.read<TechnicianProvider>();

    await hiringProvider.submitReview(
      hiringId: widget.hiredTechnician.id,
      technicianId: widget.hiredTechnician.technicianId,
      technicianName: technicianName,
      jobTitle: widget.hiredTechnician.jobTitle,
      technicalSkillRating: _technicalSkill,
      professionalismRating: _professionalism,
      communicationRating: _communication,
      punctualityRating: _punctuality,
      qualityOfWorkRating: _qualityOfWork,
      reviewText: _reviewTextController.text.trim(),
    );

    await techProvider.loadTechnicians();

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you! Your verified rating for $technicianName was saved.'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  String get technicianName => widget.hiredTechnician.technicianName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rate & Review Technician'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Candidate Header Card
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
                      radius: 24,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        technicianName.isNotEmpty ? technicianName[0] : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            technicianName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          Text(
                            widget.hiredTechnician.position,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                          Text(
                            'Job: ${widget.hiredTechnician.jobTitle}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Overall Score Preview
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppTheme.heroCardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Rating',
                          style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        RatingStars(rating: _overallRating, size: 22, color: const Color(0xFFFBBF24)),
                      ],
                    ),
                    Text(
                      _overallRating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5 Criteria Sliders / Star Pickers
              Container(
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
                    const Text(
                      'Detailed Evaluation Criteria',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    _buildCriteriaRow('1. Technical Skill', _technicalSkill, (val) => setState(() => _technicalSkill = val)),
                    _buildCriteriaRow('2. Professionalism', _professionalism, (val) => setState(() => _professionalism = val)),
                    _buildCriteriaRow('3. Communication', _communication, (val) => setState(() => _communication = val)),
                    _buildCriteriaRow('4. Punctuality', _punctuality, (val) => setState(() => _punctuality = val)),
                    _buildCriteriaRow('5. Quality of Work', _qualityOfWork, (val) => setState(() => _qualityOfWork = val)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Review Text
              Container(
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
                    const Text(
                      'Written Feedback & Recommendations',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _reviewTextController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Share specific details about quality, timeliness, and technician conduct...',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitReview,
            icon: _isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                : const Icon(Icons.star_rounded, size: 20),
            label: const Text('Submit Verified Review', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  Widget _buildCriteriaRow(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
          ),
          RatingStars(
            rating: value,
            size: 24,
            isInteractive: true,
            onRatingChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
