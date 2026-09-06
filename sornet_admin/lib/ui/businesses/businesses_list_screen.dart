import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/business.dart';
import '../../data/models/technician.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/sornet_search_bar.dart';
import '../common/empty_state.dart';
import '../common/shimmer_loading.dart';
import '../common/confirm_dialog.dart';
import 'business_detail_screen.dart';

class BusinessesListScreen extends StatefulWidget {
  final bool showAppBar;
  const BusinessesListScreen({super.key, this.showAppBar = true});

  @override
  State<BusinessesListScreen> createState() => _BusinessesListScreenState();
}

class _BusinessesListScreenState extends State<BusinessesListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BusinessesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: const Text('Business Management'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => provider.loadBusinesses(),
                    ),
                  ],
                )
              : null,
          body: Column(
            children: [
              // Search & Filter Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                color: AppColors.surface,
                child: Column(
                  children: [
                    SornetSearchBar(
                      hintText: 'Search business name, GSTIN, contact person, city...',
                      controller: _searchController,
                      onChanged: (val) => provider.setSearchQuery(val),
                      hasActiveFilters: provider.cityFilter != 'All Cities',
                      onFilterTap: () => _showFilterBottomSheet(context, provider),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'All (${provider.businesses.length})',
                            isSelected: provider.statusFilter == null,
                            onTap: () => provider.setStatusFilter(null),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Verified (${provider.verifiedCount})',
                            isSelected: provider.statusFilter == VerificationStatus.verified,
                            selectedColor: AppColors.successBg,
                            selectedTextColor: AppColors.success,
                            onTap: () => provider.setStatusFilter(VerificationStatus.verified),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Pending (${provider.pendingCount})',
                            isSelected: provider.statusFilter == VerificationStatus.pending,
                            selectedColor: AppColors.warningBg,
                            selectedTextColor: AppColors.warning,
                            onTap: () => provider.setStatusFilter(VerificationStatus.pending),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Rejected (${provider.rejectedCount})',
                            isSelected: provider.statusFilter == VerificationStatus.rejected,
                            selectedColor: AppColors.errorBg,
                            selectedTextColor: AppColors.error,
                            onTap: () => provider.setStatusFilter(VerificationStatus.rejected),
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Suspended (${provider.suspendedCount})',
                            isSelected: provider.statusFilter == VerificationStatus.suspended,
                            selectedColor: AppColors.surfaceSecondary,
                            selectedTextColor: AppColors.textSecondary,
                            onTap: () => provider.setStatusFilter(VerificationStatus.suspended),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Business Cards List
              Expanded(
                child: provider.isLoading && provider.businesses.isEmpty
                    ? const ListShimmerLoading(itemCount: 5)
                    : provider.businesses.isEmpty
                        ? EmptyState(
                            icon: Icons.business_outlined,
                            title: 'No Businesses Found',
                            description: 'No registered company profiles match your current search and filters.',
                            actionText: 'Reset Filters',
                            onAction: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                              provider.setStatusFilter(null);
                              provider.setCityFilter('All Cities');
                            },
                          )
                        : RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: () => provider.loadBusinesses(),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.businesses.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final biz = provider.businesses[index];
                                return _buildBusinessCard(context, biz, provider);
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
    Color? selectedTextColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (selectedColor ?? AppColors.primaryLight) : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? (selectedTextColor ?? AppColors.primary) : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? (selectedTextColor ?? AppColors.primary) : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, Business biz, BusinessesProvider provider) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BusinessDetailScreen(businessId: biz.id),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.purpleBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.business_rounded, color: AppColors.purple, size: 24),
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
                              biz.businessName,
                              style: GoogleFonts.inter(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          StatusBadge.fromVerificationStatus(biz.verificationStatus, isSmall: true),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${biz.businessType} • ${biz.city}',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contact: ${biz.contactPerson} (${biz.phone})',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Hiring & Job Numbers Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatPill('Total Jobs', '${biz.totalJobs}'),
                  _buildStatPill('Active Jobs', '${biz.activeJobs}', color: AppColors.primary),
                  _buildStatPill('Hired Techs', '${biz.hiredTechnicians}', color: AppColors.success),
                  _buildStatPill('Applications', '${biz.applicationsReceived}'),
                ],
              ),
            ),
            const Divider(height: 20),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reg: ${biz.registrationNumber}',
                  style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.textMuted),
                ),
                Row(
                  children: [
                    if (biz.verificationStatus == VerificationStatus.pending) ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () async {
                          final confirm = await ConfirmDialog.show(
                            context,
                            title: 'Verify Business',
                            message: 'Verify ${biz.businessName}?',
                            confirmText: 'Verify',
                          );
                          if (confirm == true) {
                            await provider.verifyBusiness(biz.id);
                          }
                        },
                        child: const Text('Verify', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BusinessDetailScreen(businessId: biz.id),
                        ),
                      ),
                      child: const Text('View Entity', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatPill(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w700, color: color ?? AppColors.textPrimary),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context, BusinessesProvider provider) {
    final cities = ['All Cities', 'Chennai', 'Bengaluru', 'Coimbatore', 'Madurai', 'Trichy', 'Hyderabad'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Businesses by Location',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cities.map((city) {
                final isSel = provider.cityFilter == city;
                return ChoiceChip(
                  label: Text(city),
                  selected: isSel,
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSel ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      provider.setCityFilter(city);
                      Navigator.of(ctx).pop();
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
