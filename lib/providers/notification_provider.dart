import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/api_client.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> notifications = [];
  bool loading = false;
  String errorMessage = '';

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

  Future<bool> markAsRead({required BuildContext context, required String notificationId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'users/me/notifications/$notificationId/read',
        context: context,
        body: {},
        requestName: 'markAsRead',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        await fetchNotifications(context: context);
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
} 