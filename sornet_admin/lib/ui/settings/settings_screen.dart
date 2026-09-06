import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sornet_providers.dart';
import '../auth/admin_login_screen.dart';
import '../common/confirm_dialog.dart';
import 'admin_profile_screen.dart';
import 'api_config_screen.dart';
import 'about_sornet_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, SettingsProvider>(
      builder: (context, auth, settings, child) {
        final user = auth.currentUser;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings & Administration'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Admin Profile Summary Card
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
                ),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: user?.avatarUrl.isNotEmpty == true ? NetworkImage(user!.avatarUrl) : null,
                        child: user?.avatarUrl.isEmpty != false
                            ? Text(
                                user?.name.isNotEmpty == true ? user!.name[0] : 'A',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Admin User',
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? 'admin@sornet.com',
                              style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.role.displayName ?? 'Super Admin',
                              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Security Section
              _buildSectionTitle('Security & Authentication'),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.password_rounded,
                  title: 'Change Admin Password',
                  subtitle: 'Update your account access credentials',
                  onTap: () => _showChangePasswordDialog(context),
                ),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primary),
                  title: Text('Biometric Login', style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Allow fingerprint or Face ID login', style: TextStyle(fontSize: 12)),
                  value: settings.biometricLogin,
                  activeColor: AppColors.primary,
                  onChanged: (val) => settings.setBiometricLogin(val),
                ),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  secondary: const Icon(Icons.security_rounded, color: AppColors.primary),
                  title: Text('Two-Factor Auth (2FA)', style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Require OTP code upon administrative login', style: TextStyle(fontSize: 12)),
                  value: settings.twoFactorAuth,
                  activeColor: AppColors.primary,
                  onChanged: (val) => settings.setTwoFactorAuth(val),
                ),
              ]),
              const SizedBox(height: 20),

              // Notification Settings
              _buildSectionTitle('Notification Preferences'),
              _buildSettingsGroup([
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                  title: Text('Push Notifications', style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Receive real-time alerts for verifications and jobs', style: TextStyle(fontSize: 12)),
                  value: settings.pushNotifications,
                  activeColor: AppColors.primary,
                  onChanged: (val) => settings.setPushNotifications(val),
                ),
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  secondary: const Icon(Icons.sms_outlined, color: AppColors.primary),
                  title: Text('SMS Alerts', style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Critical security and payout alerts via SMS', style: TextStyle(fontSize: 12)),
                  value: settings.smsAlerts,
                  activeColor: AppColors.primary,
                  onChanged: (val) => settings.setSmsAlerts(val),
                ),
              ]),
              const SizedBox(height: 20),

              // Platform & API
              _buildSectionTitle('Platform & Backend API'),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.api_rounded,
                  title: 'API Configuration',
                  subtitle: 'Base URL, environment & secure API keys',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ApiConfigScreen()),
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About SORNET',
                  subtitle: '${AppConstants.appFullName} • ${AppConstants.appVersion}',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutSornetScreen()),
                  ),
                ),
              ]),
              const SizedBox(height: 24),

              // Logout Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.errorBorder, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.errorBg,
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out of Admin Portal'),
                onPressed: () => _handleLogout(context, auth),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: children.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current Password'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password changed successfully!'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context, AuthProvider auth) async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to logout of SORNET Admin?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      isDangerous: true,
      icon: Icons.logout_rounded,
    );

    if (confirm == true) {
      auth.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
