import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_profile_provider.dart';
import '../common/status_badge.dart';

class VerificationCenterScreen extends StatelessWidget {
  const VerificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<TechnicianProfileProvider>(context);
    final technician = profileProvider.technician;
    final ver = technician?.verification ??
        TechnicianVerification(
          status: VerificationStatus.verified,
          verifiedAt: DateTime.now().subtract(const Duration(days: 30)),
          isPhoneVerified: true,
          isEmailVerified: true,
          isIdentityVerified: true,
          isExperienceVerified: true,
          isSkillCertified: true,
        );

    final totalChecks = 5;
    var passedChecks = 0;
    if (ver.isPhoneVerified) passedChecks++;
    if (ver.isEmailVerified) passedChecks++;
    if (ver.isIdentityVerified) passedChecks++;
    if (ver.isExperienceVerified) passedChecks++;
    if (ver.isSkillCertified) passedChecks++;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Verification Center'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trust status banner
            Card(
              color: AppTheme.primaryLight.withValues(alpha: 0.5),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_user_rounded,
                              color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SORNET Verified Professional',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Trust Score: ${profileProvider.trustScore}/100 • $passedChecks/$totalChecks Checks Passed',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: passedChecks / totalChecks,
                        minHeight: 8,
                        backgroundColor: AppTheme.borderLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.accentGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Verification Checklist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),

            _buildVerificationTile(
              context,
              icon: Icons.phone_android_rounded,
              title: 'Mobile Phone Verification',
              subtitle: technician?.phone ?? '+91 98765 43210',
              isPassed: ver.isPhoneVerified,
              proofInfo: 'Verified via OTP',
            ),
            const SizedBox(height: 12),

            _buildVerificationTile(
              context,
              icon: Icons.email_outlined,
              title: 'Email Address Verification',
              subtitle: technician?.email ?? 'technician@sornet.com',
              isPassed: ver.isEmailVerified,
              proofInfo: 'Verified via Email Link',
            ),
            const SizedBox(height: 12),

            _buildVerificationTile(
              context,
              icon: Icons.badge_outlined,
              title: 'Government Identity (Aadhaar / PAN)',
              subtitle: 'Aadhaar ending with **** 8892 verified by SORNET',
              isPassed: ver.isIdentityVerified,
              proofInfo: 'Govt Database Match',
            ),
            const SizedBox(height: 12),

            _buildVerificationTile(
              context,
              icon: Icons.work_history_outlined,
              title: 'Prior Work Experience Check',
              subtitle: 'Verified with past employer service letters',
              isPassed: ver.isExperienceVerified,
              proofInfo: 'Verified by Admin',
            ),
            const SizedBox(height: 12),

            _buildVerificationTile(
              context,
              icon: Icons.military_tech_outlined,
              title: 'Technical Skill & HVAC Certification',
              subtitle: 'ITI Air Conditioning & Daikin VRV Specialist',
              isPassed: ver.isSkillCertified,
              proofInfo: 'Certificates Validated',
            ),
            const SizedBox(height: 24),

            // Benefits of verification
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why Get Verified on SORNET?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBenefitRow(
                        'Verified badge displayed prominently to hiring businesses'),
                    _buildBenefitRow('3x higher chances of receiving direct interview invites'),
                    _buildBenefitRow('Priority ranking in technician search algorithms'),
                    _buildBenefitRow('Eligible for premium commercial HVAC projects'),
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

  Widget _buildVerificationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isPassed,
    required String proofInfo,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isPassed
                    ? AppTheme.accentGreen.withValues(alpha: 0.12)
                    : AppTheme.accentOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isPassed ? AppTheme.accentGreen : AppTheme.accentOrange,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isPassed
                            ? Icons.check_circle_rounded
                            : Icons.hourglass_top_rounded,
                        size: 13,
                        color: isPassed
                            ? AppTheme.accentGreen
                            : AppTheme.accentOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        proofInfo,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isPassed
                              ? AppTheme.accentGreen
                              : AppTheme.accentOrange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatusBadge(
              text: isPassed ? 'Verified' : 'In Review',
              color: isPassed ? AppTheme.accentGreen : AppTheme.accentOrange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(Icons.check_circle_rounded,
                size: 14, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textDark,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
