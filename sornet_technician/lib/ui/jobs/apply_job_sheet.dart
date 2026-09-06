import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/application_provider.dart';
import '../../providers/technician_profile_provider.dart';

class ApplyJobSheet extends StatefulWidget {
  final Job job;

  const ApplyJobSheet({super.key, required this.job});

  static void show(BuildContext context, Job job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ApplyJobSheet(job: job),
    );
  }

  @override
  State<ApplyJobSheet> createState() => _ApplyJobSheetState();
}

class _ApplyJobSheetState extends State<ApplyJobSheet> {
  late TextEditingController _expectedSalaryCtrl;
  final _coverNoteCtrl = TextEditingController();
  late String _availability;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<TechnicianProfileProvider>().technician;
    _expectedSalaryCtrl = TextEditingController(
      text: '${profile?.availability.expectedSalaryMonthly ?? widget.job.minSalary}',
    );
    _availability = profile?.availability.status.label ?? 'Immediately Available';
  }

  @override
  void dispose() {
    _expectedSalaryCtrl.dispose();
    _coverNoteCtrl.dispose();
    super.dispose();
  }

  void _submitApplication() async {
    final expected = int.tryParse(_expectedSalaryCtrl.text.trim()) ?? widget.job.minSalary;

    setState(() => _isSubmitting = true);
    final appProvider = context.read<ApplicationProvider>();

    await appProvider.applyForJob(
      jobId: widget.job.id,
      expectedSalary: expected,
      availability: _availability,
      coverNote: _coverNoteCtrl.text.trim().isNotEmpty ? _coverNoteCtrl.text.trim() : null,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Application submitted successfully to ${widget.job.businessName}!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<TechnicianProfileProvider>().technician;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryLight,
                  child: const Icon(Icons.send_rounded, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submit Job Application',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                      ),
                      Text(
                        widget.job.title,
                        style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Technician Summary Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      profile?.fullName.isNotEmpty == true ? profile!.fullName[0] : 'T',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.fullName ?? 'Technician Name',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                        ),
                        Text(
                          '${profile?.primaryTrade ?? "AC Tech"} • ${profile?.experienceYears ?? 5.0}Y Exp • Trust ${profile?.trustScore ?? 92}/100',
                          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_rounded, size: 18, color: AppTheme.success),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Expected Salary Input
            const Text(
              'Your Expected Salary (Monthly)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _expectedSalaryCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: 'e.g. ${widget.job.minSalary}',
                helperText: 'Offered range: ${Formatters.formatSalaryRange(widget.job.minSalary, widget.job.maxSalary)}',
              ),
            ),
            const SizedBox(height: 14),

            // Availability Selector
            const Text(
              'Joining Availability',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _availability,
              items: AppConstants.availabilityOptions.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              onChanged: (val) => setState(() => _availability = val ?? 'Immediately Available'),
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 14),

            // Cover Note
            const Text(
              'Introductory Note (Optional)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _coverNoteCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Highlight your top AC certifications, brand experience, or flaring skills to the employer...',
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitApplication,
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Confirm & Send Application'),
            ),
          ],
        ),
      ),
    );
  }
}
