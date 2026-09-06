import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class AboutSornetScreen extends StatelessWidget {
  const AboutSornetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('About SORNET'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'v${AppConstants.appVersion} (${AppConstants.appBuildNumber})',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Professional Skilled-Technician Hiring Platform',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 28),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mission & Vision',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'SORNET connects verified skilled trade technicians (HVAC, Electrical, Plumbing, Home Appliances) with verified commercial contractors, businesses, and enterprises across India with transparency, fair wages, and verified credentials.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Privacy Policy',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.launch_rounded, size: 18),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening SORNET Privacy Policy...')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.gavel_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Terms of Service',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.launch_rounded, size: 18),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening Terms of Service...')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_outlined,
                        color: AppTheme.primaryBlue),
                    title: const Text('Trust & Safety Standards',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.launch_rounded, size: 18),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening Trust & Safety Guide...')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              '© 2026 SORNET Technologies India Pvt Ltd.\nAll rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
