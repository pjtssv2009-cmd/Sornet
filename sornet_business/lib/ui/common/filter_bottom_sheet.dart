import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class FilterBottomSheet extends StatefulWidget {
  final String initialCity;
  final double initialMinExperience;
  final double initialMinRating;
  final bool initialVerifiedOnly;
  final List<String> initialAcTypes;
  final List<String> initialBrands;
  final List<String> initialServices;
  final Function({
    required String city,
    required double minExperience,
    required double minRating,
    required bool verifiedOnly,
    required List<String> acTypes,
    required List<String> brands,
    required List<String> services,
  }) onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialCity,
    required this.initialMinExperience,
    required this.initialMinRating,
    required this.initialVerifiedOnly,
    required this.initialAcTypes,
    required this.initialBrands,
    required this.initialServices,
    required this.onApply,
  });

  static void show(
    BuildContext context, {
    required String initialCity,
    required double initialMinExperience,
    required double initialMinRating,
    required bool initialVerifiedOnly,
    required List<String> initialAcTypes,
    required List<String> initialBrands,
    required List<String> initialServices,
    required Function({
      required String city,
      required double minExperience,
      required double minRating,
      required bool verifiedOnly,
      required List<String> acTypes,
      required List<String> brands,
      required List<String> services,
    }) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FilterBottomSheet(
        initialCity: initialCity,
        initialMinExperience: initialMinExperience,
        initialMinRating: initialMinRating,
        initialVerifiedOnly: initialVerifiedOnly,
        initialAcTypes: initialAcTypes,
        initialBrands: initialBrands,
        initialServices: initialServices,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedCity;
  late double _minExperience;
  late double _minRating;
  late bool _verifiedOnly;
  late List<String> _selectedAcTypes;
  late List<String> _selectedBrands;
  late List<String> _selectedServices;

  final List<String> _cities = ['All Cities', ...AppConstants.indianCities];

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
    _minExperience = widget.initialMinExperience;
    _minRating = widget.initialMinRating;
    _verifiedOnly = widget.initialVerifiedOnly;
    _selectedAcTypes = List.from(widget.initialAcTypes);
    _selectedBrands = List.from(widget.initialBrands);
    _selectedServices = List.from(widget.initialServices);
  }

  void _reset() {
    setState(() {
      _selectedCity = 'All Cities';
      _minExperience = 0;
      _minRating = 0;
      _verifiedOnly = false;
      _selectedAcTypes.clear();
      _selectedBrands.clear();
      _selectedServices.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, color: AppTheme.primary, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Filter Technicians',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset All', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),

          // Scrollable Filter Sections
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // City Selection
                _buildSectionHeader('Operating Location / City'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _cities.map((city) {
                    final isSelected = _selectedCity == city;
                    return FilterChip(
                      selected: isSelected,
                      label: Text(city),
                      selectedColor: AppTheme.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: 1.2,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCity = city;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Verified Only Toggle
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Verified Technicians Only',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _verifiedOnly,
                        activeColor: AppTheme.primary,
                        onChanged: (val) {
                          setState(() {
                            _verifiedOnly = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Min Experience Slider
                _buildSectionHeader('Minimum Experience: ${_minExperience == 0 ? "Any Experience" : "${_minExperience.toStringAsFixed(0)}+ Years"}'),
                Slider(
                  value: _minExperience,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  activeColor: AppTheme.primary,
                  inactiveColor: AppTheme.border,
                  label: '${_minExperience.toStringAsFixed(0)} Yrs',
                  onChanged: (val) {
                    setState(() {
                      _minExperience = val;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Min Rating
                _buildSectionHeader('Minimum Rating: ${_minRating == 0 ? "Any Rating" : "${_minRating.toStringAsFixed(1)}+ Stars"}'),
                Row(
                  children: [0.0, 4.0, 4.5, 4.8].map((r) {
                    final isSelected = _minRating == r;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: isSelected,
                        label: Text(r == 0 ? 'All' : '$r★ & above'),
                        selectedColor: AppTheme.primaryLight,
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 12,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _minRating = r;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // AC Expertise Multiselect
                _buildSectionHeader('AC Systems Expertise'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.acTypes.map((type) {
                    final isSelected = _selectedAcTypes.contains(type);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(type),
                      selectedColor: AppTheme.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: 1.2,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAcTypes.add(type);
                          } else {
                            _selectedAcTypes.remove(type);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Brands Multiselect
                _buildSectionHeader('Brand Specialization'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.acBrands.map((brand) {
                    final isSelected = _selectedBrands.contains(brand);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(brand),
                      selectedColor: AppTheme.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: 1.2,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedBrands.add(brand);
                          } else {
                            _selectedBrands.remove(brand);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Required Services Multiselect
                _buildSectionHeader('Service Capabilities'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.requiredServices.map((service) {
                    final isSelected = _selectedServices.contains(service);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(service),
                      selectedColor: AppTheme.primaryLight,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: 1.2,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedServices.add(service);
                          } else {
                            _selectedServices.remove(service);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    city: _selectedCity,
                    minExperience: _minExperience,
                    minRating: _minRating,
                    verifiedOnly: _verifiedOnly,
                    acTypes: _selectedAcTypes,
                    brands: _selectedBrands,
                    services: _selectedServices,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Apply Filters', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}
