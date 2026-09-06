import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/business.dart';
import '../../data/models/technician.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/confirm_dialog.dart';

class BusinessDetailScreen extends StatelessWidget {
  final String businessId;

  const BusinessDetailScreen({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessesProvider>(
      builder: (context, provider, child) {
        final biz = provider.businesses.cast<Business?>().firstWhere(
              (b) => b?.id == businessId,
              orElse: () => null,
            );

        if (biz == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Business Details')),
            body: const Center(child: Text('Business entity not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Business Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditDialog(context, biz, provider),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (val) => _handleMenuAction(context, val, biz, provider),
                itemBuilder: (context) => [
                  if (biz.verificationStatus != VerificationStatus.verified)
                    const PopupMenuItem(value: 'verify', child: Text('Approve & Verify Business')),
                  if (biz.verificationStatus != VerificationStatus.rejected)
                    const PopupMenuItem(value: 'reject', child: Text('Reject Profile')),
                  const PopupMenuItem(value: 'request_docs', child: Text('Request More Documents')),
                  if (biz.verificationStatus != VerificationStatus.suspended)
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
                // Header Card
                _buildHeaderCard(context, biz),
                const SizedBox(height: 16),

                // Alert Banner if rejected or suspended
                if (biz.rejectionReason != null)
                  _buildAlertBanner('Verification Rejected', biz.rejectionReason!, AppColors.error, AppColors.errorBg),
                if (biz.suspensionReason != null)
                  _buildAlertBanner('Account Suspended', biz.suspensionReason!, AppColors.warning, AppColors.warningBg),

                // Statistics Card
                _buildStatisticsCard(biz),
                const SizedBox(height: 16),

                // Professional Information
                _buildProfessionalCard(biz),
                const SizedBox(height: 16),

                // Services & Operations
                _buildServicesCard(biz),
                const SizedBox(height: 16),

                // Documents & Proofs
                _buildDocumentsCard(context, biz),
                const SizedBox(height: 24),

                // Bottom Action Buttons
                _buildActionButtons(context, biz, provider),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(BuildContext context, Business biz) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.purpleBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.business_rounded, color: AppColors.purple, size: 30),
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
                            biz.businessName,
                            style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                        ),
                        StatusBadge.fromVerificationStatus(biz.verificationStatus),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      biz.businessType,
                      style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'GSTIN: ${biz.registrationNumber}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildInfoRow('Contact Person', biz.contactPerson),
          const SizedBox(height: 8),
          _buildInfoRow('Phone', biz.phone),
          const SizedBox(height: 8),
          _buildInfoRow('Email', biz.email),
          const SizedBox(height: 8),
          _buildInfoRow('Address', '${biz.address}, ${biz.city} - ${biz.pinCode}'),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(Business biz) {
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
          _buildMetricColumn('Total Jobs', '${biz.totalJobs}', AppColors.textPrimary),
          _buildDivider(),
          _buildMetricColumn('Active Jobs', '${biz.activeJobs}', AppColors.primary),
          _buildDivider(),
          _buildMetricColumn('Hired Techs', '${biz.hiredTechnicians}', AppColors.success),
          _buildDivider(),
          _buildMetricColumn('Applications', '${biz.applicationsReceived}', const Color(0xFFE11D48)),
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
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildProfessionalCard(Business biz) {
    return _buildSectionCard(
      title: 'Company Operations',
      icon: Icons.domain_rounded,
      children: [
        _buildInfoRow('Number of Employees', '${biz.numberOfEmployees} Staff'),
        const Divider(height: 14),
        Text(
          'Operating Locations:',
          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: biz.operatingLocations.map((loc) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(loc, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
            );
          }).toList(),
        ),
        const Divider(height: 20),
        Text(
          'Current Technician Hiring Requirements:',
          style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(
          biz.technicianRequirements,
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildServicesCard(Business biz) {
    return _buildSectionCard(
      title: 'Services Provided',
      icon: Icons.checklist_rounded,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: biz.services.map((srv) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(srv, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDocumentsCard(BuildContext context, Business biz) {
    return _buildSectionCard(
      title: 'Registration Proofs (${biz.documents.length})',
      icon: Icons.file_present_rounded,
      children: [
        if (biz.documents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No verification documents uploaded.', style: TextStyle(color: AppColors.textMuted)),
          )
        else
          ...biz.documents.map((doc) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary, size: 24),
              title: Text(doc.title, style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600)),
              subtitle: Text('${doc.type} • ${doc.documentNumber}', style: const TextStyle(fontSize: 12)),
              trailing: StatusBadge.fromVerificationStatus(doc.status, isSmall: true),
            );
          }),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Business biz, BusinessesProvider provider) {
    return Row(
      children: [
        if (biz.verificationStatus != VerificationStatus.verified) ...[
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.verified_user_rounded, size: 18),
              label: const Text('Verify Business'),
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context,
                  title: 'Approve Business Account',
                  message: 'Confirm platform verification for ${biz.businessName}?',
                  confirmText: 'Approve',
                );
                if (confirm == true) {
                  await provider.verifyBusiness(biz.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${biz.businessName} verified!'), backgroundColor: AppColors.success),
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
            label: Text(biz.verificationStatus == VerificationStatus.suspended ? 'Restore' : 'Suspend'),
            onPressed: () async {
              if (biz.verificationStatus == VerificationStatus.suspended) {
                await provider.restoreBusiness(biz.id);
              } else {
                _promptSuspension(context, biz, provider);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
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
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ),
      ],
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

  void _handleMenuAction(BuildContext context, String action, Business biz, BusinessesProvider provider) async {
    if (action == 'verify') {
      await provider.verifyBusiness(biz.id);
    } else if (action == 'reject') {
      _promptRejection(context, biz, provider);
    } else if (action == 'request_docs') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document update requested from business owner.')),
      );
    } else if (action == 'suspend') {
      _promptSuspension(context, biz, provider);
    } else if (action == 'restore') {
      await provider.restoreBusiness(biz.id);
    }
  }

  void _promptRejection(BuildContext context, Business biz, BusinessesProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Business Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Specify reason for rejecting ${biz.businessName}:'),
            const SizedBox(height: 10),
            TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: 'e.g. Invalid GSTIN proof...')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              final reason = controller.text.trim();
              Navigator.of(ctx).pop();
              await provider.rejectBusiness(biz.id, reason.isNotEmpty ? reason : 'Rejected by Admin');
            },
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );
  }

  void _promptSuspension(BuildContext context, Business biz, BusinessesProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Suspend Business Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reason for suspending ${biz.businessName}:'),
            const SizedBox(height: 10),
            TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: 'e.g. Terms violation...')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              final reason = controller.text.trim();
              Navigator.of(ctx).pop();
              await provider.suspendBusiness(biz.id, reason.isNotEmpty ? reason : 'Suspended by Admin');
            },
            child: const Text('Confirm Suspend'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Business biz, BusinessesProvider provider) {
    final contactController = TextEditingController(text: biz.contactPerson);
    final phoneController = TextEditingController(text: biz.phone);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Business Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: contactController, decoration: const InputDecoration(labelText: 'Contact Person')),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = biz.copyWith(
                contactPerson: contactController.text.trim(),
                phone: phoneController.text.trim(),
              );
              provider.saveBusiness(updated);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Business updated!')));
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
