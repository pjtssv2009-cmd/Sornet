import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/message.dart';
import '../../providers/messaging_provider.dart';
import '../common/empty_state.dart';
import '../common/sornet_search_bar.dart';
import 'chat_conversation_screen.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final messagingProvider =
        Provider.of<MessagingProvider>(context);
    final threads = messagingProvider.threads.where((t) {
      if (_searchQuery.isEmpty) return true;
      return t.businessName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          t.jobTitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SornetSearchBar(
              hintText: 'Search employers or job titles...',
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: threads.isEmpty
                ? const Center(
                    child: EmptyState(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'No conversations yet',
                      subtitle:
                          'When employers message you regarding jobs or interviews, chats will appear here.',
                    ),
                  )
                : ListView.separated(
                    itemCount: threads.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 76),
                    itemBuilder: (context, index) {
                      final thread = threads[index];
                      return _ThreadTile(thread: thread);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  final ConversationThread thread;

  const _ThreadTile({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: thread.unreadCount > 0
          ? AppTheme.primaryLight.withValues(alpha: 0.3)
          : Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(Icons.business_rounded,
                  color: AppTheme.primaryBlue, size: 24),
            ),
            if (thread.unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.accentOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${thread.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                thread.businessName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: thread.unreadCount > 0
                      ? FontWeight.w700
                      : FontWeight.w600,
                  color: AppTheme.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              Formatters.formatRelativeTime(thread.lastMessageTime),
              style: TextStyle(
                fontSize: 11,
                fontWeight: thread.unreadCount > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: thread.unreadCount > 0
                    ? AppTheme.primaryBlue
                    : AppTheme.textMuted,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (thread.jobTitle.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                thread.jobTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlue,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              thread.lastMessage,
              style: TextStyle(
                fontSize: 13,
                color: thread.unreadCount > 0
                    ? AppTheme.textDark
                    : AppTheme.textMuted,
                fontWeight: thread.unreadCount > 0
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatConversationScreen(
                businessId: thread.businessId,
                businessName: thread.businessName,
                jobTitle: thread.jobTitle,
              ),
            ),
          );
        },
      ),
    );
  }
}
