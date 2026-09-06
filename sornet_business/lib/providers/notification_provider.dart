import 'package:flutter/foundation.dart';
import '../data/models/notification_item.dart';
import '../data/repositories/sornet_business_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final ISornetBusinessRepository _repository;

  bool _isLoading = false;
  List<NotificationItem> _notifications = [];

  NotificationProvider(this._repository) {
    loadNotifications();
  }

  bool get isLoading => _isLoading;
  List<NotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await _repository.getNotifications();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    final success = await _repository.markNotificationAsRead(id);
    if (success) {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    }
  }

  Future<void> markAllAsRead() async {
    final success = await _repository.markAllNotificationsAsRead();
    if (success) {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
      notifyListeners();
    }
  }
}
