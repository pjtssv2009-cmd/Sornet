import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/module_feature.dart';
import '../../providers/sornet_providers.dart';
import '../common/confirm_dialog.dart';

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ModulesProvider>(
      builder: (context, provider, child) {
        final groups = <String, List<PlatformModule>>{};
        for (var m in provider.modules) {
          groups.putIfAbsent(m.category, () => []).add(m);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Module & Feature Management'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD1E9FF)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.toggle_on_rounded, color: AppColors.primary, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Enable or disable marketplace platform modules in real-time. Disabling critical modules will show a confirmation prompt.',
                        style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.primaryDark, height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ...groups.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
                      child: Text(
                        entry.key,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: entry.value.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final mod = entry.value[index];
                          return _buildModuleTile(context, mod, provider);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModuleTile(BuildContext context, PlatformModule mod, ModulesProvider provider) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: mod.isEnabled ? AppColors.primaryLight : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          _getModuleIcon(mod.iconName),
          color: mod.isEnabled ? AppColors.primary : AppColors.textMuted,
          size: 22,
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              mod.name,
              style: GoogleFonts.inter(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
          if (mod.isCritical) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.warningBorder),
              ),
              child: const Text('Critical', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warning)),
            ),
          ],
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          mod.description,
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
      value: mod.isEnabled,
      activeColor: AppColors.primary,
      onChanged: (val) async {
        if (!val && mod.isCritical) {
          final confirm = await ConfirmDialog.show(
            context,
            title: 'Disable Critical Module?',
            message: 'Disabling "${mod.name}" will temporarily pause core operations for all technicians and businesses.',
            confirmText: 'Disable Module',
            isDangerous: true,
          );
          if (confirm == true) {
            await provider.toggleModule(mod.id, false);
          }
        } else {
          await provider.toggleModule(mod.id, val);
        }
      },
    );
  }

  IconData _getModuleIcon(String iconName) {
    switch (iconName) {
      case 'person_add':
        return Icons.person_add_rounded;
      case 'domain_add':
        return Icons.domain_add_rounded;
      case 'work':
        return Icons.work_rounded;
      case 'send':
        return Icons.send_rounded;
      case 'chat':
        return Icons.chat_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'verified_user':
        return Icons.verified_user_rounded;
      case 'notifications_active':
        return Icons.notifications_active_rounded;
      case 'campaign':
        return Icons.campaign_rounded;
      case 'payments':
        return Icons.payments_rounded;
      case 'bar_chart':
        return Icons.bar_chart_rounded;
      default:
        return Icons.extension_rounded;
    }
  }
}
