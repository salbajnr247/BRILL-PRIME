
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/notification_model.dart';
import '../services/api_client.dart';

enum NotificationType {
  push,
  inApp,
  email,
}

class NotificationPreferences {
  final bool orderUpdates;
  final bool promotions;
  final bool newProducts;
  final bool priceAlerts;
  final bool vendorUpdates;
  final bool reviewResponses;
  final bool systemUpdates;
  
  final Map<NotificationType, bool> typePreferences;

  NotificationPreferences({
    this.orderUpdates = true,
    this.promotions = true,
    this.newProducts = true,
    this.priceAlerts = true,
    this.vendorUpdates = true,
    this.reviewResponses = true,
    this.systemUpdates = true,
    Map<NotificationType, bool>? typePreferences,
  }) : typePreferences = typePreferences ?? {
    NotificationType.push: true,
    NotificationType.inApp: true,
    NotificationType.email: true,
  };

  Map<String, dynamic> toJson() => {
    'orderUpdates': orderUpdates,
    'promotions': promotions,
    'newProducts': newProducts,
    'priceAlerts': priceAlerts,
    'vendorUpdates': vendorUpdates,
    'reviewResponses': reviewResponses,
    'systemUpdates': systemUpdates,
    'typePreferences': typePreferences.map(
      (key, value) => MapEntry(key.toString(), value),
    ),
  };

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    Map<NotificationType, bool> typePrefs = {};
    final typePrefsJson = json['typePreferences'] as Map<String, dynamic>? ?? {};
    
    for (final type in NotificationType.values) {
      typePrefs[type] = typePrefsJson[type.toString()] ?? true;
    }

    return NotificationPreferences(
      orderUpdates: json['orderUpdates'] ?? true,
      promotions: json['promotions'] ?? true,
      newProducts: json['newProducts'] ?? true,
      priceAlerts: json['priceAlerts'] ?? true,
      vendorUpdates: json['vendorUpdates'] ?? true,
      reviewResponses: json['reviewResponses'] ?? true,
      systemUpdates: json['systemUpdates'] ?? true,
      typePreferences: typePrefs,
    );
  }

  NotificationPreferences copyWith({
    bool? orderUpdates,
    bool? promotions,
    bool? newProducts,
    bool? priceAlerts,
    bool? vendorUpdates,
    bool? reviewResponses,
    bool? systemUpdates,
    Map<NotificationType, bool>? typePreferences,
  }) {
    return NotificationPreferences(
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotions: promotions ?? this.promotions,
      newProducts: newProducts ?? this.newProducts,
      priceAlerts: priceAlerts ?? this.priceAlerts,
      vendorUpdates: vendorUpdates ?? this.vendorUpdates,
      reviewResponses: reviewResponses ?? this.reviewResponses,
      systemUpdates: systemUpdates ?? this.systemUpdates,
      typePreferences: typePreferences ?? this.typePreferences,
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> notifications = [];
  List<NotificationModel> unreadNotifications = [];
  bool loading = false;
  String errorMessage = '';
  NotificationPreferences preferences = NotificationPreferences();

  int get unreadCount => unreadNotifications.length;

  NotificationProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsData = prefs.getString('notification_preferences');
      if (prefsData != null) {
        preferences = NotificationPreferences.fromJson(json.decode(prefsData));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading notification preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_preferences', json.encode(preferences.toJson()));
    } catch (e) {
      debugPrint('Error saving notification preferences: $e');
    }
  }

  Future<void> fetchNotifications({required BuildContext context}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'users/me/notifications',
        context: context,
        requestName: 'fetchNotifications',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        notifications = NotificationModel.listFromJson(response.$2);
        _updateUnreadNotifications();
      } else {
        errorMessage = response.$2;
      }
      notifyListeners();
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _updateUnreadNotifications() {
    unreadNotifications = notifications.where((notification) => !notification.isRead).toList();
  }

  Future<bool> markAsRead({required BuildContext context, required String notificationId}) async {
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'users/me/notifications/$notificationId/read',
        context: context,
        body: {},
        requestName: 'markAsRead',
        printResponseBody: true,
      );
      if (response.$1) {
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index >= 0) {
          notifications[index] = notifications[index].copyWith(isRead: true);
          _updateUnreadNotifications();
          notifyListeners();
        }
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAllAsRead({required BuildContext context}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'users/me/notifications/mark-all-read',
        context: context,
        body: {},
        requestName: 'markAllAsRead',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        for (int i = 0; i < notifications.length; i++) {
          notifications[i] = notifications[i].copyWith(isRead: true);
        }
        _updateUnreadNotifications();
        notifyListeners();
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteNotification({required BuildContext context, required String notificationId}) async {
    try {
      (bool, String) response = await ApiClient().deleteRequest(
        'users/me/notifications/$notificationId',
        context: context,
        requestName: 'deleteNotification',
        printResponseBody: true,
      );
      if (response.$1) {
        notifications.removeWhere((n) => n.id == notificationId);
        _updateUnreadNotifications();
        notifyListeners();
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePreferences({
    required BuildContext context,
    required NotificationPreferences newPreferences,
  }) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'users/me/notification-preferences',
        context: context,
        body: newPreferences.toJson(),
        requestName: 'updateNotificationPreferences',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        preferences = newPreferences;
        await _savePreferences();
        notifyListeners();
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void updatePreferenceLocally(NotificationPreferences newPreferences) {
    preferences = newPreferences;
    _savePreferences();
    notifyListeners();
  }

  Future<bool> sendTestNotification({
    required BuildContext context,
    required NotificationType type,
  }) async {
    try {
      (bool, String) response = await ApiClient().postRequest(
        'users/me/test-notification',
        context: context,
        body: {'type': type.toString()},
        requestName: 'sendTestNotification',
        printResponseBody: true,
      );
      return response.$1;
    } catch (e) {
      debugPrint('Error sending test notification: $e');
      return false;
    }
  }

  List<NotificationModel> getNotificationsByType(String type) {
    return notifications.where((notification) => notification.type == type).toList();
  }

  void addNotification(NotificationModel notification) {
    notifications.insert(0, notification);
    if (!notification.isRead) {
      unreadNotifications.insert(0, notification);
    }
    notifyListeners();
  }

  void clearAllNotifications() {
    notifications.clear();
    unreadNotifications.clear();
    notifyListeners();
  }
}
