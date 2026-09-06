import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_profile_provider.dart';
import '../common/status_badge.dart';

class BusinessVerificationScreen extends StatefulWidget {
  const BusinessVerificationScreen({super.key});

  @override
  State<BusinessVerificationScreen> createState() => _BusinessVerificationScreenState();
}

class _BusinessVerificationScreenState extends State<BusinessVerificationScreen> {
  void _uploadDocDialog(BuildContext context, String defaultTitle, String defaultType) {
    final titleCtrl = TextEditingController(text: defaultTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.surface,
        title: Text('Upload $defaultTitle', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select file from your device (PDF, JPEG, PNG, max 5MB).',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, color: AppTheme.primary, size: 24),
                  SizedBox(width: 8),
                  Text('Choose File from Storage', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BusinessProfileProvider>().uploadDocument(titleCtrl.text.trim(), defaultType);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$defaultTitle uploaded successfully for admin verification.'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Submit Document'),
          ),
        ],
      ),
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

    final v = business.verification;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Business Verification (KYC)'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Hero Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: v.isFullyVerified ? AppTheme.primaryGradient : AppTheme.heroCardGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: AppTheme.activeShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge.businessVerification(v.status),
                        Text(
                          '${v.completionPercentage.toInt()}% Complete',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      v.isFullyVerified ? 'Verified Business Partner' : 'Your business verification is under review.',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      v.isFullyVerified
                          ? 'Your credentials, GST, and registered address are verified by SORNET platform administration.'
                          : 'Our verification team audits uploaded documents within 24-48 business hours.',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: v.verifiedCount / 6.0,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 6-Point Verification Checklist
              Container(
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
                    const Text(
                      'Verification Checklist (6 Key Pillars)',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 16),
                    _buildChecklistItem('1. Mobile OTP Authentication', v.phoneVerified, 'Verified via SMS gateway'),
                    _buildChecklistItem('2. Official Email Address', v.emailVerified, 'Verified business inbox'),
                    _buildChecklistItem('3. Business Identity & Registration', v.businessIdentityVerified, 'Company name & authorized signatory confirmed'),
                    _buildChecklistItem('4. GST / MSME Tax ID', v.registrationVerified, 'Valid 15-digit GSTIN active check'),
                    _buildChecklistItem('5. Physical Address Confirmation', v.addressVerified, 'Registered commercial utility bill audit'),
                    _buildChecklistItem('6. Admin Platform Approval', v.adminApproved, 'Manual compliance clearance by SORNET Admin'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Upload / Update Documents Section
              Container(
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
                    const Text(
                      'KYC Document Uploads',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    _buildUploadTile(
                      title: 'GST Registration Certificate',
                      isUploaded: business.documents.any((d) => d.documentType == 'GST_CERTIFICATE'),
                      onTap: () => _uploadDocDialog(context, 'GST Registration Certificate', 'GST_CERTIFICATE'),
                    ),
                    _buildUploadTile(
                      title: 'MSME / Udyam Certificate',
                      isUploaded: business.documents.any((d) => d.documentType == 'COMPANY_PROOF'),
                      onTap: () => _uploadDocDialog(context, 'MSME Certificate', 'COMPANY_PROOF'),
                    ),
                    _buildUploadTile(
                      title: 'Address Proof (Commercial EB Bill / Lease)',
                      isUploaded: business.documents.any((d) => d.documentType == 'ADDRESS_PROOF'),
                      onTap: () => _uploadDocDialog(context, 'Commercial EB Bill', 'ADDRESS_PROOF'),
                    ),
                    _buildUploadTile(
                      title: 'Trade License / Corporation Certificate',
                      isUploaded: false,
                      onTap: () => _uploadDocDialog(context, 'Trade License', 'TRADE_LICENSE'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String title, bool isChecked, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isChecked ? AppTheme.success : AppTheme.textTertiary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isChecked ? AppTheme.textPrimary : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  description,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadTile({
    required String title,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
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
          Icon(
            isUploaded ? Icons.verified_rounded : Icons.cloud_upload_outlined,
            color: isUploaded ? AppTheme.primary : AppTheme.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
          ),
          TextButton(
            onPressed: onTap,
            child: Text(isUploaded ? 'Replace' : 'Upload', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
