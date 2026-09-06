import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../common/status_badge.dart';
import 'business_verification_screen.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  void _openEditProfileDialog(BuildContext context, dynamic business) {
    final nameCtrl = TextEditingController(text: business?.businessName ?? '');
    final contactCtrl = TextEditingController(text: business?.contactPerson ?? '');
    final phoneCtrl = TextEditingController(text: business?.mobileNumber ?? '');
    final emailCtrl = TextEditingController(text: business?.email ?? '');
    final addressCtrl = TextEditingController(text: business?.address ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.surface,
        title: const Text('Edit Business Profile', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Business Name'),
              TextField(controller: nameCtrl, decoration: const InputDecoration(isDense: true)),
              const SizedBox(height: 12),
              _buildLabel('Contact Person'),
              TextField(controller: contactCtrl, decoration: const InputDecoration(isDense: true)),
              const SizedBox(height: 12),
              _buildLabel('Mobile Number'),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(isDense: true)),
              const SizedBox(height: 12),
              _buildLabel('Email Address'),
              TextField(controller: emailCtrl, decoration: const InputDecoration(isDense: true)),
              const SizedBox(height: 12),
              _buildLabel('Address'),
              TextField(controller: addressCtrl, maxLines: 2, decoration: const InputDecoration(isDense: true)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (business != null) {
                final updated = business.copyWith(
                  businessName: nameCtrl.text.trim(),
                  contactPerson: contactCtrl.text.trim(),
                  mobileNumber: phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  address: addressCtrl.text.trim(),
                );
                context.read<BusinessProfileProvider>().updateProfile(updated);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  static Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profileProvider = context.watch<BusinessProfileProvider>();
    final business = profileProvider.business ?? auth.currentBusiness;

    if (business == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Business Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.primary),
            tooltip: 'Edit Profile',
            onPressed: () => _openEditProfileDialog(context, business),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppTheme.heroCardGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppTheme.activeShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          business.businessName.isNotEmpty ? business.businessName[0] : 'B',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.primary),
                        ),
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
                                  business.businessName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (business.verification.isFullyVerified)
                                const Icon(Icons.verified_rounded, color: AppTheme.secondary, size: 16),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            business.businessType,
                            style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${business.city} • Tier: ${business.subscriptionTier}',
                            style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.75)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Verification Quick Strip
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        StatusBadge.businessVerification(business.verification.status),
                        const SizedBox(width: 10),
                        Text(
                          '${business.verification.verifiedCount}/6 Checks Passed',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BusinessVerificationScreen()),
                        );
                      },
                      child: const Text('Manage KYC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Business Information
              _buildSectionCard(
                title: 'Business Information',
                icon: Icons.business_rounded,
                child: Column(
                  children: [
                    _buildInfoRow('Category', business.businessType),
                    _buildInfoRow('Contact Person', business.contactPerson),
                    _buildInfoRow('Mobile Number', business.mobileNumber),
                    _buildInfoRow('Email Address', business.email),
                    _buildInfoRow('Headquarters', '${business.address}, ${business.city} - ${business.pincode}'),
                    _buildInfoRow('Operating Hubs', business.operatingLocations.join(', ')),
                    _buildInfoRow('GST / Tax ID', business.gstNumber ?? 'Not Submitted'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Scale & Operations
              _buildSectionCard(
                title: 'Operations & Scale',
                icon: Icons.trending_up_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Years in Business', '${business.yearsInBusiness} Years'),
                    _buildInfoRow('Team Size', '${business.numberOfEmployees} Staff & Technicians'),
                    _buildInfoRow('Marketplace Rating', '${business.rating}★ (${business.reviewCount} Reviews)'),
                    const SizedBox(height: 10),
                    const Text('Services Offered', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textTertiary)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: business.servicesOffered
                          .map((s) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppTheme.primaryLight, borderRadius: BorderRadius.circular(6)),
                                child: Text(s, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Verification Documents
              _buildSectionCard(
                title: 'Uploaded Company Documents (${business.documents.length})',
                icon: Icons.file_present_rounded,
                child: Column(
                  children: business.documents.isEmpty
                      ? [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No documents uploaded yet.', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          )
                        ]
                      : business.documents.map((doc) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, color: AppTheme.error, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(doc.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                      Text('Uploaded ${Formatters.formatDate(doc.uploadDate)}', style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
                                    ],
                                  ),
                                ),
                                if (doc.isVerified)
                                  const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 16)
                                else
                                  const Text('Under Review', style: TextStyle(fontSize: 10, color: AppTheme.warningText, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          );
                        }).toList(),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          ),
        ],
      ),
    );
  }
}
