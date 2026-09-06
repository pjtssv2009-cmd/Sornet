import 'package:flutter/material.dart';
import '../data/models/message.dart';
import '../data/repositories/sornet_technician_repository.dart';

class MessagingProvider extends ChangeNotifier {
  final ISornetTechnicianRepository _repository;

  List<ConversationThread> _threads = [];
  final Map<String, List<ChatMessage>> _messagesCache = {};
  bool _isLoading = false;

  MessagingProvider(this._repository) {
    loadThreads();
  }

  List<ConversationThread> get threads => _threads;
  bool get isLoading => _isLoading;

  int get totalUnreadMessages =>
      _threads.fold(0, (sum, t) => sum + t.unreadCount);

  Future<void> loadThreads() async {
    _isLoading = true;
    notifyListeners();

    try {
      _threads = await _repository.getConversations();
    } catch (e) {
      debugPrint('Error loading conversation threads: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ChatMessage>> getMessagesForBusiness(String businessId) async {
    try {
      final messages = await _repository.getMessages(businessId);
      _messagesCache[businessId] = messages;
      notifyListeners();
      return messages;
    } catch (e) {
      debugPrint('Error loading messages for business $businessId: $e');
      return [];
    }
  }

  List<ChatMessage> getMessages(String businessId) {
    return _messagesCache[businessId] ??
        [
          ChatMessage(
            id: 'msg_init',
            senderId: businessId,
            senderName: 'Employer',
            isFromTechnician: false,
            text: 'Hello! Thank you for applying on SORNET. Let us know your availability.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
        ];
  }

  void markThreadRead(String businessId) {
    final index = _threads.indexWhere((t) => t.businessId == businessId);
    if (index != -1) {
      _threads[index] = ConversationThread(
        id: _threads[index].id,
        businessId: _threads[index].businessId,
        businessName: _threads[index].businessName,
        businessLogo: _threads[index].businessLogo,
        isBusinessVerified: _threads[index].isBusinessVerified,
        lastMessage: _threads[index].lastMessage,
        lastMessageTime: _threads[index].lastMessageTime,
        unreadCount: 0,
        relatedJobTitle: _threads[index].relatedJobTitle,
        isOnline: _threads[index].isOnline,
      );
      notifyListeners();
    }
  }

  List<ChatMessage> getCachedMessages(String businessId) {
    return _messagesCache[businessId] ?? [];
  }

  Future<ChatMessage> sendMessage(String businessId, String text) async {
    final sent = await _repository.sendMessage(businessId, text);
    if (!_messagesCache.containsKey(businessId)) {
      _messagesCache[businessId] = [];
    }
    _messagesCache[businessId]!.add(sent);
    await loadThreads();
    notifyListeners();
    return sent;
  }
}
