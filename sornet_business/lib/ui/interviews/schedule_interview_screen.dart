import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../data/models/job.dart';
import '../../data/models/interview.dart';
import '../../providers/interview_provider.dart';
import '../../providers/dashboard_provider.dart';

class ScheduleInterviewScreen extends StatefulWidget {
  final Technician technician;
  final Job job;

  const ScheduleInterviewScreen({
    super.key,
    required this.technician,
    required this.job,
  });

  @override
  State<ScheduleInterviewScreen> createState() => _ScheduleInterviewScreenState();
}

class _ScheduleInterviewScreenState extends State<ScheduleInterviewScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 15, minute: 0);
  InterviewType _selectedType = InterviewType.videoCall;
  final _linkOrLocationController = TextEditingController(text: 'https://meet.google.com/sor-net-interview');
  final _notesController = TextEditingController(
    text: 'Technical discussion focusing on inverter split & cassette diagnostics and past field experience.',
  );
  int _durationMinutes = 30;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _linkOrLocationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() => _isSubmitting = true);
    final interviewProvider = context.read<InterviewProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    final fullDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    await interviewProvider.scheduleNewInterview(
      technicianId: widget.technician.id,
      technicianName: widget.technician.name,
      technicianPhoto: widget.technician.photoUrl,
      technicianPhone: widget.technician.phone,
      jobId: widget.job.id,
      jobTitle: widget.job.title,
      scheduledAt: fullDateTime,
      durationMinutes: _durationMinutes,
      type: _selectedType,
      locationOrLink: _linkOrLocationController.text.trim(),
      notes: _notesController.text.trim(),
    );

    await dashboardProvider.loadDashboardData();

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Interview successfully scheduled with ${widget.technician.name}!'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Schedule Interview'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Candidate & Job Header
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
                          const SizedBox(height: 2),
                          Text(
                            'Applying for: ${widget.job.title}',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${widget.technician.city} • ${widget.technician.experienceYears} Yrs Exp',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Date & Time Selection
              _buildSectionCard(
                title: 'Date & Time',
                icon: Icons.calendar_today_rounded,
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Date Picker
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 60)),
                              );
                              if (picked != null) setState(() => _selectedDate = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Interview Date', style: TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
                                  const SizedBox(height: 4),
                                  Text(
                                    Formatters.formatDate(_selectedDate),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Time Picker
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _selectedTime,
                              );
                              if (picked != null) setState(() => _selectedTime = picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Interview Time', style: TextStyle(fontSize: 11, color: AppTheme.textTertiary)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedTime.format(context),
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Duration Chips
                    Row(
                      children: [
                        const Text('Duration: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        ...[15, 30, 45, 60].map((mins) {
                          final isSelected = _durationMinutes == mins;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              selected: isSelected,
                              label: Text('$mins min'),
                              selectedColor: AppTheme.primaryLight,
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 11,
                              ),
                              onSelected: (val) {
                                if (val) setState(() => _durationMinutes = mins);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Interview Type
              _buildSectionCard(
                title: 'Interview Mode',
                icon: Icons.video_camera_front_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildTypeChip('Video Call', InterviewType.videoCall, Icons.videocam_rounded),
                        const SizedBox(width: 8),
                        _buildTypeChip('Phone Call', InterviewType.phoneCall, Icons.phone_in_talk_rounded),
                        const SizedBox(width: 8),
                        _buildTypeChip('In Person', InterviewType.inPerson, Icons.business_rounded),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _buildLabel(_selectedType == InterviewType.videoCall
                        ? 'Meeting Link (Google Meet / Zoom) *'
                        : _selectedType == InterviewType.phoneCall
                            ? 'Contact Phone Number *'
                            : 'Office / Facility Location *'),
                    TextField(
                      controller: _linkOrLocationController,
                      decoration: InputDecoration(
                        hintText: _selectedType == InterviewType.videoCall
                            ? 'https://meet.google.com/...'
                            : _selectedType == InterviewType.phoneCall
                                ? widget.technician.phone
                                : 'Company Address / Office Room',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notes & Agenda
              _buildSectionCard(
                title: 'Agenda & Discussion Notes',
                icon: Icons.notes_rounded,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Notes for Candidate'),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Add topics to be covered during the interview...',
                      ),
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
            onPressed: _isSubmitting ? null : _submit,
            icon: _isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)))
                : const Icon(Icons.event_available_rounded, size: 18),
            label: const Text('Schedule Interview', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, InterviewType type, IconData icon) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedType = type;
              if (type == InterviewType.phoneCall) {
                _linkOrLocationController.text = widget.technician.phone;
              } else if (type == InterviewType.inPerson) {
                _linkOrLocationController.text = 'CoolFlow HQ, No. 42 Anna Salai, Chennai';
              } else {
                _linkOrLocationController.text = 'https://meet.google.com/sor-net-interview';
              }
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryLight : AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border),
            ),
            child: Column(
              children: [
                Icon(icon, size: 18, color: isSelected ? AppTheme.primary : AppTheme.textSecondary),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
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
