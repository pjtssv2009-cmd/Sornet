import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/job.dart';
import '../../providers/job_provider.dart';
import '../common/empty_state.dart';

class JobAlertsScreen extends StatelessWidget {
  const JobAlertsScreen({super.key});

  void _openCreateAlertDialog(BuildContext context) {
    final titleCtrl = TextEditingController(text: 'Inverter AC Jobs in Chennai');
    String city = 'Chennai';
    String category = 'HVAC & AC Systems';
    final salaryCtrl = TextEditingController(text: '28000');
    String frequency = 'Daily';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Create New Job Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Alert Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'e.g. VRV Jobs in Bengaluru')),
                  const SizedBox(height: 12),

                  const Text('Preferred City', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: city,
                    items: AppConstants.indianCities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setModalState(() => city = val ?? 'Chennai'),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 12),

                  const Text('Minimum Salary (₹)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  TextField(controller: salaryCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: '25000')),
                  const SizedBox(height: 12),

                  const Text('Alert Frequency', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: frequency,
                    items: ['Instant', 'Daily', 'Weekly'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (val) => setModalState(() => frequency = val ?? 'Daily'),
                    decoration: const InputDecoration(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final alert = JobAlert(
                    id: 'alert-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    category: category,
                    city: city,
                    minSalary: int.tryParse(salaryCtrl.text.trim()) ?? 25000,
                    frequency: frequency,
                    createdAt: DateTime.now(),
                  );
                  context.read<JobProvider>().createJobAlert(alert);
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(100, 40)),
                child: const Text('Save Alert'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Job Alerts'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateAlertDialog(context),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_alert_rounded, color: Colors.white),
        label: const Text('Create Alert', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: jobProvider.jobAlerts.isEmpty
            ? EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'No Job Alerts Created',
                description: 'Set up custom alerts to receive instant notifications when new AC & HVAC jobs matching your skills are posted.',
                actionText: 'Create Your First Alert',
                onAction: () => _openCreateAlertDialog(context),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: jobProvider.jobAlerts.length,
                itemBuilder: (context, index) {
                  final alert = jobProvider.jobAlerts[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.notifications_active_rounded, color: AppTheme.primary, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.title,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${alert.city} • Min ${Formatters.formatCurrency(alert.minSalary)}/mo • ${alert.frequency}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.textTertiary),
                          onPressed: () => jobProvider.deleteJobAlert(alert.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
