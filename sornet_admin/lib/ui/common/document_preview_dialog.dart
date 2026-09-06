import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import 'status_badge.dart';

class DocumentPreviewDialog extends StatelessWidget {
  final TechDocument document;
  final Function(VerificationStatus status, String? note)? onStatusChange;

  const DocumentPreviewDialog({
    super.key,
    required this.document,
    this.onStatusChange,
  });

  static void show(
    BuildContext context, {
    required TechDocument document,
    Function(VerificationStatus status, String? note)? onStatusChange,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DocumentPreviewDialog(
        document: document,
        onStatusChange: onStatusChange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${document.type} • ID: ${document.documentNumber}',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge.fromVerificationStatus(document.status),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),
          // Document Viewer Container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mock Document Preview Card
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Stylized Document Mock
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: document.fileUrl.isNotEmpty
                                ? Image.network(
                                    document.fileUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => _buildFallbackViewer(),
                                  )
                                : _buildFallbackViewer(),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.zoom_in, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Inspection Mode',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Metadata Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetaRow('Document Type', document.type),
                        const Divider(height: 16),
                        _buildMetaRow('Document Number', document.documentNumber),
                        const Divider(height: 16),
                        _buildMetaRow('Upload Timestamp', AppFormatters.formatDateTime(document.uploadDate)),
                        if (document.rejectionNote != null) ...[
                          const Divider(height: 16),
                          _buildMetaRow('Admin Remark', document.rejectionNote!, isWarning: true),
                        ],
                      ],
                    ),
                  ),
                  if (onStatusChange != null) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.errorBorder),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: const Text('Reject Document'),
                            onPressed: () {
                              _promptRejection(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            icon: const Icon(Icons.check_circle_outline, size: 18),
                            label: const Text('Approve Document'),
                            onPressed: () {
                              onStatusChange!(VerificationStatus.verified, null);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Document approved successfully!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackViewer() {
    return Container(
      color: const Color(0xFFEFF6FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            document.fileType == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.badge_outlined,
            size: 54,
            color: AppColors.primary,
          ),
          const SizedBox(height: 10),
          Text(
            document.title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ref: ${document.documentNumber}',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value, {bool isWarning = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isWarning ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _promptRejection(BuildContext context) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Document'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter reason for document rejection:'),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'e.g. Blurry photo, expired certificate, name mismatch...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              final note = noteController.text.trim();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              if (onStatusChange != null) {
                onStatusChange!(VerificationStatus.rejected, note.isNotEmpty ? note : 'Document rejected by Admin');
              }
            },
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );
  }
}
