import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import 'job_preview_screen.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _titleController = TextEditingController(text: 'Senior Inverter AC Service Specialist');
  String _selectedCategory = 'AC Technician';
  String _selectedExperience = '3–5 Years';
  String _selectedTechType = 'Full Time';

  final List<String> _selectedSkills = ['Split AC', 'Cassette AC', 'Window AC'];
  final List<String> _selectedInverterExpertise = ['Inverter', 'Dual Inverter'];
  final List<String> _selectedBrands = ['Daikin', 'LG', 'Voltas', 'Samsung'];
  final List<String> _selectedServices = [
    'Installation',
    'Gas Charging',
    'PCB Repair',
    'Leakage Repair',
    'General Servicing',
  ];

  String _selectedCity = 'Chennai';
  final _locationController = TextEditingController(text: 'Anna Salai & OMR Corridor, Chennai');
  final _minSalaryController = TextEditingController(text: '25000');
  final _maxSalaryController = TextEditingController(text: '32000');
  String _salaryPeriod = 'month';
  int _positionsCount = 3;
  DateTime _joiningDate = DateTime.now().add(const Duration(days: 10));
  final _workingHoursController = TextEditingController(text: '9:00 AM – 6:00 PM (Mon–Sat)');
  final _descriptionController = TextEditingController(
    text:
        'Looking for experienced AC technicians proficient in residential and commercial inverter split/cassette systems, PCB diagnostics, chemical foam washing, and gas charging.',
  );
  final List<String> _selectedBenefits = [
    'ESI & Provident Fund (PF)',
    'Fuel Allowance (₹3,500/mo)',
    'Overtime & Incentive Pay',
    'Company Toolkit & Safety Gear',
  ];
  final _additionalReqController = TextEditingController(
    text: 'Must have two-wheeler with valid driving license and own Android smartphone.',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _workingHoursController.dispose();
    _descriptionController.dispose();
    _additionalReqController.dispose();
    super.dispose();
  }

  void _previewJob() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a job title')),
      );
      return;
    }

    final minSal = int.tryParse(_minSalaryController.text.replaceAll(RegExp(r'\D'), '')) ?? 20000;
    final maxSal = int.tryParse(_maxSalaryController.text.replaceAll(RegExp(r'\D'), '')) ?? 25000;

    final job = Job(
      id: 'job-${DateTime.now().millisecondsSinceEpoch}',
      businessId: 'biz-101',
      businessName: 'CoolFlow Air Conditioning & Facility Services',
      businessLogo: 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=150',
      title: _titleController.text.trim(),
      category: _selectedCategory,
      experienceRequired: _selectedExperience,
      technicianType: _selectedTechType,
      skillsRequired: _selectedSkills,
      technicalExpertise: _selectedInverterExpertise,
      brands: _selectedBrands,
      requiredServices: _selectedServices,
      location: _locationController.text.trim(),
      city: _selectedCity,
      minSalary: minSal,
      maxSalary: maxSal,
      salaryPeriod: _salaryPeriod,
      positionsCount: _positionsCount,
      joiningDate: _joiningDate,
      workingHours: _workingHoursController.text.trim(),
      description: _descriptionController.text.trim(),
      benefits: _selectedBenefits,
      additionalRequirements: _additionalReqController.text.trim(),
      status: JobStatus.active,
      postedDate: DateTime.now(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => JobPreviewScreen(job: job)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Post Technician Requirement'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionCard(
                      title: '1. Role & Category',
                      icon: Icons.work_outline_rounded,
                      children: [
                        _buildLabel('Job Title *'),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(hintText: 'e.g. AC Service Technician'),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Category *'),
                        _buildDropdown(
                          value: _selectedCategory,
                          items: ['AC Technician', 'Commercial HVAC', 'Facility Management', 'Appliance Repair'],
                          onChanged: (val) => setState(() => _selectedCategory = val!),
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Experience *'),
                                  _buildDropdown(
                                    value: _selectedExperience,
                                    items: AppConstants.experienceRanges,
                                    onChanged: (val) => setState(() => _selectedExperience = val!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Employment Type *'),
                                  _buildDropdown(
                                    value: _selectedTechType,
                                    items: AppConstants.technicianTypes,
                                    onChanged: (val) => setState(() => _selectedTechType = val!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '2. Skills & AC Systems',
                      icon: Icons.build_outlined,
                      children: [
                        _buildLabel('AC Systems Required *'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppConstants.acTypes.map((type) {
                            final isSelected = _selectedSkills.contains(type);
                            return FilterChip(
                              selected: isSelected,
                              label: Text(type),
                              selectedColor: AppTheme.primaryLight,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedSkills.add(type);
                                  } else {
                                    _selectedSkills.remove(type);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Inverter Technology Expertise'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppConstants.inverterTypes.map((inv) {
                            final isSelected = _selectedInverterExpertise.contains(inv);
                            return FilterChip(
                              selected: isSelected,
                              label: Text(inv),
                              selectedColor: AppTheme.primaryLight,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedInverterExpertise.add(inv);
                                  } else {
                                    _selectedInverterExpertise.remove(inv);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Target AC Brands'),
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
                              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
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
                        const SizedBox(height: 16),

                        _buildLabel('Required Service Capabilities'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppConstants.requiredServices.map((srv) {
                            final isSelected = _selectedServices.contains(srv);
                            return FilterChip(
                              selected: isSelected,
                              label: Text(srv),
                              selectedColor: AppTheme.primaryLight,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedServices.add(srv);
                                  } else {
                                    _selectedServices.remove(srv);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '3. Location & Compensation',
                      icon: Icons.payments_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('City *'),
                                  _buildDropdown(
                                    value: _selectedCity,
                                    items: AppConstants.indianCities,
                                    onChanged: (val) => setState(() => _selectedCity = val!),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Detailed Work Area *'),
                                  TextField(
                                    controller: _locationController,
                                    decoration: const InputDecoration(hintText: 'e.g. Anna Salai & OMR'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Min Salary (₹) *'),
                                  TextField(
                                    controller: _minSalaryController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(hintText: '25000'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Max Salary (₹) *'),
                                  TextField(
                                    controller: _maxSalaryController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(hintText: '32000'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Period'),
                                  _buildDropdown(
                                    value: _salaryPeriod,
                                    items: ['month', 'day'],
                                    onChanged: (val) => setState(() => _salaryPeriod = val!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('Open Positions: $_positionsCount'),
                                  Slider(
                                    value: _positionsCount.toDouble(),
                                    min: 1,
                                    max: 20,
                                    divisions: 19,
                                    activeColor: AppTheme.primary,
                                    label: '$_positionsCount Techs',
                                    onChanged: (val) => setState(() => _positionsCount = val.round()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Expected Joining Date'),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _joiningDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (picked != null) setState(() => _joiningDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Formatters.formatDate(_joiningDate), style: const TextStyle(fontWeight: FontWeight.w600)),
                                const Icon(Icons.calendar_today_rounded, color: AppTheme.primary, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Working Hours'),
                        TextField(
                          controller: _workingHoursController,
                          decoration: const InputDecoration(hintText: 'e.g. 9:00 AM – 6:00 PM (Mon–Sat)'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildSectionCard(
                      title: '4. Description & Benefits',
                      icon: Icons.description_outlined,
                      children: [
                        _buildLabel('Job Description *'),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Describe key day-to-day responsibilities...',
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Benefits & Perks Provided'),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'ESI & Provident Fund (PF)',
                            'Fuel Allowance (₹3,500/mo)',
                            'Overtime & Incentive Pay',
                            'Company Toolkit & Safety Gear',
                            'Health Insurance for Family',
                            'Daily Meal Allowance',
                          ].map((b) {
                            final isSelected = _selectedBenefits.contains(b);
                            return FilterChip(
                              selected: isSelected,
                              label: Text(b),
                              selectedColor: AppTheme.primaryLight,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: 12,
                              ),
                              side: BorderSide(color: isSelected ? AppTheme.primary : AppTheme.border),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedBenefits.add(b);
                                  } else {
                                    _selectedBenefits.remove(b);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('Additional Requirements'),
                        TextField(
                          controller: _additionalReqController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'e.g. Two wheeler mandatory, ITI certificate preferred',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Preview & Publish CTA Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _previewJob,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Preview Job Requirement', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          items: items.map((i) {
            return DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
      ),
    );
  }
}
