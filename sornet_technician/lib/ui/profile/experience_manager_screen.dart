import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_profile_provider.dart';
import '../common/confirm_dialog.dart';
import '../common/empty_state.dart';

class ExperienceManagerScreen extends StatefulWidget {
  const ExperienceManagerScreen({super.key});

  @override
  State<ExperienceManagerScreen> createState() =>
      _ExperienceManagerScreenState();
}

class _ExperienceManagerScreenState extends State<ExperienceManagerScreen> {
  void _showAddExperienceBottomSheet([TechnicianExperience? experience]) {
    final companyController =
        TextEditingController(text: experience?.companyName ?? '');
    final titleController =
        TextEditingController(text: experience?.jobTitle ?? '');
    final locationController =
        TextEditingController(text: experience?.location ?? '');
    final descriptionController =
        TextEditingController(text: experience?.description ?? '');

    var isCurrent = experience?.isCurrent ?? false;
    var startDate = experience?.startDate ??
        DateTime.now().subtract(const Duration(days: 365 * 2));
    DateTime? endDate = experience?.endDate;

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
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
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
                  Text(
                    experience == null ? 'Add Work Experience' : 'Edit Experience',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Company / Employer Name *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: companyController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Blue Star Service Center',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Job Designation / Role *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Senior HVAC Service Technician',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Location',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Chennai, Tamil Nadu',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Date *',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: startDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setModalState(() => startDate = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_today_rounded,
                                  size: 14),
                              label: Text(
                                Formatters.formatDate(startDate),
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (!isCurrent)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('End Date',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: endDate ?? DateTime.now(),
                                    firstDate: startDate,
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setModalState(() => endDate = picked);
                                  }
                                },
                                icon: const Icon(Icons.calendar_today_rounded,
                                    size: 14),
                                label: Text(
                                  endDate != null
                                      ? Formatters.formatDate(endDate!)
                                      : 'Select End',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'I currently work here',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                    value: isCurrent,
                    activeColor: AppTheme.primaryBlue,
                    onChanged: (val) {
                      setModalState(() {
                        isCurrent = val ?? false;
                        if (isCurrent) endDate = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Key Responsibilities & Achievements',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. Diagnosed VRV systems, supervised team of 3 junior mechanics...',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (companyController.text.trim().isEmpty ||
                            titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill required fields')),
                          );
                          return;
                        }

                        final newExp = TechnicianExperience(
                          id: experience?.id ??
                              'exp_${DateTime.now().millisecondsSinceEpoch}',
                          companyName: companyController.text.trim(),
                          jobTitle: titleController.text.trim(),
                          location: locationController.text.trim(),
                          startDate: startDate,
                          endDate: endDate,
                          isCurrent: isCurrent,
                          description:
                              descriptionController.text.trim().isEmpty
                                  ? null
                                  : descriptionController.text.trim(),
                          isVerified: experience?.isVerified ?? false,
                        );

                        if (experience == null) {
                          Provider.of<TechnicianProfileProvider>(context,
                                  listen: false)
                              .addExperience(newExp);
                        } else {
                          Provider.of<TechnicianProfileProvider>(context,
                                  listen: false)
                              .updateExperience(newExp);
                        }

                        Navigator.pop(ctx);
                      },
                      child: Text(
                          experience == null ? 'Add Position' : 'Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<TechnicianProfileProvider>(context);
    final experiences = profileProvider.technician?.experiences ?? [];

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Work Experience'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExperienceBottomSheet(),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Experience',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: experiences.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.work_history_outlined,
                title: 'No work experience added',
                subtitle:
                    'Add your previous employer and site experience to demonstrate your technical expertise.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 80),
              itemCount: experiences.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final exp = experiences[index];
                return _ExperienceCard(
                  experience: exp,
                  onEdit: () => _showAddExperienceBottomSheet(exp),
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => ConfirmDialog(
                        title: 'Delete Experience?',
                        message:
                            'Are you sure you want to remove ${exp.jobTitle} at ${exp.companyName}?',
                        confirmText: 'Delete',
                        confirmColor: AppTheme.accentRed,
                        onConfirm: () {
                          Provider.of<TechnicianProfileProvider>(context,
                                  listen: false)
                              .deleteExperience(exp.id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final TechnicianExperience experience;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExperienceCard({
    required this.experience,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business_rounded,
                      color: AppTheme.primaryBlue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.jobTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        experience.companyName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (experience.location.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          experience.location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded,
                      color: AppTheme.textMuted),
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 16, color: AppTheme.accentRed),
                          SizedBox(width: 8),
                          Text('Delete',
                              style: TextStyle(color: AppTheme.accentRed)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 13, color: AppTheme.textMuted),
                const SizedBox(width: 6),
                Text(
                  '${Formatters.formatDate(experience.startDate)} - ${experience.isCurrent ? "Present" : experience.endDate != null ? Formatters.formatDate(experience.endDate!) : ""}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                if (experience.isVerified)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded,
                            size: 12, color: AppTheme.accentGreen),
                        SizedBox(width: 4),
                        Text(
                          'Verified by Admin',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (experience.description != null) ...[
              const SizedBox(height: 10),
              Text(
                experience.description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
