import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/interview.dart';
import '../../providers/interview_provider.dart';
import '../common/status_badge.dart';
import '../messaging/chat_conversation_screen.dart';

class InterviewDetailScreen extends StatefulWidget {
  final String? interviewId;
  final Interview? interview;

  const InterviewDetailScreen({
    super.key,
    this.interviewId,
    this.interview,
  });

  @override
  State<InterviewDetailScreen> createState() => _InterviewDetailScreenState();
}

class _InterviewDetailScreenState extends State<InterviewDetailScreen> {
  final TextEditingController _rescheduleReasonController =
      TextEditingController();
  final TextEditingController _cancelReasonController =
      TextEditingController();
  DateTime? _selectedRescheduleDate;
  TimeOfDay? _selectedRescheduleTime;

  @override
  void dispose() {
    _rescheduleReasonController.dispose();
    _cancelReasonController.dispose();
    super.dispose();
  }

  void _showRescheduleBottomSheet(Interview interview) {
    _selectedRescheduleDate =
        interview.scheduledAt.add(const Duration(days: 1));
    _selectedRescheduleTime = TimeOfDay.fromDateTime(interview.scheduledAt);
    _rescheduleReasonController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Request Reschedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Propose a new date & time for your interview with the employer.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Proposed Date & Time',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedRescheduleDate ??
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null) {
                            setModalState(() {
                              _selectedRescheduleDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month_rounded, size: 16),
                        label: Text(
                          _selectedRescheduleDate != null
                              ? Formatters.formatDate(_selectedRescheduleDate!)
                              : 'Select Date',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedRescheduleTime ??
                                const TimeOfDay(hour: 10, minute: 0),
                          );
                          if (picked != null) {
                            setModalState(() {
                              _selectedRescheduleTime = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time_rounded, size: 16),
                        label: Text(
                          _selectedRescheduleTime != null
                              ? _selectedRescheduleTime!.format(context)
                              : 'Select Time',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reason for Reschedule',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _rescheduleReasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Prior customer service commitment at current site...',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedRescheduleDate == null ||
                          _selectedRescheduleTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select date and time')),
                        );
                        return;
                      }
                      final finalDateTime = DateTime(
                        _selectedRescheduleDate!.year,
                        _selectedRescheduleDate!.month,
                        _selectedRescheduleDate!.day,
                        _selectedRescheduleTime!.hour,
                        _selectedRescheduleTime!.minute,
                      );
                      Provider.of<InterviewProvider>(context, listen: false)
                          .rescheduleInterview(
                        interview.id,
                        finalDateTime,
                        _rescheduleReasonController.text.trim(),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Reschedule request submitted successfully!'),
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      );
                    },
                    child: const Text('Send Reschedule Request'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog(Interview interview) {
    _cancelReasonController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Interview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to cancel this interview? This cannot be undone.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cancelReasonController,
              decoration: const InputDecoration(
                hintText: 'Reason for cancellation (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Interview'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<InterviewProvider>(context, listen: false)
                  .cancelInterview(
                interview.id,
                _cancelReasonController.text.trim().isEmpty
                    ? 'Cancelled by technician'
                    : _cancelReasonController.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Interview has been cancelled'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel Interview'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final interviewProvider =
        Provider.of<InterviewProvider>(context);
    final targetId = widget.interview?.id ?? widget.interviewId ?? '';
    final interview = interviewProvider.getInterviewById(targetId) ?? widget.interview;

    if (interview == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Interview Details')),
        body: const Center(child: Text('Interview not found')),
      );
    }

    final isUpcoming = interview.status == InterviewStatus.scheduled ||
        interview.status == InterviewStatus.rescheduled;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Interview Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            tooltip: 'Message Business',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatConversationScreen(
                    businessId: interview.businessId,
                    businessName: interview.businessName,
                    jobTitle: interview.jobTitle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            interview.type == InterviewType.video
                                ? Icons.videocam_rounded
                                : interview.type == InterviewType.phone
                                    ? Icons.phone_in_talk_rounded
                                    : Icons.business_rounded,
                            color: AppTheme.primaryBlue,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                interview.jobTitle,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                interview.businessName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StatusBadge(
                          text: interview.status.label,
                          color: Color(interview.status.badgeColorValue),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _buildInfoRow(
                      Icons.calendar_today_rounded,
                      'Date & Time',
                      Formatters.formatDateTime(interview.scheduledAt),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.timer_outlined,
                      'Duration',
                      '${interview.durationMinutes} Minutes',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.category_outlined,
                      'Format',
                      interview.type.label,
                    ),
                    if (interview.interviewerName != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.person_outline,
                        'Interviewer',
                        '${interview.interviewerName} (${interview.interviewerRole ?? "Hiring Manager"})',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Video/Location Card
            if (interview.type == InterviewType.video &&
                interview.meetingLink != null)
              Card(
                color: AppTheme.primaryLight.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.videocam_rounded,
                              color: AppTheme.primaryBlue),
                          const SizedBox(width: 8),
                          const Text(
                            'Video Conference Link',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        interview.meetingLink!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (interview.meetingPassword != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Passcode: ${interview.meetingPassword}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                      if (isUpcoming) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Connecting to secure video call: ${interview.meetingLink}'),
                                  backgroundColor: AppTheme.primaryBlue,
                                ),
                              );
                            },
                            icon: const Icon(Icons.launch_rounded, size: 18),
                            label: const Text('Join Video Call Now'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            if (interview.type == InterviewType.inPerson &&
                interview.locationAddress != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: AppTheme.accentOrange),
                          const SizedBox(width: 8),
                          const Text(
                            'In-Person Interview Venue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        interview.locationAddress!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (interview.instructions != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preparation & Instructions',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        interview.instructions!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (interview.feedbackNotes != null) ...[
              const SizedBox(height: 16),
              Card(
                color: AppTheme.accentGreen.withValues(alpha: 0.08),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: AppTheme.accentGreen, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Interview Feedback',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        interview.feedbackNotes!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textDark,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (isUpcoming) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showRescheduleBottomSheet(interview),
                      icon: const Icon(Icons.edit_calendar_rounded, size: 16),
                      label: const Text('Reschedule'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(interview),
                      icon: const Icon(Icons.cancel_outlined,
                          size: 16, color: AppTheme.accentRed),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.accentRed),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentRed),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.textMuted),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
