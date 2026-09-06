import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How does SORNET verify technician skills?',
      'answer':
          'Technicians undergo a rigorous 4-step verification process including Government ID check (Aadhaar/PAN), trade certificate audit (ITI RAC/Diploma), OEM brand certification validation (Daikin/LG/Blue Star), and background history verification.'
    },
    {
      'question': 'Can I interview candidates before extending an offer?',
      'answer':
          'Yes! You can book Phone, Video (Google Meet/Zoom), or In-Person interviews directly from the application pipeline with automated calendar reminders.'
    },
    {
      'question': 'How do I compare multiple shortlisted technicians?',
      'answer':
          'Use the candidate checkbox on discovery cards or the Shortlist screen to select 2 to 4 technicians. Tap "Compare Candidates" to view side-by-side matrices on ratings, experience, brands, and expected rates.'
    },
    {
      'question': 'When can I rate and review a hired technician?',
      'answer':
          'Once a technician accepts your offer and joins your team or completes their contract tenure, you can submit verified 5-criteria reviews from the "My Technicians" screen.'
    },
    {
      'question': 'What are the GST requirements for business accounts?',
      'answer':
          'Registered businesses with valid GST numbers earn the Verified Business Badge which increases technician application response rates by 70%.'
    },
  ];

  void _openTicketModal(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppTheme.surface,
        title: const Text('Submit Support Ticket', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Issue Subject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(
              controller: subjectCtrl,
              decoration: const InputDecoration(hintText: 'e.g. Verification status question', isDense: true),
            ),
            const SizedBox(height: 12),
            const Text('Detailed Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            TextField(
              controller: messageCtrl,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Describe your issue in detail...', isDense: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Support ticket #SRN-8841 raised! Our support team will reply shortly.'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Submit Ticket'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Hotline Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppTheme.heroCardGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '24/7 Enterprise Hiring Support',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our platform account managers assist with bulk technician hiring and verification.',
                    style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.3),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling +91 1800-419-7676...')),
                          );
                        },
                        icon: const Icon(Icons.phone_rounded, size: 16),
                        label: const Text('Call 1800-419-SORNET'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _openTicketModal(context),
                        icon: const Icon(Icons.mail_outline_rounded, size: 16, color: Colors.white),
                        label: const Text('Open Ticket', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // FAQs Section
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),

            ..._faqs.map((faq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 12),
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
