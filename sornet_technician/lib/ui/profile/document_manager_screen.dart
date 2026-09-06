import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/technician_profile_provider.dart';
import '../common/empty_state.dart';

class DocumentManagerScreen extends StatefulWidget {
  const DocumentManagerScreen({super.key});

  @override
  State<DocumentManagerScreen> createState() => _DocumentManagerScreenState();
}

class _DocumentManagerScreenState extends State<DocumentManagerScreen> {
  void _showUploadDocumentSheet() {
    String selectedType = 'Aadhaar Card';
    final docNumberController = TextEditingController();

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
                  'Upload Verification Document',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Documents are encrypted and used solely for identity & background verification.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
                const SizedBox(height: 16),
                const Text('Document Type *',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: [
                    'Aadhaar Card',
                    'PAN Card',
                    'Driving License',
                    'Voter ID Card',
                    'Electrical License (Wireman/Supervisor)',
                  ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) =>
                      setModalState(() => selectedType = val ?? selectedType),
                ),
                const SizedBox(height: 14),
                const Text('Document Number / ID *',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: docNumberController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 5432-XXXX-8892',
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundSoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.borderLight,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.cloud_upload_outlined,
                          size: 32, color: AppTheme.primaryBlue),
                      SizedBox(height: 6),
                      Text(
                        'Tap to select PDF or image file (Front & Back)',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'JPG, PNG, PDF up to 5MB',
                        style:
                            TextStyle(fontSize: 11, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (docNumberController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter document number')),
                        );
                        return;
                      }

                      final newDoc = TechnicianDocument(
                        id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
                        name: selectedType,
                        documentType: selectedType,
                        documentNumber: docNumberController.text.trim(),
                        fileUrl: 'https://sornet.storage/docs/$selectedType.pdf',
                        uploadedAt: DateTime.now(),
                        isVerified: false,
                      );

                      Provider.of<TechnicianProfileProvider>(context,
                              listen: false)
                          .addDocument(newDoc);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Document uploaded! Admin review takes ~2-4 hours.'),
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      );
                    },
                    child: const Text('Upload Document'),
                  ),
                ),
              ],
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
    final documents = profileProvider.technician?.documents ?? [];

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Document Vault'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDocumentSheet(),
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
        label: const Text('Upload Document',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vault Info Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_rounded,
                      color: AppTheme.primaryBlue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your documents are encrypted and only accessible to SORNET verification officers.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (documents.isEmpty)
              const Center(
                child: EmptyState(
                  icon: Icons.folder_open_rounded,
                  title: 'No documents uploaded',
                  subtitle:
                      'Upload your Aadhaar or Driving License to complete profile verification.',
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: documents.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.description_rounded,
                            color: AppTheme.primaryBlue),
                      ),
                      title: Text(
                        doc.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (doc.documentNumber != null)
                            Text(
                              doc.documentNumber!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          Text(
                            'Uploaded ${Formatters.formatDate(doc.uploadedAt)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      trailing: doc.isVerified
                          ? const Icon(Icons.verified_rounded,
                              color: AppTheme.accentGreen)
                          : const Text(
                              'Pending Review',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.accentOrange,
                              ),
                            ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
