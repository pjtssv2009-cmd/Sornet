import 'package:flutter/foundation.dart';
import '../data/models/message.dart';
import '../data/repositories/sornet_business_repository.dart';

class MessagingProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<ConversationThread> _threads = [];
  final Map<String, List<ChatMessage>> _messagesCache = {};

  MessagingProvider(this._repository) {
    loadThreads();
  }

  bool get isLoading => _isLoading;
  List<ConversationThread> get threads => _threads;

  int get totalUnreadMessages => _threads.fold(0, (sum, t) => sum + t.unreadCount);

  Future<void> loadThreads() async {
    _isLoading = true;
    notifyListeners();

    try {
      _threads = await _repository.getConversations();
    } catch (e) {
      debugPrint('Error loading threads: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ChatMessage>> getMessagesForTechnician(String technicianId) async {
    try {
      final msgs = await _repository.getMessages(technicianId);
      _messagesCache[technicianId] = msgs;
      notifyListeners();
      return msgs;
    } catch (e) {
      debugPrint('Error loading messages: $e');
      return [];
    }
  }

  List<ChatMessage> getCachedMessages(String technicianId) {
    return _messagesCache[technicianId] ?? [];
  }

  Future<void> sendMessage({
    required String technicianId,
    required String technicianName,
    required String messageText,
  }) async {
    final msg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'biz-101',
      senderName: 'CoolFlow Air Conditioning',
      receiverId: technicianId,
      message: messageText.trim(),
      timestamp: DateTime.now(),
      isBusinessSender: true,
      isRead: true,
    );

    if (!_messagesCache.containsKey(technicianId)) {
      _messagesCache[technicianId] = [];
    }
    _messagesCache[technicianId]!.add(msg);
    notifyListeners();

    await _repository.sendMessage(msg);

    // Update conversation list
    final tIndex = _threads.indexWhere((t) => t.technicianId == technicianId);
    if (tIndex != -1) {
      _threads[tIndex] = _threads[tIndex].copyWith(
        lastMessage: msg.message,
        lastMessageTime: msg.timestamp,
      );
    }
    notifyListeners();

    // Auto simulated response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      final reply = ChatMessage(
        id: 'reply-${DateTime.now().millisecondsSinceEpoch}',
        senderId: technicianId,
        senderName: technicianName,
        receiverId: 'biz-101',
        message: 'Thank you for your message, sir. I have noted this down and will follow up.',
        timestamp: DateTime.now(),
        isBusinessSender: false,
        isRead: false,
      );
      _messagesCache[technicianId]?.add(reply);
      final index = _threads.indexWhere((t) => t.technicianId == technicianId);
      if (index != -1) {
        _threads[index] = _threads[index].copyWith(
          lastMessage: reply.message,
          lastMessageTime: reply.timestamp,
        );
      }
      notifyListeners();
    });
  }
}
