import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../data/models/job.dart';
import '../../providers/offer_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../common/confirm_dialog.dart';

class CreateOfferScreen extends StatefulWidget {
  final Technician technician;
  final Job job;

  const CreateOfferScreen({
    super.key,
    required this.technician,
    required this.job,
  });

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  late TextEditingController _positionController;
  late TextEditingController _salaryController;
  String _salaryPeriod = 'month';
  String _employmentType = 'Full Time';
  DateTime _joiningDate = DateTime.now().add(const Duration(days: 7));
  final _workingHoursController = TextEditingController(text: '9:00 AM – 6:00 PM (Mon–Sat)');
  late TextEditingController _locationController;
  final _termsController = TextEditingController(
    text: 'Probation period of 3 months. Standard company tools and branded uniform kit provided.',
  );
  final _messageController = TextEditingController(
    text: 'We were highly impressed with your technical capabilities and are excited to extend this formal offer!',
  );
  final List<String> _selectedBenefits = [
    'PF & ESI Statutory Benefits',
    'Monthly Fuel Allowance ₹3,500',
    'Overtime Payout (₹150/hr)',
    'Comprehensive Medical Insurance',
  ];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _positionController = TextEditingController(text: widget.job.title);
    _salaryController = TextEditingController(text: '${widget.technician.expectedSalaryMonthly}');
    _locationController = TextEditingController(text: '${widget.job.location}, ${widget.job.city}');
  }

  @override
  void dispose() {
    _positionController.dispose();
    _salaryController.dispose();
    _workingHoursController.dispose();
    _locationController.dispose();
    _termsController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendOffer() async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Send Hiring Offer?',
      message: 'Send formal job offer to ${widget.technician.name} for ${_positionController.text} at ₹${_salaryController.text}/$_salaryPeriod?',
      confirmText: 'Send Offer',
      confirmColor: AppTheme.primary,
      icon: Icons.send_rounded,
    );

    if (confirmed == true && mounted) {
      setState(() => _isSubmitting = true);
      final offerProvider = context.read<OfferProvider>();
      final dashboardProvider = context.read<DashboardProvider>();

      final salary = int.tryParse(_salaryController.text.replaceAll(RegExp(r'\D'), '')) ?? 25000;

      await offerProvider.createAndSendOffer(
        technicianId: widget.technician.id,
        technicianName: widget.technician.name,
        technicianPhoto: widget.technician.photoUrl,
        technicianPhone: widget.technician.phone,
        jobId: widget.job.id,
        jobTitle: widget.job.title,
        position: _positionController.text.trim(),
        salaryAmount: salary,
        salaryPeriod: _salaryPeriod,
        employmentType: _employmentType,
        joiningDate: _joiningDate,
        workingHours: _workingHoursController.text.trim(),
        location: _locationController.text.trim(),
        benefits: _selectedBenefits,
        additionalTerms: _termsController.text.trim(),
        personalMessage: _messageController.text.trim(),
      );

      await dashboardProvider.loadDashboardData();

      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Offer sent to ${widget.technician.name}!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Send Hiring Offer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Candidate Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        widget.technician.name.isNotEmpty ? widget.technician.name[0] : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.technician.name,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          Text(
                            'Job: ${widget.job.title}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Expected Rate: ${Formatters.formatCurrency(widget.technician.expectedSalaryMonthly)}/mo',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Offer Details
              _buildSectionCard(
                title: 'Offer Terms & Compensation',
                icon: Icons.payments_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Position Title *'),
                    TextField(
                      controller: _positionController,
                      decoration: const InputDecoration(hintText: 'e.g. Lead Inverter AC Technician'),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Offered Salary (₹) *'),
                              TextField(
                                controller: _salaryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(hintText: '28000'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Period'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.border, width: 1.2),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _salaryPeriod,
                                    isExpanded: true,
                                    items: ['month', 'day', 'job'].map((p) {
                                      return DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12)));
                                    }).toList(),
                                    onChanged: (val) => setState(() => _salaryPeriod = val!),
                                  ),
                                ),
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
                              _buildLabel('Employment Type *'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppTheme.border, width: 1.2),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _employmentType,
                                    isExpanded: true,
                                    items: ['Full Time', 'Contract', 'Freelance'].map((t) {
                                      return DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)));
                                    }).toList(),
                                    onChanged: (val) => setState(() => _employmentType = val!),
                                  ),
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
                              _buildLabel('Joining Date *'),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.border, width: 1.2),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(Formatters.formatDate(_joiningDate), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.primary),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Work Location / Facility *'),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(hintText: 'Workplace Address'),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Working Hours'),
                    TextField(
                      controller: _workingHoursController,
                      decoration: const InputDecoration(hintText: 'e.g. 9:00 AM – 6:00 PM'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Benefits & Terms
              _buildSectionCard(
                title: 'Benefits & Terms',
                icon: Icons.card_giftcard_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Included Perks'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'PF & ESI Statutory Benefits',
                        'Monthly Fuel Allowance ₹3,500',
                        'Overtime Payout (₹150/hr)',
                        'Comprehensive Medical Insurance',
                        'Annual Performance Bonus',
                        'Toolkit & Safety Kit',
                      ].map((b) {
                        final isSelected = _selectedBenefits.contains(b);
                        return FilterChip(
                          selected: isSelected,
                          label: Text(b),
                          selectedColor: AppTheme.primaryLight,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 11,
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
                    const SizedBox(height: 14),

                    _buildLabel('Additional Terms & Conditions'),
                    TextField(
                      controller: _termsController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'Probation, notice period, etc.'),
                    ),
                    const SizedBox(height: 14),

                    _buildLabel('Personal Note / Welcome Message'),
                    TextField(
                      controller: _messageController,
                      maxLines: 2,
                      decoration: const InputDecoration(hintText: 'A note to the candidate...'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _handleSendOffer,
            icon: _isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                : const Icon(Icons.send_rounded, size: 18),
            label: const Text('Send Formal Offer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 18),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
    );
  }
}
