class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isBusinessSender;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentType;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isBusinessSender,
    this.isRead = true,
    this.attachmentUrl,
    this.attachmentType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'isBusinessSender': isBusinessSender,
        'isRead': isRead,
        'attachmentUrl': attachmentUrl,
        'attachmentType': attachmentType,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        senderId: json['senderId'] as String,
        senderName: json['senderName'] as String,
        receiverId: json['receiverId'] as String,
        message: json['message'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isBusinessSender: json['isBusinessSender'] as bool? ?? false,
        isRead: json['isRead'] as bool? ?? true,
        attachmentUrl: json['attachmentUrl'] as String?,
        attachmentType: json['attachmentType'] as String?,
      );
}

class ConversationThread {
  final String id;
  final String technicianId;
  final String technicianName;
  final String technicianPhoto;
  final bool isTechnicianVerified;
  final bool isTechnicianOnline;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String relationshipType; // 'Shortlisted', 'Interview Scheduled', 'Hired'

  ConversationThread({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.technicianPhoto,
    this.isTechnicianVerified = true,
    this.isTechnicianOnline = false,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.relationshipType,
  });

  ConversationThread copyWith({
    String? id,
    String? technicianId,
    String? technicianName,
    String? technicianPhoto,
    bool? isTechnicianVerified,
    bool? isTechnicianOnline,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    String? relationshipType,
  }) {
    return ConversationThread(
      id: id ?? this.id,
      technicianId: technicianId ?? this.technicianId,
      technicianName: technicianName ?? this.technicianName,
      technicianPhoto: technicianPhoto ?? this.technicianPhoto,
      isTechnicianVerified: isTechnicianVerified ?? this.isTechnicianVerified,
      isTechnicianOnline: isTechnicianOnline ?? this.isTechnicianOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      relationshipType: relationshipType ?? this.relationshipType,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'technicianId': technicianId,
        'technicianName': technicianName,
        'technicianPhoto': technicianPhoto,
        'isTechnicianVerified': isTechnicianVerified,
        'isTechnicianOnline': isTechnicianOnline,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime.toIso8601String(),
        'unreadCount': unreadCount,
        'relationshipType': relationshipType,
      };

  factory ConversationThread.fromJson(Map<String, dynamic> json) => ConversationThread(
        id: json['id'] as String,
        technicianId: json['technicianId'] as String,
        technicianName: json['technicianName'] as String,
        technicianPhoto: json['technicianPhoto'] as String,
        isTechnicianVerified: json['isTechnicianVerified'] as bool? ?? true,
        isTechnicianOnline: json['isTechnicianOnline'] as bool? ?? false,
        lastMessage: json['lastMessage'] as String,
        lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
        unreadCount: json['unreadCount'] as int? ?? 0,
        relationshipType: json['relationshipType'] as String,
      );
}
