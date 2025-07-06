import 'package:flutter/material.dart';
import '../models/order_action_model.dart';
import '../services/api_client.dart';
import 'dart:convert';

class OrderManagementProvider extends ChangeNotifier {
  OrderActionModel? lastAction;
  String orderStatus = '';
  bool loading = false;
  String errorMessage = '';

  Future<bool> cancelOrder({required BuildContext context, required String orderId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'orders/$orderId/cancel',
        context: context,
        body: {},
        requestName: 'cancelOrder',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        lastAction = OrderActionModel.fromJson(json.decode(response.$2));
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

  Future<void> trackOrderStatus({required BuildContext context, required String orderId}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().getRequest(
        'orders/$orderId/status',
        context: context,
        requestName: 'trackOrderStatus',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        final data = OrderActionModel.fromJson(json.decode(response.$2));
        orderStatus = data.status;
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

  Future<bool> initiateReturn({required BuildContext context, required String orderId, String reason = ''}) async {
    loading = true;
    errorMessage = '';
    notifyListeners();
    try {
      (bool, String) response = await ApiClient().postRequest(
        'orders/$orderId/return',
        context: context,
        body: {'reason': reason},
        requestName: 'initiateReturn',
        printResponseBody: true,
      );
      loading = false;
      if (response.$1) {
        lastAction = OrderActionModel.fromJson(json.decode(response.$2));
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