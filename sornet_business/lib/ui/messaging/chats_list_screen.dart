import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/messaging_provider.dart';
import '../../providers/technician_provider.dart';
import '../common/empty_state.dart';
import 'chat_conversation_screen.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final messagingProvider = context.watch<MessagingProvider>();
    final techProvider = context.watch<TechnicianProvider>();
    final threads = messagingProvider.threads;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Messages & Communications'),
      ),
      body: SafeArea(
        child: threads.isEmpty
            ? const EmptyState(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'No Active Conversations',
                message: 'You can message shortlisted candidates, scheduled interviewees, and hired technicians.',
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: threads.length,
                itemBuilder: (context, index) {
                  final thread = threads[index];
                  final tech = techProvider.technicians.firstWhere(
                    (t) => t.id == thread.technicianId,
                    orElse: () => Technician(
                      id: thread.technicianId,
                      name: thread.technicianName,
                      photoUrl: thread.technicianPhoto,
                      phone: '+91 98402 33441',
                      email: 'tech@sornet.com',
                      location: 'Chennai',
                      city: 'Chennai',
                      experienceYears: 5,
                      rating: 4.8,
                      reviewsCount: 40,
                      trustScore: 95,
                      availability: 'Immediate',
                      expectedSalaryMonthly: 25000,
                      dailyRate: 1200,
                      about: '',
                      acExpertise: ['Split AC'],
                      technicalExpertise: ['Inverter'],
                      brands: ['Daikin'],
                      services: ['Installation'],
                      experienceHistory: [],
                      certificates: [],
                    ),
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatConversationScreen(technician: tech),
                          ),
                        );
                      },
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppTheme.primaryLight,
                            child: Text(
                              thread.technicianName.isNotEmpty ? thread.technicianName[0] : 'T',
                              style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 16),
                            ),
                          ),
                          if (thread.isTechnicianOnline)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: AppTheme.success,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                        ],
                      ),
                      title: Row(
                        children: [
                          Flexible(
                            child: Text(
                              thread.technicianName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (thread.isTechnicianVerified)
                            const Icon(Icons.verified_rounded, color: AppTheme.primary, size: 14),
                          const Spacer(),
                          Text(
                            Formatters.timeAgo(thread.lastMessageTime),
                            style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceMuted,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  thread.relationshipType,
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  thread.lastMessage,
                                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (thread.unreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${thread.unreadCount}',
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
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
      ),
    );
  }
}
