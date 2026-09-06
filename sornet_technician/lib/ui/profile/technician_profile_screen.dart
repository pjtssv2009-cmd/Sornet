import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/technician_profile_provider.dart';
import '../common/profile_strength_card.dart';
import '../common/trust_score_widget.dart';
import '../verification/verification_center_screen.dart';
import 'availability_screen.dart';
import 'certificate_manager_screen.dart';
import 'document_manager_screen.dart';
import 'experience_manager_screen.dart';
import 'public_profile_preview_screen.dart';

class TechnicianProfileScreen extends StatelessWidget {
  const TechnicianProfileScreen({super.key});

  void _showEditAboutDialog(BuildContext context, String currentBio) {
    final controller = TextEditingController(text: currentBio);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Professional Bio'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Summarize your experience and core technical strengths...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TechnicianProfileProvider>(context, listen: false)
                  .updateBio(controller.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bio updated successfully!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditSkillsDialog(
      BuildContext context, List<String> currentSkills) {
    final selectedSkills = List<String>.from(currentSkills);
    final allAvailableSkills = AppConstants.allSkills;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Technical Skills',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose the technical capabilities you excel in.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allAvailableSkills.map((skill) {
                        final isSelected = selectedSkills.contains(skill);
                        return FilterChip(
                          label: Text(skill),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryLight,
                          checkmarkColor: AppTheme.primaryBlue,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.textDark,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedSkills.add(skill);
                              } else {
                                selectedSkills.remove(skill);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<TechnicianProfileProvider>(context,
                              listen: false)
                          .updateSkills(selectedSkills);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save Skills'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditBrandsDialog(
      BuildContext context, List<String> currentBrands) {
    final selectedBrands = List<String>.from(currentBrands);
    final allBrands = AppConstants.acBrands;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Brand Experience',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select OEM brands you have serviced or repaired.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allBrands.map((brand) {
                        final isSelected = selectedBrands.contains(brand);
                        return FilterChip(
                          label: Text(brand),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryLight,
                          checkmarkColor: AppTheme.primaryBlue,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.textDark,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                selectedBrands.add(brand);
                              } else {
                                selectedBrands.remove(brand);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<TechnicianProfileProvider>(context,
                              listen: false)
                          .updateBrands(selectedBrands);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Save Brands'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<TechnicianProfileProvider>(context);
    final technician = profileProvider.technician;

    if (technician == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PublicProfilePreviewScreen(technician: technician),
                ),
              );
            },
            icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
            label: const Text('Preview'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
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
                                size: 44,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            if (technician.isVerified)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accentGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.verified_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                technician.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                technician.primaryTrade,
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
                                    '${technician.city}, ${technician.state}',
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
                                  const Icon(Icons.star_rounded,
                                      size: 16, color: AppTheme.accentOrange),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${technician.rating.toStringAsFixed(1)} (${technician.totalReviews} Reviews)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
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
                        _buildStatColumn('Experience',
                            '${technician.totalExperienceYears} Years'),
                        _buildDivider(),
                        _buildStatColumn('Jobs Completed',
                            '${technician.completedJobsCount}'),
                        _buildDivider(),
                        _buildStatColumn('Availability',
                            technician.availability.status.label),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile strength and trust score cards
            ProfileStrengthCard(
              percentage: profileProvider.profileCompleteness,
              onTapAction: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VerificationCenterScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            TrustScoreWidget(score: profileProvider.trustScore),
            const SizedBox(height: 16),

            // Verification Center Banner
            Card(
              color: AppTheme.primaryLight.withValues(alpha: 0.5),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.verified_user_rounded,
                      color: Colors.white, size: 22),
                ),
                title: const Text(
                  'Verification Center',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
                subtitle: const Text(
                  'Aadhaar, trade certificates & experience verification',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppTheme.primaryBlue),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VerificationCenterScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // About section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'About Me',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: AppTheme.primaryBlue),
                          onPressed: () => _showEditAboutDialog(
                              context, technician.bio ?? ''),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      technician.bio != null && technician.bio!.isNotEmpty
                          ? technician.bio!
                          : 'No bio added yet. Add a summary to stand out to employers.',
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            technician.bio != null && technician.bio!.isNotEmpty
                                ? AppTheme.textDark
                                : AppTheme.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Technical Skills
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Technical Skills',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: AppTheme.primaryBlue),
                          onPressed: () => _showEditSkillsDialog(
                              context, technician.skills),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: technician.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            skill,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Brand Experience',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: AppTheme.primaryBlue),
                          onPressed: () => _showEditBrandsDialog(
                              context, technician.brandExperience),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: technician.brandExperience.map((brand) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.borderLight),
                          ),
                          child: Text(
                            brand,
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

            // Profile Sections Navigation Tiles
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.work_history_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text(
                      'Work Experience',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${technician.experiences.length} positions recorded',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExperienceManagerScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.card_membership_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text(
                      'Certifications & Licenses',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${technician.certificates.length} certificates added',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CertificateManagerScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.folder_shared_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text(
                      'Document Vault',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${technician.documents.length} verified documents',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DocumentManagerScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.event_available_rounded,
                        color: AppTheme.primaryBlue),
                    title: const Text(
                      'Availability & Preferences',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Status: ${technician.availability.status.label}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AvailabilityScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
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

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: AppTheme.borderLight,
    );
  }
}
