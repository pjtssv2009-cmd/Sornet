import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class AboutSornetScreen extends StatelessWidget {
  const AboutSornetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About SORNET'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x28155EEF), blurRadius: 18, offset: Offset(0, 6)),
                  ],
                ),
                child: const Center(
                  child: Text('S', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppConstants.appFullName,
              style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.appTagline,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                AppConstants.appVersion,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platform Overview', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Text(
                    'SORNET is an enterprise marketplace infrastructure engineered to streamline technician hiring, AC maintenance contracts, commercial HVAC installations, and multi-party service dispatch operations across India.',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
                  ),
                  const Divider(height: 24),
                  _buildRow('Platform Architecture', 'Clean Architecture (Flutter + Dart)'),
                  const SizedBox(height: 8),
                  _buildRow('Target Runtime', 'Android SDK 34 (Material 3)'),
                  const SizedBox(height: 8),
                  _buildRow('API Protocol', 'RESTful JSON / WebSockets Sync'),
                  const SizedBox(height: 8),
                  _buildRow('Security Protocol', 'Role Based Access Control (RBAC)'),
                  const SizedBox(height: 8),
                  _buildRow('Support Contact', 'admin-support@sornet.com'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '© 2026 SORNET Platform Technologies. All rights reserved.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary)),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600))),
      ],
    );
  }
}
