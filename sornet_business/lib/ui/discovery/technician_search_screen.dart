import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/sornet_search_bar.dart';
import '../common/filter_bottom_sheet.dart';
import 'technician_detail_screen.dart';
import 'technician_comparison_screen.dart';

class TechnicianSearchScreen extends StatefulWidget {
  const TechnicianSearchScreen({super.key});

  @override
  State<TechnicianSearchScreen> createState() => _TechnicianSearchScreenState();
}

class _TechnicianSearchScreenState extends State<TechnicianSearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterSheet(BuildContext context, TechnicianProvider techProvider) {
    FilterBottomSheet.show(
      context,
      initialCity: techProvider.selectedCity,
      initialMinExperience: techProvider.minExperience,
      initialMinRating: techProvider.minRating,
      initialVerifiedOnly: techProvider.verifiedOnly,
      initialAcTypes: techProvider.selectedAcTypes,
      initialBrands: techProvider.selectedBrands,
      initialServices: techProvider.selectedServices,
      onApply: ({
        required city,
        required minExperience,
        required minRating,
        required verifiedOnly,
        required acTypes,
        required brands,
        required services,
      }) {
        techProvider.applyFilters(
          city: city,
          minExperience: minExperience,
          minRating: minRating,
          verifiedOnly: verifiedOnly,
          acTypes: acTypes,
          brands: brands,
          services: services,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final techProvider = context.watch<TechnicianProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Find Technicians'),
        actions: [
          if (techProvider.selectedForComparison.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TechnicianComparisonScreen(
                      technicians: techProvider.selectedForComparison,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.compare_arrows_rounded, size: 18),
              label: Text('Compare (${techProvider.selectedForComparison.length})'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Filter trigger
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SornetSearchBar(
              controller: _searchController,
              hintText: 'Search by technician, brand, skill, city...',
              activeFilterCount: techProvider.activeFilterCount,
              onChanged: techProvider.setSearchQuery,
              onClear: () => techProvider.setSearchQuery(''),
              onFilterTap: () => _openFilterSheet(context, techProvider),
            ),
          ),

          // Sorting & Active Filters Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildSortChip('Recommended', techProvider),
                  const SizedBox(width: 8),
                  _buildSortChip('Experience', techProvider),
                  const SizedBox(width: 8),
                  _buildSortChip('Rating', techProvider),
                  const SizedBox(width: 8),
                  _buildSortChip('Trust Score', techProvider),
                  const SizedBox(width: 8),
                  _buildSortChip('Salary (Low to High)', techProvider),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Technician Results List
          Expanded(
            child: techProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : techProvider.technicians.isEmpty
                    ? EmptyState(
                        icon: Icons.person_search_rounded,
                        title: 'No Technicians Found',
                        message: 'Try adjusting your search criteria or clearing filters.',
                        buttonText: 'Reset Filters',
                        onButtonPressed: techProvider.resetFilters,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: techProvider.technicians.length,
                        itemBuilder: (context, index) {
                          final tech = techProvider.technicians[index];
                          return _buildTechnicianDiscoveryCard(context, tech, techProvider);
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: techProvider.selectedForComparison.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: const Border(top: BorderSide(color: AppTheme.border)),
                boxShadow: AppTheme.activeShadow,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${techProvider.selectedForComparison.length} Candidates Selected',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        const Text(
                          'Compare skills, ratings & expected rates',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TechnicianComparisonScreen(
                            technicians: techProvider.selectedForComparison,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                    label: const Text('Compare Candidates'),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSortChip(String label, TechnicianProvider provider) {
    final isSelected = provider.sortBy == label;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: AppTheme.primaryLight,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 12,
      ),
      side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
      onSelected: (val) {
        if (val) provider.setSortBy(label);
      },
    );
  }

  Widget _buildTechnicianDiscoveryCard(BuildContext context, Technician tech, TechnicianProvider provider) {
    final isCompared = provider.isCandidateSelectedForComparison(tech.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompared ? AppTheme.primary : AppTheme.border,
          width: isCompared ? 1.8 : 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: tech)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        tech.name.isNotEmpty ? tech.name[0] : 'T',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  tech.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (tech.isVerified)
                                const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 16),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: AppTheme.textTertiary),
                              const SizedBox(width: 2),
                              Text(
                                '${tech.city} (${tech.experienceYears} Yrs Exp)',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                              const SizedBox(width: 2),
                              Text(
                                '${tech.rating} (${tech.reviewsCount} reviews)',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        StatusBadge.trustScore(tech.trustScore),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.successBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tech.availability,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.successText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // AC Expertise & Brand Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...tech.acExpertise.take(3).map((ac) => _buildChipPill(ac, AppTheme.primaryLight, AppTheme.primary)),
                    ...tech.brands.take(3).map((b) => _buildChipPill(b, AppTheme.surfaceMuted, AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),

                // Rate and Quick CTAs
                const Divider(height: 1, color: AppTheme.borderLight),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Expected Rate', style: TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
                        Text(
                          '${Formatters.formatCurrency(tech.expectedSalaryMonthly)} / mo',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Compare checkbox button
                        IconButton(
                          icon: Icon(
                            isCompared ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                            color: isCompared ? AppTheme.primary : AppTheme.textTertiary,
                            size: 22,
                          ),
                          tooltip: 'Compare Candidate',
                          onPressed: () {
                            provider.toggleComparisonCandidate(tech);
                          },
                        ),
                        // Shortlist button
                        IconButton(
                          icon: Icon(
                            tech.isShortlisted ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: tech.isShortlisted ? AppTheme.purple : AppTheme.textTertiary,
                            size: 24,
                          ),
                          tooltip: 'Shortlist Candidate',
                          onPressed: () {
                            provider.toggleShortlist(tech.id);
                          },
                        ),
                        const SizedBox(width: 4),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: tech)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          child: const Text('View Profile'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChipPill(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}
