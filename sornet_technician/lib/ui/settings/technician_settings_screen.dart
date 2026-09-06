import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../providers/auth_provider.dart';
import '../../providers/technician_profile_provider.dart';
import '../auth/technician_login_screen.dart';
import '../common/confirm_dialog.dart';
import 'about_sornet_screen.dart';
import 'help_support_screen.dart';

class TechnicianSettingsScreen extends StatefulWidget {
  const TechnicianSettingsScreen({super.key});

  @override
  State<TechnicianSettingsScreen> createState() =>
      _TechnicianSettingsScreenState();
}

class _TechnicianSettingsScreenState extends State<TechnicianSettingsScreen> {
  late bool _profileVisible;
  late bool _showPhone;
  late bool _showEmail;
  late bool _allowDirectMessages;
  bool _pushNotifications = true;
  bool _emailJobAlerts = true;
  bool _whatsappUpdates = true;

  @override
  void initState() {
    super.initState();
    final technician =
        Provider.of<TechnicianProfileProvider>(context, listen: false)
            .technician;
    final privacy = technician?.privacySettings ??
        TechnicianPrivacySettings(
          isProfileVisible: true,
          showPhoneNumber: false,
          showEmailAddress: false,
          allowDirectMessages: true,
        );

    _profileVisible = privacy.isProfileVisible;
    _showPhone = privacy.showPhoneNumber;
    _showEmail = privacy.showEmailAddress;
    _allowDirectMessages = privacy.allowDirectMessages;
  }

  void _updatePrivacy() {
    final updated = TechnicianPrivacySettings(
      isProfileVisible: _profileVisible,
      showPhoneNumber: _showPhone,
      showEmailAddress: _showEmail,
      allowDirectMessages: _allowDirectMessages,
    );
    Provider.of<TechnicianProfileProvider>(context, listen: false)
        .updatePrivacySettings(updated);
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: 'Log Out of SORNET?',
        message: 'Are you sure you want to sign out of your technician account?',
        confirmText: 'Log Out',
        cancelText: 'Cancel',
        confirmColor: AppTheme.accentRed,
        onConfirm: () {
          Provider.of<AuthProvider>(context, listen: false).logout();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const TechnicianLoginScreen(),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final technician = authProvider.currentTechnician;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Settings & Privacy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: AppTheme.primaryBlue, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            technician?.fullName ?? 'Technician User',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            technician?.email ?? 'technician@sornet.com',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Privacy & Visibility
            const Text(
              'Privacy & Discovery',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Public Profile Visibility',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Allow verified businesses to discover your profile',
                        style: TextStyle(fontSize: 12)),
                    value: _profileVisible,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) {
                      setState(() => _profileVisible = val);
                      _updatePrivacy();
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Allow Direct In-App Messages',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Employers can contact you before interview invite',
                        style: TextStyle(fontSize: 12)),
                    value: _allowDirectMessages,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) {
                      setState(() => _allowDirectMessages = val);
                      _updatePrivacy();
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Show Phone Number Publicly',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Masked by default; only revealed upon interview confirmation',
                        style: TextStyle(fontSize: 12)),
                    value: _showPhone,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) {
                      setState(() => _showPhone = val);
                      _updatePrivacy();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Notifications
            const Text(
              'Notification Preferences',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Instant alerts for interview invites & offers',
                        style: TextStyle(fontSize: 12)),
                    value: _pushNotifications,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) =>
                        setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Job Recommendation Emails',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Daily digest of matched jobs in your city',
                        style: TextStyle(fontSize: 12)),
                    value: _emailJobAlerts,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) => setState(() => _emailJobAlerts = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('WhatsApp Interview Reminders',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: const Text(
                        'Receive reminders 1 hour before scheduled calls',
                        style: TextStyle(fontSize: 12)),
                    value: _whatsappUpdates,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) => setState(() => _whatsappUpdates = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Support & App Information
            const Text(
              'Support & App Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded,
                        color: AppTheme.primaryBlue),
                    title: const Text('Help & Support Center',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline_rounded,
                        color: AppTheme.primaryBlue),
                    title: const Text('About SORNET Technician',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutSornetScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout_rounded,
                    color: AppTheme.accentRed),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: AppTheme.accentRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.accentRed),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'SORNET Technician App v1.0.0 (Build 1)',
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
