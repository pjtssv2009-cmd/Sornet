import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/technician.dart';
import '../../providers/messaging_provider.dart';
import '../discovery/technician_detail_screen.dart';

class ChatConversationScreen extends StatefulWidget {
  final Technician technician;

  const ChatConversationScreen({super.key, required this.technician});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<String> _quickReplies = [
    'Are you available for an interview tomorrow?',
    'Please review the formal offer we sent.',
    'Could you confirm your joining date?',
    'Can you service VRV systems in Guindy?',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessagingProvider>().getMessagesForTechnician(widget.technician.id);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? textToSend]) {
    final text = textToSend ?? _messageController.text;
    if (text.trim().isEmpty) return;

    final messaging = context.read<MessagingProvider>();
    messaging.sendMessage(
      technicianId: widget.technician.id,
      technicianName: widget.technician.name,
      messageText: text,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messaging = context.watch<MessagingProvider>();
    final messages = messaging.getCachedMessages(widget.technician.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: widget.technician)),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  widget.technician.name.isNotEmpty ? widget.technician.name[0] : 'T',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.technician.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (widget.technician.isVerified)
                          const Icon(Icons.verified_rounded, size: 14, color: AppTheme.primary),
                      ],
                    ),
                    const Text(
                      'Online • Verified Professional',
                      style: TextStyle(fontSize: 10, color: AppTheme.successText, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: AppTheme.primary),
            tooltip: 'Call Technician',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.technician.phone}...')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat Messages List
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chat_outlined, color: AppTheme.primary, size: 32),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Start conversation with ${widget.technician.name}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Discuss hiring terms, interview availability, and project details.',
                            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return _buildMessageBubble(msg);
                      },
                    ),
            ),

            // Quick Reply Suggestions
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _quickReplies.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return ActionChip(
                    label: Text(_quickReplies[index]),
                    labelStyle: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600),
                    backgroundColor: AppTheme.primaryLight,
                    side: BorderSide.none,
                    onPressed: () => _sendMessage(_quickReplies[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),

            // Message Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: const Border(top: BorderSide(color: AppTheme.border, width: 1)),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppTheme.textSecondary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Document attachment placeholder.')),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(dynamic msg) {
    final isBusiness = msg.isBusinessSender;

    return Align(
      alignment: isBusiness ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isBusiness ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(isBusiness ? 14 : 2),
            bottomRight: Radius.circular(isBusiness ? 2 : 14),
          ),
          border: isBusiness ? null : Border.all(color: AppTheme.border),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: isBusiness ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msg.message,
              style: TextStyle(
                fontSize: 13,
                color: isBusiness ? Colors.white : AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatters.formatTime(msg.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isBusiness ? Colors.white.withValues(alpha: 0.7) : AppTheme.textTertiary,
                  ),
                ),
                if (isBusiness) ...[
                  const SizedBox(width: 4),
                  Icon(
                    msg.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
