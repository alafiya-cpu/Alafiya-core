import 'package:flutter/foundation.dart';

/// Notification Model
class Notification {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? data;
  final bool isRead;
  final DateTime createdAt;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      data: json['data'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Notification Provider
/// Manages app notifications state
class NotificationProvider with ChangeNotifier {
  final List<Notification> _notifications = [];
  int _unreadCount = 0;

  // Getters
  List<Notification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _unreadCount;
  bool get hasUnreadNotifications => _unreadCount > 0;

  /// Add notification
  void addNotification(Notification notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) {
      _unreadCount++;
    }
    notifyListeners();
  }

  /// Mark notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index] = Notification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        data: _notifications[index].data,
        isRead: true,
        createdAt: _notifications[index].createdAt,
      );
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = Notification(
        id: _notifications[i].id,
        title: _notifications[i].title,
        message: _notifications[i].message,
        type: _notifications[i].type,
        data: _notifications[i].data,
        isRead: true,
        createdAt: _notifications[i].createdAt,
      );
    }
    _unreadCount = 0;
    notifyListeners();
  }

  /// Clear notifications
  void clearNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }

  /// Remove notification
  void removeNotification(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      if (!_notifications[index].isRead) {
        _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      }
      _notifications.removeAt(index);
      notifyListeners();
    }
  }
}