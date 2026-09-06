import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/support_ticket.dart';
import '../../providers/auth_provider.dart';
import '../../providers/support_provider.dart';
import '../common/empty_state.dart';
import '../common/status_badge.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateTicketBottomSheet() {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    var selectedCategory = TicketCategory.verification;

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
                    'Submit Support Ticket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Our 24/7 technician support desk will respond within 2 hours.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 16),
                  const Text('Issue Category *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<TicketCategory>(
                    value: selectedCategory,
                    items: TicketCategory.values
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat.label),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() => selectedCategory = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Subject *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Aadhaar verification document query',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Description & Details *',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Describe what issue you are experiencing or what help you need...',
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (subjectController.text.trim().isEmpty ||
                            descriptionController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill all fields')),
                          );
                          return;
                        }

                        final technician =
                            Provider.of<AuthProvider>(context, listen: false)
                                .currentTechnician;

                        final newTicket = SupportTicket(
                          id: 'tkt_${DateTime.now().millisecondsSinceEpoch}',
                          technicianId: technician?.id ?? 'tech_1',
                          subject: subjectController.text.trim(),
                          description: descriptionController.text.trim(),
                          category: selectedCategory,
                          status: TicketStatus.open,
                          createdAt: DateTime.now(),
                        );

                        Provider.of<SupportProvider>(context, listen: false)
                            .createTicket(newTicket);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support ticket created successfully!'),
                            backgroundColor: AppTheme.accentGreen,
                          ),
                        );
                      },
                      child: const Text('Submit Ticket'),
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
    final supportProvider =
        Provider.of<SupportProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Help & Support'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            const Tab(text: 'Frequently Asked Questions'),
            Tab(text: 'My Tickets (${supportProvider.tickets.length})'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTicketBottomSheet,
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.support_agent_rounded, color: Colors.white),
        label: const Text('New Ticket',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // FAQs Tab
          ListView.separated(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 16, bottom: 80),
            itemCount: supportProvider.faqs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final faq = supportProvider.faqs[index];
              return Card(
                child: ExpansionTile(
                  title: Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Text(
                        faq.answer,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Tickets Tab
          supportProvider.tickets.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'No support tickets',
                    subtitle:
                        'If you have any questions or need help with jobs, submit a ticket above.',
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 80),
                  itemCount: supportProvider.tickets.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ticket = supportProvider.tickets[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ticket.subject,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                ),
                                StatusBadge(
                                  text: ticket.status.label,
                                  color: Color(ticket.status.badgeColorValue),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ticket.description,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Category: ${ticket.category.label}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                                Text(
                                  Formatters.formatRelativeTime(
                                      ticket.createdAt),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
