import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../data/models/business.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/confirm_dialog.dart';
import '../technicians/technician_detail_screen.dart';
import '../businesses/business_detail_screen.dart';

class VerificationCenterScreen extends StatefulWidget {
  const VerificationCenterScreen({super.key});

  @override
  State<VerificationCenterScreen> createState() => _VerificationCenterScreenState();
}

class _VerificationCenterScreenState extends State<VerificationCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Center'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Consumer<TechniciansProvider>(
              builder: (context, techProvider, child) {
                final count = techProvider.technicians.where((t) => t.verificationStatus == VerificationStatus.pending).length;
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Technicians'),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.warningBorder),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            Consumer<BusinessesProvider>(
              builder: (context, bizProvider, child) {
                final count = bizProvider.businesses.where((b) => b.verificationStatus == VerificationStatus.pending).length;
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Businesses'),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.warningBorder),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPendingTechniciansTab(context),
          _buildPendingBusinessesTab(context),
        ],
      ),
    );
  }

  Widget _buildPendingTechniciansTab(BuildContext context) {
    return Consumer<TechniciansProvider>(
      builder: (context, provider, child) {
        final pendingTechs = provider.technicians.where((t) => t.verificationStatus == VerificationStatus.pending).toList();

        if (pendingTechs.isEmpty) {
          return const EmptyState(
            icon: Icons.verified_rounded,
            title: 'All Caught Up!',
            description: 'No technician verification requests currently awaiting administrative review.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pendingTechs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tech = pendingTechs[index];
            return _buildTechVerificationCard(context, tech, provider);
          },
        );
      },
    );
  }

  Widget _buildTechVerificationCard(BuildContext context, Technician tech, TechniciansProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warningBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x08F59E0B), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: tech.profilePhoto.isNotEmpty ? NetworkImage(tech.profilePhoto) : null,
                child: tech.profilePhoto.isEmpty
                    ? Text(tech.name[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary))
                    : null,
              ),
              const SizedBox(width: 12),
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
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                        StatusBadge.fromVerificationStatus(VerificationStatus.pending, isSmall: true),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tech.primarySkill} • ${tech.yearsExperience} Years Exp',
                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${tech.location} • Applied: ${AppFormatters.formatRelativeTime(tech.dateJoined)}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Submitted docs row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.file_copy_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      '${tech.documents.length} Proof Documents Attached',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                Text(
                  '${tech.verificationChecklist.completedCount}/5 Checklist',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning),
                ),
              ],
            ),
          ),
          const Divider(height: 20),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TechnicianDetailScreen(technicianId: tech.id),
                    ),
                  ),
                  child: const Text('Review Docs', style: TextStyle(fontSize: 12.5)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () async {
                    final confirm = await ConfirmDialog.show(
                      context,
                      title: 'Approve & Verify Technician',
                      message: 'Verify all identity documents for ${tech.name}?',
                      confirmText: 'Approve & Verify',
                    );
                    if (confirm == true) {
                      await provider.verifyTechnician(tech.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${tech.name} verified successfully!'), backgroundColor: AppColors.success),
                        );
                      }
                    }
                  },
                  child: const Text('Approve', style: TextStyle(fontSize: 12.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingBusinessesTab(BuildContext context) {
    return Consumer<BusinessesProvider>(
      builder: (context, provider, child) {
        final pendingBusinesses = provider.businesses.where((b) => b.verificationStatus == VerificationStatus.pending).toList();

        if (pendingBusinesses.isEmpty) {
          return const EmptyState(
            icon: Icons.domain_verification_rounded,
            title: 'No Pending Businesses',
            description: 'All business accounts and contractors have been verified.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pendingBusinesses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final biz = pendingBusinesses[index];
            return _buildBusinessVerificationCard(context, biz, provider);
          },
        );
      },
    );
  }

  Widget _buildBusinessVerificationCard(BuildContext context, Business biz, BusinessesProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warningBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(color: Color(0x08F59E0B), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.purpleBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.business_rounded, color: AppColors.purple, size: 28),
              ),
              const SizedBox(width: 12),
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
                            style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                        StatusBadge.fromVerificationStatus(VerificationStatus.pending, isSmall: true),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${biz.businessType} • GST: ${biz.registrationNumber}',
                      style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Contact: ${biz.contactPerson} (${biz.phone})',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BusinessDetailScreen(businessId: biz.id),
                    ),
                  ),
                  child: const Text('Review Entity', style: TextStyle(fontSize: 12.5)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () async {
                    final confirm = await ConfirmDialog.show(
                      context,
                      title: 'Approve & Verify Business',
                      message: 'Authorize and verify business profile for ${biz.businessName}?',
                      confirmText: 'Approve Business',
                    );
                    if (confirm == true) {
                      await provider.verifyBusiness(biz.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${biz.businessName} verified successfully!'), backgroundColor: AppColors.success),
                        );
                      }
                    }
                  },
                  child: const Text('Approve', style: TextStyle(fontSize: 12.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
