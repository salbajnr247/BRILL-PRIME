import 'package:flutter/material.dart';
import '../models/order_action_model.dart';
import '../models/consumer_order_model.dart';
import '../services/api_client.dart';
import 'dart:convert';
import 'dart:async';

class OrderManagementProvider extends ChangeNotifier {
  OrderActionModel? lastAction;
  String orderStatus = '';
  bool loading = false;
  String errorMessage = '';
  
  // Real-time updates
  List<ConsumerOrderData> orders = [];
  Timer? _realTimeUpdateTimer;
  bool isRealTimeEnabled = false;
  
  // Advanced filtering
  String statusFilter = 'all';
  DateTime? dateFromFilter;
  DateTime? dateToFilter;
  double? minAmountFilter;
  double? maxAmountFilter;
  List<ConsumerOrderData> filteredOrders = [];
  
  // Bulk processing
  Set<String> selectedOrderIds = {};
  bool isBulkMode = false;
  bool bulkProcessing = false;

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

  // Real-time order updates
  void startRealTimeUpdates({required BuildContext context}) {
    if (_realTimeUpdateTimer != null) return;
    
    isRealTimeEnabled = true;
    _realTimeUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchAllOrders(context: context);
    });
    notifyListeners();
  }

  void stopRealTimeUpdates() {
    _realTimeUpdateTimer?.cancel();
    _realTimeUpdateTimer = null;
    isRealTimeEnabled = false;
    notifyListeners();
  }

  Future<void> fetchAllOrders({required BuildContext context}) async {
    try {
      (bool, String) response = await ApiClient().getRequest(
        'orders',
        context: context,
        requestName: 'fetchAllOrders',
        printResponseBody: true,
      );
      
      if (response.$1) {
        final orderModel = ConsumerOrderModel.fromJson(json.decode(response.$2));
        orders = orderModel.data;
        applyFilters();
      } else {
        errorMessage = response.$2;
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Advanced filtering
  void setStatusFilter(String status) {
    statusFilter = status;
    applyFilters();
    notifyListeners();
  }

  void setDateFilter({DateTime? from, DateTime? to}) {
    dateFromFilter = from;
    dateToFilter = to;
    applyFilters();
    notifyListeners();
  }

  void setAmountFilter({double? min, double? max}) {
    minAmountFilter = min;
    maxAmountFilter = max;
    applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    statusFilter = 'all';
    dateFromFilter = null;
    dateToFilter = null;
    minAmountFilter = null;
    maxAmountFilter = null;
    applyFilters();
    notifyListeners();
  }

  void applyFilters() {
    filteredOrders = orders.where((order) {
      // Status filter
      if (statusFilter != 'all' && order.status != statusFilter) {
        return false;
      }
      
      // Date filter
      if (dateFromFilter != null && order.createdAt.isBefore(dateFromFilter!)) {
        return false;
      }
      if (dateToFilter != null && order.createdAt.isAfter(dateToFilter!)) {
        return false;
      }
      
      // Amount filter
      final totalPrice = double.tryParse(order.totalPrice.toString()) ?? 0.0;
      if (minAmountFilter != null && totalPrice < minAmountFilter!) {
        return false;
      }
      if (maxAmountFilter != null && totalPrice > maxAmountFilter!) {
        return false;
      }
      
      return true;
    }).toList();
  }

  // Bulk processing
  void toggleBulkMode() {
    isBulkMode = !isBulkMode;
    if (!isBulkMode) {
      selectedOrderIds.clear();
    }
    notifyListeners();
  }

  void toggleOrderSelection(String orderId) {
    if (selectedOrderIds.contains(orderId)) {
      selectedOrderIds.remove(orderId);
    } else {
      selectedOrderIds.add(orderId);
    }
    notifyListeners();
  }

  void selectAllOrders() {
    selectedOrderIds = filteredOrders.map((order) => order.id.toString()).toSet();
    notifyListeners();
  }

  void clearSelection() {
    selectedOrderIds.clear();
    notifyListeners();
  }

  Future<bool> bulkCancelOrders({required BuildContext context}) async {
    if (selectedOrderIds.isEmpty) return false;
    
    bulkProcessing = true;
    errorMessage = '';
    notifyListeners();
    
    try {
      (bool, String) response = await ApiClient().postRequest(
        'orders/bulk-cancel',
        context: context,
        body: {'orderIds': selectedOrderIds.toList()},
        requestName: 'bulkCancelOrders',
        printResponseBody: true,
      );
      
      bulkProcessing = false;
      if (response.$1) {
        selectedOrderIds.clear();
        fetchAllOrders(context: context);
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      bulkProcessing = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> bulkUpdateStatus({required BuildContext context, required String status}) async {
    if (selectedOrderIds.isEmpty) return false;
    
    bulkProcessing = true;
    errorMessage = '';
    notifyListeners();
    
    try {
      (bool, String) response = await ApiClient().patchRequest(
        'orders/bulk-update-status',
        context: context,
        body: {
          'orderIds': selectedOrderIds.toList(),
          'status': status
        },
        requestName: 'bulkUpdateStatus',
        printResponseBody: true,
      );
      
      bulkProcessing = false;
      if (response.$1) {
        selectedOrderIds.clear();
        fetchAllOrders(context: context);
        return true;
      } else {
        errorMessage = response.$2;
        notifyListeners();
        return false;
      }
    } catch (e) {
      bulkProcessing = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    stopRealTimeUpdates();
    super.dispose();
  }
} 