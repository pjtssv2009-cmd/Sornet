import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_provider.dart';
import '../../providers/job_provider.dart';
import '../common/status_badge.dart';
import '../common/rating_stars.dart';
import '../interviews/schedule_interview_screen.dart';
import '../offers/create_offer_screen.dart';
import '../messaging/chat_conversation_screen.dart';

class TechnicianDetailScreen extends StatelessWidget {
  final Technician technician;

  const TechnicianDetailScreen({super.key, required this.technician});

  @override
  Widget build(BuildContext context) {
    final techProvider = context.watch<TechnicianProvider>();
    final isShortlisted = techProvider.technicians.firstWhere(
      (t) => t.id == technician.id,
      orElse: () => technician,
    ).isShortlisted;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Technician Profile'),
        actions: [
          IconButton(
            icon: Icon(
              isShortlisted ? Icons.star_rounded : Icons.star_outline_rounded,
              color: isShortlisted ? AppTheme.purple : AppTheme.textPrimary,
            ),
            tooltip: 'Shortlist Candidate',
            onPressed: () {
              techProvider.toggleShortlist(technician.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Candidate profile link copied.')),
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
              _buildHeaderCard(context, technician, isShortlisted),
              const SizedBox(height: 16),

              // Trust & Verification Ledger
              _buildVerificationLedgerCard(technician),
              const SizedBox(height: 16),

              // About Section
              _buildSectionCard(
                title: 'About Professional',
                icon: Icons.person_outline_rounded,
                child: Text(
                  technician.about,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
                ),
              ),
              const SizedBox(height: 16),

              // AC Systems Specialization
              _buildSectionCard(
                title: 'AC Systems Expertise',
                icon: Icons.ac_unit_rounded,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: technician.acExpertise
                      .map((ac) => Chip(
                            label: Text(ac, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                            backgroundColor: AppTheme.primaryLight,
                            side: BorderSide.none,
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Technical & Brands
              _buildSectionCard(
                title: 'Technical Capabilities & Brands',
                icon: Icons.build_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubheading('Inverter Technology'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: technician.technicalExpertise
                          .map((inv) => _buildPill(inv, AppTheme.surfaceMuted, AppTheme.textPrimary))
                          .toList(),
                    ),
                    const SizedBox(height: 14),

                    _buildSubheading('Brand Expertise'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: technician.brands
                          .map((b) => _buildPill(b, AppTheme.infoBg, AppTheme.infoText))
                          .toList(),
                    ),
                    const SizedBox(height: 14),

                    _buildSubheading('Service Capabilities'),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: technician.services
                          .map((s) => _buildPill(s, AppTheme.successBg, AppTheme.successText))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Experience History
              if (technician.experienceHistory.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Professional Experience History',
                  icon: Icons.history_rounded,
                  child: Column(
                    children: technician.experienceHistory.map((exp) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.business_center_rounded, color: AppTheme.primary, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exp.role, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                                  Text(exp.company, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                                  Text(exp.duration, style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
                                  if (exp.description.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(exp.description, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Certificates
              if (technician.certificates.isNotEmpty) ...[
                _buildSectionCard(
                  title: 'Certificates & Licensure',
                  icon: Icons.military_tech_rounded,
                  child: Column(
                    children: technician.certificates.map((cert) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 22),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cert.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                  Text('${cert.issuer} • ${cert.issueYear}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                                  Text('Cert No: ${cert.certificateNumber}', style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Rating Summary
              _buildRatingBreakdownCard(technician),
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
            // Message Button
            IconButton(
              icon: const Icon(Icons.chat_outlined, color: AppTheme.primary),
              tooltip: 'Message Candidate',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatConversationScreen(technician: technician),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            // Schedule Interview
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  final jobs = context.read<JobProvider>().activeJobs;
                  final defaultJob = jobs.isNotEmpty ? jobs.first : null;
                  if (defaultJob != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ScheduleInterviewScreen(
                          technician: technician,
                          job: defaultJob,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Interview'),
              ),
            ),
            const SizedBox(width: 10),
            // Send Offer
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  final jobs = context.read<JobProvider>().activeJobs;
                  final defaultJob = jobs.isNotEmpty ? jobs.first : null;
                  if (defaultJob != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CreateOfferScreen(
                          technician: technician,
                          job: defaultJob,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Send Offer', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Technician tech, bool isShortlisted) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  tech.name.isNotEmpty ? tech.name[0] : 'T',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.primary),
                ),
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
                            tech.name,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (tech.isVerified)
                          const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 18),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tech.location} • ${tech.city}',
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                        const SizedBox(width: 2),
                        Text(
                          '${tech.rating} (${tech.reviewsCount} verified reviews)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppTheme.borderLight),
          const SizedBox(height: 14),

          // Quick Metadata Row
          Row(
            children: [
              Expanded(
                child: _buildHeaderMeta('Experience', '${tech.experienceYears} Years'),
              ),
              Expanded(
                child: _buildHeaderMeta('Expected Rate', '${Formatters.formatCurrency(tech.expectedSalaryMonthly)}/mo'),
              ),
              Expanded(
                child: _buildHeaderMeta('Availability', tech.availability),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    );
  }

  Widget _buildVerificationLedgerCard(Technician tech) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trust Score: ${tech.trustScore}/100', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                  const Text('Identity & Practical Skills Audited', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
            ],
          ),
          StatusBadge.verified(label: 'Level 4'),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
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
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildRatingBreakdownCard(Technician tech) {
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
          const Text('Ratings & Evaluation Breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _buildRatingCategoryRow('Technical Skill', 4.9),
          _buildRatingCategoryRow('Professionalism', 4.8),
          _buildRatingCategoryRow('Communication', 4.7),
          _buildRatingCategoryRow('Punctuality', 4.9),
          _buildRatingCategoryRow('Quality of Work', 4.9),
        ],
      ),
    );
  }

  Widget _buildRatingCategoryRow(String label, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          Row(
            children: [
              RatingStars(rating: rating, size: 14),
              const SizedBox(width: 6),
              Text('$rating', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubheading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
    );
  }

  Widget _buildPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}
