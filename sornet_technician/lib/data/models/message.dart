class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final bool isFromTechnician;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentType; // 'image', 'document', 'location'

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.isFromTechnician,
    required this.text,
    required this.timestamp,
    this.isRead = true,
    this.attachmentUrl,
    this.attachmentType,
  });

  String get content => text;
  bool get isSender => isFromTechnician;
}

class ConversationThread {
  final String id;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final bool isBusinessVerified;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String relatedJobTitle;
  final bool isOnline;

  ConversationThread({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    this.isBusinessVerified = true,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.relatedJobTitle,
    this.isOnline = false,
  });

  String get jobTitle => relatedJobTitle;
}
