import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';

class FilterBottomSheet extends StatefulWidget {
  final String currentCity;
  final String? currentAcType;
  final String? currentBrand;
  final String? currentService;
  final String currentEmploymentType;
  final int? currentMinSalary;
  final Function({
    required String city,
    required String? acType,
    required String? brand,
    required String? service,
    required String employmentType,
    required int? minSalary,
  }) onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentCity,
    required this.currentAcType,
    required this.currentBrand,
    required this.currentService,
    required this.currentEmploymentType,
    required this.currentMinSalary,
    required this.onApply,
  });

  static void show(
    BuildContext context, {
    required String currentCity,
    required String? currentAcType,
    required String? currentBrand,
    required String? currentService,
    required String currentEmploymentType,
    required int? currentMinSalary,
    required Function({
      required String city,
      required String? acType,
      required String? brand,
      required String? service,
      required String employmentType,
      required int? minSalary,
    }) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => FilterBottomSheet(
        currentCity: currentCity,
        currentAcType: currentAcType,
        currentBrand: currentBrand,
        currentService: currentService,
        currentEmploymentType: currentEmploymentType,
        currentMinSalary: currentMinSalary,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedCity;
  late String? _selectedAcType;
  late String? _selectedBrand;
  late String? _selectedService;
  late String _selectedEmploymentType;
  late double _minSalarySlider;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.currentCity;
    _selectedAcType = widget.currentAcType;
    _selectedBrand = widget.currentBrand;
    _selectedService = widget.currentService;
    _selectedEmploymentType = widget.currentEmploymentType;
    _minSalarySlider = (widget.currentMinSalary ?? 15000).toDouble();
  }

  int get _activeCount {
    var count = 0;
    if (_selectedCity != 'All Cities') count++;
    if (_selectedAcType != null && _selectedAcType!.isNotEmpty) count++;
    if (_selectedBrand != null && _selectedBrand!.isNotEmpty) count++;
    if (_selectedService != null && _selectedService!.isNotEmpty) count++;
    if (_selectedEmploymentType != 'All Types') count++;
    if (_minSalarySlider > 15000) count++;
    return count;
  }

  void _reset() {
    setState(() {
      _selectedCity = 'All Cities';
      _selectedAcType = null;
      _selectedBrand = null;
      _selectedService = null;
      _selectedEmploymentType = 'All Types';
      _minSalarySlider = 15000;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Filter Jobs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (_activeCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$_activeCount active',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  TextButton(
                    onPressed: _reset,
                    child: const Text('Reset All', style: TextStyle(color: AppTheme.error)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Filter Options
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // City Filter
                  const Text('Preferred City / Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All Cities', ...AppConstants.indianCities].map((city) {
                      final isSelected = _selectedCity == city;
                      return FilterChip(
                        label: Text(city),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCity = city),
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // AC Type Filter
                  const Text('AC Specialization Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.acTypes.map((type) {
                      final isSelected = _selectedAcType == type;
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) => setState(() => _selectedAcType = selected ? type : null),
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Brand Expertise Filter
                  const Text('Brand Experience', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppConstants.brands.take(8).map((brand) {
                      final isSelected = _selectedBrand == brand;
                      return FilterChip(
                        label: Text(brand),
                        selected: isSelected,
                        onSelected: (selected) => setState(() => _selectedBrand = selected ? brand : null),
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Employment Type Filter
                  const Text('Employment Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['All Types', ...AppConstants.employmentTypes].map((type) {
                      final isSelected = _selectedEmploymentType == type;
                      return FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedEmploymentType = type),
                        selectedColor: AppTheme.primaryLight,
                        checkmarkColor: AppTheme.primary,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Min Salary Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Minimum Monthly Salary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(
                        Formatters.formatCurrency(_minSalarySlider.toInt()),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: _minSalarySlider,
                    min: 15000,
                    max: 60000,
                    divisions: 9,
                    label: Formatters.formatCurrency(_minSalarySlider.toInt()),
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _minSalarySlider = val),
                  ),
                ],
              ),
            ),

            // Apply Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
              ),
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    city: _selectedCity,
                    acType: _selectedAcType,
                    brand: _selectedBrand,
                    service: _selectedService,
                    employmentType: _selectedEmploymentType,
                    minSalary: _minSalarySlider > 15000 ? _minSalarySlider.toInt() : null,
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Show Results ($_activeCount filters)'),
              ),
            ),
          ],
        );
      },
    );
  }
}
