import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/promotion.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/confirm_dialog.dart';

class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketingProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Marketing & Promotions'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _showAddEditDialog(context, provider),
              ),
            ],
          ),
          body: provider.promotions.isEmpty
              ? EmptyState(
                  icon: Icons.campaign_outlined,
                  title: 'No Marketing Campaigns',
                  description: 'Create banner campaigns to engage technicians and hiring businesses.',
                  actionText: 'Create Promotion',
                  onAction: () => _showAddEditDialog(context, provider),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.promotions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final promo = provider.promotions[index];
                    return _buildPromotionCard(context, promo, provider);
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Campaign'),
            onPressed: () => _showAddEditDialog(context, provider),
          ),
        );
      },
    );
  }

  Widget _buildPromotionCard(BuildContext context, Promotion promo, MarketingProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image preview
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: AppColors.primaryLight,
              child: promo.bannerImageUrl.isNotEmpty
                  ? Image.network(
                      promo.bannerImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildBannerFallback(promo.title),
                    )
                  : _buildBannerFallback(promo.title),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        promo.title,
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ),
                    StatusBadge.fromPromotionStatus(promo.status, isSmall: true),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  promo.description,
                  style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary, height: 1.35),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${AppFormatters.formatDate(promo.startDate)} - ${AppFormatters.formatDate(promo.endDate)}',
                      style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                    const Spacer(),
                    Text(
                      '${promo.clickCount} Clicks • ${promo.impressionCount} Impr.',
                      style: GoogleFonts.inter(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        promo.redirectLink,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.primary, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showAddEditDialog(context, provider, promotion: promo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          onPressed: () async {
                            final confirm = await ConfirmDialog.show(
                              context,
                              title: 'Delete Campaign',
                              message: 'Permanently remove "${promo.title}"?',
                              confirmText: 'Delete',
                              isDangerous: true,
                            );
                            if (confirm == true) {
                              await provider.deletePromotion(promo.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerFallback(String title) {
    return Container(
      color: AppColors.primaryLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.campaign_rounded, color: AppColors.primary, size: 36),
            const SizedBox(height: 4),
            Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: AppColors.primaryDark, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, MarketingProvider provider, {Promotion? promotion}) {
    final titleCtrl = TextEditingController(text: promotion?.title ?? '');
    final descCtrl = TextEditingController(text: promotion?.description ?? '');
    final linkCtrl = TextEditingController(text: promotion?.redirectLink ?? 'https://sornet.com/');
    final isEditing = promotion != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Promotion' : 'Create Marketing Campaign'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Campaign Title')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              TextField(controller: linkCtrl, decoration: const InputDecoration(labelText: 'Target URL / Deep Link')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.trim().isNotEmpty) {
                final promo = Promotion(
                  id: promotion?.id ?? 'promo_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  bannerImageUrl: promotion?.bannerImageUrl ?? 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=600',
                  description: descCtrl.text.trim(),
                  redirectLink: linkCtrl.text.trim(),
                  startDate: promotion?.startDate ?? DateTime.now(),
                  endDate: promotion?.endDate ?? DateTime.now().add(const Duration(days: 30)),
                  status: promotion?.status ?? PromotionStatus.active,
                  clickCount: promotion?.clickCount ?? 0,
                  impressionCount: promotion?.impressionCount ?? 0,
                );
                provider.savePromotion(promo);
                Navigator.of(ctx).pop();
              }
            },
            child: Text(isEditing ? 'Save' : 'Publish Campaign'),
          ),
        ],
      ),
    );
  }
}
