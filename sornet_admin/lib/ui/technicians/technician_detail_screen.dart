import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/document_preview_dialog.dart';
import '../common/confirm_dialog.dart';

class TechnicianDetailScreen extends StatelessWidget {
  final String technicianId;

  const TechnicianDetailScreen({super.key, required this.technicianId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TechniciansProvider>(
      builder: (context, provider, child) {
        final tech = provider.technicians.cast<Technician?>().firstWhere(
              (t) => t?.id == technicianId,
              orElse: () => null,
            );

        if (tech == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Technician Profile')),
            body: const Center(child: Text('Technician profile not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Technician Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditDialog(context, tech, provider),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) => _handleMenuAction(context, val, tech, provider),
                itemBuilder: (context) => [
                  if (tech.verificationStatus != VerificationStatus.verified)
                    const PopupMenuItem(value: 'verify', child: Text('Approve & Verify')),
                  if (tech.verificationStatus != VerificationStatus.rejected)
                    const PopupMenuItem(value: 'reject', child: Text('Reject Profile')),
                  const PopupMenuItem(value: 'request_docs', child: Text('Request More Documents')),
                  if (tech.verificationStatus != VerificationStatus.suspended)
                    const PopupMenuItem(value: 'suspend', child: Text('Suspend Account'))
                  else
                    const PopupMenuItem(value: 'restore', child: Text('Restore Account')),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                _buildProfileHeaderCard(context, tech),
                const SizedBox(height: 16),

                // Rejection / Suspension Notice Banner
                if (tech.rejectionReason != null)
                  _buildAlertBanner('Profile Rejected', tech.rejectionReason!, AppColors.error, AppColors.errorBg),
                if (tech.suspensionReason != null)
                  _buildAlertBanner('Account Suspended', tech.suspensionReason!, AppColors.warning, AppColors.warningBg),

                // Trust Score & Key Numbers Card
                _buildTrustAndMetricsCard(tech),
                const SizedBox(height: 16),

                // Verification Checklist
                _buildVerificationChecklistCard(context, tech, provider),
                const SizedBox(height: 16),

                // Professional Information
                _buildProfessionalInfoCard(tech),
                const SizedBox(height: 16),

                // AC Expertise & Inverter Experience
                _buildAcExpertiseCard(tech),
                const SizedBox(height: 16),

                // Brands Supported Matrix
                _buildBrandsCard(tech),
                const SizedBox(height: 16),

                // Services Checklist
                _buildServicesCard(tech),
                const SizedBox(height: 16),

                // Submitted Documents & Proofs
                _buildDocumentsCard(context, tech, provider),
                const SizedBox(height: 16),

                // Ratings & Reviews
                _buildReviewsCard(tech),
                const SizedBox(height: 24),

                // Bottom Admin Action Buttons Bar
                _buildAdminActionsBar(context, tech, provider),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeaderCard(BuildContext context, Technician tech) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: tech.profilePhoto.isNotEmpty ? NetworkImage(tech.profilePhoto) : null,
                child: tech.profilePhoto.isEmpty
                    ? Text(
                        tech.name.isNotEmpty ? tech.name[0] : 'T',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary),
                      )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            tech.name,
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                        ),
                        StatusBadge.fromVerificationStatus(tech.verificationStatus),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tech.primarySkill,
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Joined: ${AppFormatters.formatDate(tech.dateJoined)}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // Contact Row
          Row(
            children: [
              Expanded(
                child: _buildContactPill(
                  icon: Icons.phone_outlined,
                  text: tech.phone,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${tech.phone}...')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildContactPill(
                  icon: Icons.location_on_outlined,
                  text: tech.city,
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildContactPill(
            icon: Icons.mail_outline_rounded,
            text: tech.email,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Emailing ${tech.email}...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactPill({required IconData icon, required String text, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertBanner(String title, String message, Color color, Color bg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13.5)),
                const SizedBox(height: 2),
                Text(message, style: TextStyle(color: color, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustAndMetricsCard(Technician tech) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricColumn('Trust Score', '${tech.trustScore}%', tech.trustScore >= 80 ? AppColors.success : AppColors.warning),
          _buildDivider(),
          _buildMetricColumn('Rating', '${tech.rating} ★', const Color(0xFFF59E0B)),
          _buildDivider(),
          _buildMetricColumn('Jobs Done', '${tech.completedJobs}', AppColors.primary),
          _buildDivider(),
          _buildMetricColumn('Experience', '${tech.yearsExperience} Yrs', AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 32, width: 1, color: AppColors.border);
  }

  Widget _buildMetricColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildVerificationChecklistCard(BuildContext context, Technician tech, TechniciansProvider provider) {
    final cl = tech.verificationChecklist;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Verification Checklist',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cl.completedCount == 5 ? AppColors.successBg : AppColors.warningBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${cl.completedCount}/5 Verified',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: cl.completedCount == 5 ? AppColors.success : AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCheckItem(
            'Phone Number Verified (OTP)',
            cl.phoneVerified,
            (val) => provider.updateChecklist(tech.id, cl.copyWith(phoneVerified: val)),
          ),
          _buildCheckItem(
            'Identity Proof Verified (Aadhaar/PAN)',
            cl.identityVerified,
            (val) => provider.updateChecklist(tech.id, cl.copyWith(identityVerified: val)),
          ),
          _buildCheckItem(
            'Experience Certificate Verified',
            cl.experienceVerified,
            (val) => provider.updateChecklist(tech.id, cl.copyWith(experienceVerified: val)),
          ),
          _buildCheckItem(
            'Brand/ITI Training Certificate Verified',
            cl.certificateVerified,
            (val) => provider.updateChecklist(tech.id, cl.copyWith(certificateVerified: val)),
          ),
          _buildCheckItem(
            'Admin Background Review Approved',
            cl.adminVerified,
            (val) => provider.updateChecklist(tech.id, cl.copyWith(adminVerified: val)),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, bool isChecked, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isChecked ? AppColors.success : AppColors.textMuted,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isChecked ? FontWeight.w600 : FontWeight.w400,
                color: isChecked ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          Switch(
            value: isChecked,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoCard(Technician tech) {
    return _buildSectionCard(
      title: 'Professional Details',
      icon: Icons.work_outline_rounded,
      children: [
        _buildInfoRow('Current Occupation', tech.currentOccupation),
        const Divider(height: 14),
        _buildInfoRow('Employment Type', tech.employmentType),
        const Divider(height: 14),
        _buildInfoRow('Years Experience', '${tech.yearsExperience} Years'),
        const Divider(height: 14),
        _buildInfoRow('Work Location', tech.location),
      ],
    );
  }

  Widget _buildAcExpertiseCard(Technician tech) {
    return _buildSectionCard(
      title: 'AC Expertise & Technology',
      icon: Icons.ac_unit_rounded,
      children: [
        Text(
          'AC Units Serviced:',
          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: tech.acExpertise.map((ac) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD1E9FF)),
              ),
              child: Text(
                ac,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        _buildInfoRow('Inverter AC Handling', tech.inverterExperience),
      ],
    );
  }

  Widget _buildBrandsCard(Technician tech) {
    return _buildSectionCard(
      title: 'Brands Experience',
      icon: Icons.star_border_rounded,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.brands.map((brand) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check, size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    brand,
                    style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServicesCard(Technician tech) {
    return _buildSectionCard(
      title: 'Services & Operations',
      icon: Icons.build_outlined,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tech.services.map((srv) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                srv,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDocumentsCard(BuildContext context, Technician tech, TechniciansProvider provider) {
    return _buildSectionCard(
      title: 'Submitted Documents (${tech.documents.length})',
      icon: Icons.description_outlined,
      children: [
        if (tech.documents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('No documents uploaded yet.', style: TextStyle(color: AppColors.textMuted)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tech.documents.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final doc = tech.documents[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.file_present_rounded, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  doc.title,
                  style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  '${doc.type} • ${doc.documentNumber}',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusBadge.fromVerificationStatus(doc.status, isSmall: true),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
                  ],
                ),
                onTap: () {
                  DocumentPreviewDialog.show(
                    context,
                    document: doc,
                    onStatusChange: (status, note) {
                      provider.updateDocumentStatus(tech.id, doc.id, status, note: note);
                    },
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildReviewsCard(Technician tech) {
    return _buildSectionCard(
      title: 'Ratings & Reviews (${tech.reviewCount})',
      icon: Icons.reviews_outlined,
      children: [
        if (tech.reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No reviews available.', style: TextStyle(color: AppColors.textMuted)),
          )
        else
          ...tech.reviews.map((rev) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rev.customerName, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 14),
                          const SizedBox(width: 2),
                          Text('${rev.rating}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(rev.comment, style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildAdminActionsBar(BuildContext context, Technician tech, TechniciansProvider provider) {
    return Row(
      children: [
        if (tech.verificationStatus != VerificationStatus.verified) ...[
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Verify Profile'),
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context,
                  title: 'Approve Technician Profile',
                  message: 'Confirm profile verification for ${tech.name}?',
                  confirmText: 'Approve & Verify',
                );
                if (confirm == true) {
                  await provider.verifyTechnician(tech.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${tech.name} is now verified!'), backgroundColor: AppColors.success),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.errorBorder),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.block_rounded, size: 18),
            label: Text(tech.verificationStatus == VerificationStatus.suspended ? 'Restore' : 'Suspend'),
            onPressed: () async {
              if (tech.verificationStatus == VerificationStatus.suspended) {
                await provider.restoreTechnician(tech.id);
              } else {
                _promptSuspension(context, tech, provider);
              }
            },
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action, Technician tech, TechniciansProvider provider) async {
    if (action == 'verify') {
      await provider.verifyTechnician(tech.id);
    } else if (action == 'reject') {
      _promptRejection(context, tech, provider);
    } else if (action == 'request_docs') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document request notification sent to technician.')),
      );
    } else if (action == 'suspend') {
      _promptSuspension(context, tech, provider);
    } else if (action == 'restore') {
      await provider.restoreTechnician(tech.id);
    }
  }

  void _promptRejection(BuildContext context, Technician tech, TechniciansProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Technician Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specify reason for rejecting ${tech.name}:'),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'e.g. Identity verification failed...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              final reason = controller.text.trim();
              Navigator.of(ctx).pop();
              await provider.rejectTechnician(tech.id, reason.isNotEmpty ? reason : 'Rejected by Admin');
            },
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );
  }

  void _promptSuspension(BuildContext context, Technician tech, TechniciansProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Suspend Technician Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reason for suspending ${tech.name}:'),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'e.g. Terms violation, customer complaints...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              final reason = controller.text.trim();
              Navigator.of(ctx).pop();
              await provider.suspendTechnician(tech.id, reason.isNotEmpty ? reason : 'Suspended by Admin');
            },
            child: const Text('Confirm Suspend'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Technician tech, TechniciansProvider provider) {
    final skillController = TextEditingController(text: tech.primarySkill);
    final occController = TextEditingController(text: tech.currentOccupation);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Technician Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: skillController,
              decoration: const InputDecoration(labelText: 'Primary Skill'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: occController,
              decoration: const InputDecoration(labelText: 'Current Occupation'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = tech.copyWith(
                primarySkill: skillController.text.trim(),
                currentOccupation: occController.text.trim(),
              );
              provider.repository.saveTechnician(updated);
              provider.loadTechnicians();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Technician details updated!')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
