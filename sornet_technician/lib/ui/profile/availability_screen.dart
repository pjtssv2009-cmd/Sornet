import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_profile_provider.dart';

class AvailabilityScreen extends StatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  late AvailabilityStatus _status;
  late TextEditingController _minSalaryController;
  late TextEditingController _maxSalaryController;
  late TextEditingController _salaryPeriodController;
  late bool _willingToRelocate;
  late bool _immediateJoining;
  late List<String> _preferredLocations;

  @override
  void initState() {
    super.initState();
    final technician =
        Provider.of<TechnicianProfileProvider>(context, listen: false)
            .technician;
    final avail = technician?.availability ??
        TechnicianAvailability(
          statusEnum: AvailabilityStatus.activelyLooking,
          preferredLocations: ['Chennai', 'Coimbatore'],
          minSalary: 25000,
          maxSalary: 35000,
          salaryPeriod: 'monthly',
          willingToRelocate: true,
          immediateJoining: true,
        );
    _status = avail.status;
    _minSalaryController =
        TextEditingController(text: avail.minSalary.toInt().toString());
    _maxSalaryController =
        TextEditingController(text: avail.maxSalary.toInt().toString());
    _salaryPeriodController = TextEditingController(text: avail.salaryPeriod);
    _willingToRelocate = avail.willingToRelocate;
    _immediateJoining = avail.immediateJoining;
    _preferredLocations = List.from(avail.preferredLocations);
  }

  @override
  void dispose() {
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _salaryPeriodController.dispose();
    super.dispose();
  }

  void _saveAvailability() {
    final minSal = double.tryParse(_minSalaryController.text.trim()) ?? 25000;
    final maxSal = double.tryParse(_maxSalaryController.text.trim()) ?? 35000;

    final updated = TechnicianAvailability(
      statusEnum: _status,
      preferredLocations: _preferredLocations,
      minSalary: minSal,
      maxSalary: maxSal,
      salaryPeriod: _salaryPeriodController.text.trim(),
      willingToRelocate: _willingToRelocate,
      immediateJoining: _immediateJoining,
      availableFrom: DateTime.now(),
    );

    Provider.of<TechnicianProfileProvider>(context, listen: false)
        .updateAvailability(updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Availability settings updated successfully!'),
        backgroundColor: AppTheme.accentGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Availability & Preferences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status radio cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Job Search Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...AvailabilityStatus.values.map((status) {
                      return RadioListTile<AvailabilityStatus>(
                        contentPadding: EdgeInsets.zero,
                        value: status,
                        groupValue: _status,
                        activeColor: AppTheme.primaryBlue,
                        title: Text(
                          status.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        subtitle: Text(
                          status == AvailabilityStatus.activelyLooking
                              ? 'Visible to businesses seeking urgent hires'
                              : status == AvailabilityStatus.availableForContracts
                                  ? 'Open for short-term project / contract work'
                                  : 'Not looking for new opportunities currently',
                          style: const TextStyle(
                              fontSize: 12, color: AppTheme.textMuted),
                        ),
                        onChanged: (val) {
                          if (val != null) setState(() => _status = val);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Salary Expectations
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Salary Expectations (INR)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Minimum (₹)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _minSalaryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixText: '₹ ',
                                  hintText: '25000',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Expected (₹)',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _maxSalaryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  prefixText: '₹ ',
                                  hintText: '35000',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Preferred Cities
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferred Work Locations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.popularCities.take(8).map((city) {
                        final isSelected = _preferredLocations.contains(city);
                        return FilterChip(
                          label: Text(city),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryLight,
                          checkmarkColor: AppTheme.primaryBlue,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.textDark,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _preferredLocations.add(city);
                              } else {
                                _preferredLocations.remove(city);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Toggles
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Immediate Joining Available',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Can join within 1-7 days of offer acceptance',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _immediateJoining,
                      activeColor: AppTheme.primaryBlue,
                      onChanged: (val) =>
                          setState(() => _immediateJoining = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text(
                        'Willing to Relocate',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        'Open for opportunities outside home city',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _willingToRelocate,
                      activeColor: AppTheme.primaryBlue,
                      onChanged: (val) =>
                          setState(() => _willingToRelocate = val),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAvailability,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save Preferences'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
