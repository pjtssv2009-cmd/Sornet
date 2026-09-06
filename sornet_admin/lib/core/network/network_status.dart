import 'package:flutter/material.dart';

class NetworkStatusProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool _wasOffline = false;

  bool get isOnline => _isOnline;
  bool get wasOffline => _wasOffline;

  void setOnlineStatus(bool online) {
    if (_isOnline != online) {
      if (!online) {
        _wasOffline = true;
      }
      _isOnline = online;
      notifyListeners();
    }
  }

  void dismissOfflineRecoveryNotice() {
    _wasOffline = false;
    notifyListeners();
  }
}
