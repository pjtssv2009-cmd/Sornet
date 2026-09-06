import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AboutSornetScreen extends StatelessWidget {
  const AboutSornetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('About SORNET'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppTheme.activeShadow,
                ),
                child: const Icon(Icons.handshake_rounded, color: Colors.white, size: 38),
              ),
              const SizedBox(height: 16),
              const Text(
                'SORNET — Business App',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Version ${AppConstants.appVersion} (Build 1001)',
                style: TextStyle(fontSize: 12, color: AppTheme.textTertiary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 14),
              const Text(
                'SORNET is India’s premier skilled-technician hiring marketplace connecting HVAC contractors, facility managers, and authorized service centers with certified AC and refrigeration specialists.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    _buildAboutTile('Terms of Service', 'Read marketplace recruitment guidelines', () {}),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _buildAboutTile('Privacy Policy & Data Security', 'GDPR & Indian DPDP Act Compliance', () {}),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _buildAboutTile('Safety & Verification Protocol', 'How candidate audit works', () {}),
                    const Divider(height: 1, color: AppTheme.borderLight),
                    _buildAboutTile('Licenses & Third Party Notices', 'Open source software attributions', () {}),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                '© 2026 SORNET Technologies India Pvt. Ltd.\nAll Rights Reserved.',
                style: TextStyle(fontSize: 11, color: AppTheme.textTertiary, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutTile(String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textTertiary),
    );
  }
}
