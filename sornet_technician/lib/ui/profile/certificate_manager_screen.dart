import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_profile_provider.dart';
import '../common/confirm_dialog.dart';
import '../common/empty_state.dart';

class CertificateManagerScreen extends StatefulWidget {
  const CertificateManagerScreen({super.key});

  @override
  State<CertificateManagerScreen> createState() =>
      _CertificateManagerScreenState();
}

class _CertificateManagerScreenState extends State<CertificateManagerScreen> {
  void _showAddCertificateBottomSheet() {
    final titleController = TextEditingController();
    final authorityController = TextEditingController();
    final certNumberController = TextEditingController();
    var issueDate = DateTime.now().subtract(const Duration(days: 365));
    DateTime? expiryDate;

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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    'Add Technical Certificate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Certificate Name *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. ITI RAC (Refrigeration & AC)',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Issuing Body / Authority *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: authorityController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. NCVT / Daikin Skill Academy',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Certificate / License Number',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: certNumberController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. RAC-ITI-TN-98124',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Issue Date *',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: issueDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setModalState(() => issueDate = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_today_rounded,
                                  size: 14),
                              label: Text(
                                Formatters.formatDate(issueDate),
                                style: const TextStyle(fontSize: 11),
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
                            const Text('Expiry (Optional)',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: expiryDate ??
                                      DateTime.now()
                                          .add(const Duration(days: 365 * 3)),
                                  firstDate: issueDate,
                                  lastDate: DateTime(2035),
                                );
                                if (picked != null) {
                                  setModalState(() => expiryDate = picked);
                                }
                              },
                              icon: const Icon(Icons.calendar_today_rounded,
                                  size: 14),
                              label: Text(
                                expiryDate != null
                                    ? Formatters.formatDate(expiryDate!)
                                    : 'No Expiry',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.trim().isEmpty ||
                            authorityController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill required fields')),
                          );
                          return;
                        }

                        final newCert = TechnicianCertificate(
                          id: 'cert_${DateTime.now().millisecondsSinceEpoch}',
                          title: titleController.text.trim(),
                          issuingAuthority: authorityController.text.trim(),
                          issueDate: issueDate,
                          expiryDate: expiryDate,
                          certificateNumber:
                              certNumberController.text.trim().isEmpty
                                  ? null
                                  : certNumberController.text.trim(),
                          isVerified: false,
                        );

                        Provider.of<TechnicianProfileProvider>(context,
                                listen: false)
                            .addCertificate(newCert);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Certificate added! Our team will verify it shortly.'),
                            backgroundColor: AppTheme.accentGreen,
                          ),
                        );
                      },
                      child: const Text('Add Certificate'),
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
    final certificates = profileProvider.technician?.certificates ?? [];

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Certifications'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCertificateBottomSheet(),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Certificate',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: certificates.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.card_membership_outlined,
                title: 'No certificates added',
                subtitle:
                    'Add your trade certificates (ITI, OEM credentials, safety training) to boost your Trust Score.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 80),
              itemCount: certificates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cert = certificates[index];
                return _CertificateCard(
                  certificate: cert,
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => ConfirmDialog(
                        title: 'Delete Certificate?',
                        message:
                            'Are you sure you want to remove ${cert.title}?',
                        confirmText: 'Delete',
                        confirmColor: AppTheme.accentRed,
                        onConfirm: () {
                          Provider.of<TechnicianProfileProvider>(context,
                                  listen: false)
                              .deleteCertificate(cert.id);
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

class _CertificateCard extends StatelessWidget {
  final TechnicianCertificate certificate;
  final VoidCallback onDelete;

  const _CertificateCard({
    required this.certificate,
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
                    color: AppTheme.accentGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.military_tech_rounded,
                      color: AppTheme.accentGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        certificate.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        certificate.issuingAuthority,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                      if (certificate.certificateNumber != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${certificate.certificateNumber}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      size: 18, color: AppTheme.accentRed),
                  onPressed: onDelete,
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.event_outlined,
                    size: 13, color: AppTheme.textMuted),
                const SizedBox(width: 6),
                Text(
                  'Issued: ${Formatters.formatDate(certificate.issueDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                if (certificate.isVerified)
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
                          'SORNET Verified',
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
          ],
        ),
      ),
    );
  }
}
