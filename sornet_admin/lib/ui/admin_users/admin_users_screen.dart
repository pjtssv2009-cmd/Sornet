import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/admin_user.dart';
import '../../providers/sornet_providers.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUsersProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Users & RBAC'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD1E9FF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Role-Based Access Control (RBAC). Assign granular privileges for View, Create, Edit, Delete, and Approval across marketplace modules.',
                        style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.primaryDark, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Platform Administrators (${provider.adminUsers.length})',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.adminUsers.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final user = provider.adminUsers[index];
                  return _buildAdminUserCard(context, user, provider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminUserCard(BuildContext context, AdminUser user, AdminUsersProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: user.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null,
                child: user.avatarUrl.isEmpty
                    ? Text(user.name[0], style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary))
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
                            user.name,
                            style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFB2CCFF)),
                          ),
                          child: Text(
                            user.role.displayName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${user.email} • ${user.phone}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active: ${AppFormatters.formatRelativeTime(user.lastActive)}',
                style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textMuted),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                ),
                onPressed: () => _showPermissionsDialog(context, user, provider),
                child: const Text('Edit Role & Permissions', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPermissionsDialog(BuildContext context, AdminUser user, AdminUsersProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${user.name} - Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Administrative Role:'),
            const SizedBox(height: 12),
            ...AdminRole.values.map((role) {
              return RadioListTile<AdminRole>(
                title: Text(role.displayName, style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600)),
                value: role,
                groupValue: user.role,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  if (val != null) {
                    provider.updateRole(user.id, val);
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Updated role to ${val.displayName}')),
                    );
                  }
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
        ],
      ),
    );
  }
}
