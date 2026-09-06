import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../common/confirm_dialog.dart';
import '../profile/business_profile_screen.dart';
import '../profile/business_verification_screen.dart';
import 'subscription_plans_screen.dart';
import 'help_support_screen.dart';
import 'about_sornet_screen.dart';
import '../auth/business_login_screen.dart';

class BusinessSettingsScreen extends StatefulWidget {
  const BusinessSettingsScreen({super.key});

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = true;
  bool _biometricLogin = true;
  bool _twoFactorAuth = false;

  void _handleChangePassword() {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.surface,
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password (min 8 chars)'),
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
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully!'), backgroundColor: AppTheme.success),
              );
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Sign Out of SORNET Business?',
      message: 'Are you sure you want to log out of your business account?',
      confirmText: 'Sign Out',
      confirmColor: AppTheme.error,
      icon: Icons.logout_rounded,
    );

    if (confirmed == true && mounted) {
      context.read<AuthProvider>().logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BusinessLoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final business = auth.currentBusiness;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Business Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // User Card
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
                    radius: 28,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      business != null && business.businessName.isNotEmpty ? business.businessName[0] : 'B',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business?.businessName ?? 'CoolFlow Air Conditioning',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          business?.email ?? 'business@sornet.com',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Plan: ${business?.subscriptionTier ?? "Professional"}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Account & Verification
            _buildSectionHeader('Account & Organization'),
            _buildSettingsTile(
              icon: Icons.business_rounded,
              title: 'Business Information',
              subtitle: 'Edit contact person, hubs, team size',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BusinessProfileScreen()),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.verified_user_outlined,
              title: 'Business Verification (KYC)',
              subtitle: 'Manage GST, MSME, and address proof',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BusinessVerificationScreen()),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.workspace_premium_outlined,
              title: 'Subscription & SaaS Tiers',
              subtitle: 'Free, Professional, and Enterprise plans',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SubscriptionPlansScreen()),
                );
              },
            ),
            const SizedBox(height: 18),

            // Security Settings
            _buildSectionHeader('Security & Authentication'),
            _buildSettingsTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              subtitle: 'Update your admin login password',
              onTap: _handleChangePassword,
            ),
            _buildSwitchTile(
              icon: Icons.fingerprint_rounded,
              title: 'Biometric Login',
              subtitle: 'Quick access via FaceID / Fingerprint',
              value: _biometricLogin,
              onChanged: (val) => setState(() => _biometricLogin = val),
            ),
            _buildSwitchTile(
              icon: Icons.security_rounded,
              title: 'Two-Factor Authentication (2FA)',
              subtitle: 'SMS code verification on every sign in',
              value: _twoFactorAuth,
              onChanged: (val) => setState(() => _twoFactorAuth = val),
            ),
            const SizedBox(height: 18),

            // Notification Preferences
            _buildSectionHeader('Notification Preferences'),
            _buildSwitchTile(
              icon: Icons.notifications_active_outlined,
              title: 'Push Notifications',
              subtitle: 'Instant alerts for applications & messages',
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildSwitchTile(
              icon: Icons.mark_email_unread_outlined,
              title: 'Email Summary Digest',
              subtitle: 'Daily candidate match notifications',
              value: _emailAlerts,
              onChanged: (val) => setState(() => _emailAlerts = val),
            ),
            const SizedBox(height: 18),

            // Support & Legal
            _buildSectionHeader('Help & Support'),
            _buildSettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Help Center & Support Desk',
              subtitle: 'FAQs, ticketing, and 24/7 hotline',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'About SORNET',
              subtitle: 'Platform version ${AppConstants.appVersion}, terms, privacy',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutSornetScreen()),
                );
              },
            ),
            const SizedBox(height: 24),

            // Logout Button
            OutlinedButton.icon(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
              label: const Text('Sign Out', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorBg, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppTheme.textTertiary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textTertiary),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        trailing: Switch.adaptive(
          value: value,
          activeColor: AppTheme.primary,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
