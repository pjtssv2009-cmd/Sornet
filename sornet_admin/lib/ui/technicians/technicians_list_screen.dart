import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../providers/sornet_providers.dart';
import '../common/status_badge.dart';
import '../common/sornet_search_bar.dart';
import '../common/empty_state.dart';
import '../common/shimmer_loading.dart';
import '../common/confirm_dialog.dart';
import 'technician_detail_screen.dart';

class TechniciansListScreen extends StatefulWidget {
  final VerificationStatus? initialFilter;
  final bool showAppBar;
  const TechniciansListScreen({super.key, this.initialFilter, this.showAppBar = true});

  @override
  State<TechniciansListScreen> createState() => _TechniciansListScreenState();
}

class _TechniciansListScreenState extends State<TechniciansListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TechniciansProvider>(context, listen: false);
      if (widget.initialFilter != null) {
        provider.setStatusFilter(widget.initialFilter);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TechniciansProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: const Text('Technician Management'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => provider.loadTechnicians(),
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
                      hintText: 'Search technician name, phone, email, skill...',
                      controller: _searchController,
                      onChanged: (val) => provider.setSearchQuery(val),
                      hasActiveFilters: provider.cityFilter != 'All Cities',
                      onFilterTap: () => _showFilterBottomSheet(context, provider),
                    ),
                    const SizedBox(height: 12),
                    // Status Filter Chips Carousel
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'All (${provider.technicians.length})',
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

              // Technicians List
              Expanded(
                child: provider.isLoading && provider.technicians.isEmpty
                    ? const ListShimmerLoading(itemCount: 6)
                    : provider.technicians.isEmpty
                        ? EmptyState(
                            icon: Icons.engineering_outlined,
                            title: 'No Technicians Found',
                            description: 'No technician profiles match your current search and filter criteria.',
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
                            onRefresh: () => provider.loadTechnicians(),
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: provider.technicians.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final tech = provider.technicians[index];
                                return _buildTechnicianCard(context, tech, provider);
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

  Widget _buildTechnicianCard(BuildContext context, Technician tech, TechniciansProvider provider) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TechnicianDetailScreen(technicianId: tech.id),
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
                // Avatar with initial or image
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: tech.profilePhoto.isNotEmpty ? NetworkImage(tech.profilePhoto) : null,
                  child: tech.profilePhoto.isEmpty
                      ? Text(
                          tech.name.isNotEmpty ? tech.name[0] : 'T',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Name & details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              tech.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          StatusBadge.fromVerificationStatus(tech.verificationStatus, isSmall: true),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${tech.primarySkill} • ${tech.yearsExperience} Years Exp',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 3),
                          Text(
                            tech.city,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 2),
                          Text(
                            '${tech.rating} (${tech.reviewCount})',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // AC Expertise Chips
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: tech.acExpertise.take(3).map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 20),
            // Card Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Trust: ${tech.trustScore}%',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: tech.trustScore >= 80 ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (tech.verificationStatus == VerificationStatus.pending) ...[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () => _quickVerifyTechnician(context, tech, provider),
                        child: const Text('Verify', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TechnicianDetailScreen(technicianId: tech.id),
                        ),
                      ),
                      child: const Text('View Profile', style: TextStyle(fontSize: 12)),
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

  void _quickVerifyTechnician(BuildContext context, Technician tech, TechniciansProvider provider) async {
    final confirm = await ConfirmDialog.show(
      context,
      title: 'Approve & Verify Technician',
      message: 'Are you sure you want to verify ${tech.name}? Their profile will be marked verified across the marketplace.',
      confirmText: 'Verify Profile',
    );

    if (confirm == true) {
      await provider.verifyTechnician(tech.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tech.name} verified successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _showFilterBottomSheet(BuildContext context, TechniciansProvider provider) {
    final cities = ['All Cities', 'Chennai', 'Bengaluru', 'Coimbatore', 'Madurai', 'Trichy', 'Thanjavur', 'Hyderabad'];
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
                  'Filter Technicians by City',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
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
