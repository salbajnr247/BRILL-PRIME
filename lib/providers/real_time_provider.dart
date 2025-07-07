
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../services/real_time_service.dart';
import '../models/notification_model.dart';
import '../models/vendor_order_model.dart';
import '../models/commodities_model.dart';

class RealTimeProvider with ChangeNotifier {
  final RealTimeService _realTimeService = RealTimeService();
  
  // Connection status
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Real-time data
  List<NotificationModel> _notifications = [];
  List<VendorOrderModel> _orders = [];
  List<CommoditiesModel> _inventory = [];
  Map<String, dynamic> _analytics = {};
  Map<String, List<Map<String, dynamic>>> _chatMessages = {};
  
  // Getters
  List<NotificationModel> get notifications => _notifications;
  List<VendorOrderModel> get orders => _orders;
  List<CommoditiesModel> get inventory => _inventory;
  Map<String, dynamic> get analytics => _analytics;
  Map<String, List<Map<String, dynamic>>> get chatMessages => _chatMessages;

  // Stream subscriptions
  late StreamSubscription _connectionStatusSubscription;
  late StreamSubscription _notificationSubscription;
  late StreamSubscription _orderUpdatesSubscription;
  late StreamSubscription _inventoryUpdatesSubscription;
  late StreamSubscription _analyticsUpdatesSubscription;
  late StreamSubscription _chatSubscription;

  RealTimeProvider() {
    _initializeSubscriptions();
  }

  void _initializeSubscriptions() {
    // Connection status
    _connectionStatusSubscription = _realTimeService.connectionStatus.listen((isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    });

    // Notifications
    _notificationSubscription = _realTimeService.notifications.listen((data) {
      try {
        final notification = NotificationModel.fromJson(data);
        _notifications.insert(0, notification);
        notifyListeners();
        
        // Show local notification
        _showLocalNotification(notification);
      } catch (e) {
        debugPrint('Error parsing notification: $e');
      }
    });

    // Order updates
    _orderUpdatesSubscription = _realTimeService.orderUpdates.listen((data) {
      try {
        final orderId = data['order_id'] as String?;
        final status = data['status'] as String?;
        
        if (orderId != null) {
          // Update existing order or add new one
          final existingIndex = _orders.indexWhere((order) => order.id == orderId);
          if (existingIndex != -1) {
            // Update existing order
            if (status != null) {
              // Create updated order with new status
              final updatedOrder = VendorOrderModel(
                id: _orders[existingIndex].id,
                status: status,
                // Copy other properties...
              );
              _orders[existingIndex] = updatedOrder;
            }
          } else {
            // Add new order
            final newOrder = VendorOrderModel.fromJson(data);
            _orders.insert(0, newOrder);
          }
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error parsing order update: $e');
      }
    });

    // Inventory updates
    _inventoryUpdatesSubscription = _realTimeService.inventoryUpdates.listen((data) {
      try {
        final itemId = data['item_id'] as String?;
        final quantity = data['quantity'] as int?;
        
        if (itemId != null && quantity != null) {
          // Update existing inventory item
          final existingIndex = _inventory.indexWhere((item) => item.id == itemId);
          if (existingIndex != -1) {
            // Update quantity
            final updatedItem = CommoditiesModel(
              id: _inventory[existingIndex].id,
              quantity: quantity,
              // Copy other properties...
            );
            _inventory[existingIndex] = updatedItem;
            notifyListeners();
          }
        }
      } catch (e) {
        debugPrint('Error parsing inventory update: $e');
      }
    });

    // Analytics updates
    _analyticsUpdatesSubscription = _realTimeService.analyticsUpdates.listen((data) {
      _analytics = data;
      notifyListeners();
    });

    // Chat messages
    _chatSubscription = _realTimeService.chatMessages.listen((data) {
      final chatId = data['chat_id'] as String?;
      if (chatId != null) {
        if (!_chatMessages.containsKey(chatId)) {
          _chatMessages[chatId] = [];
        }
        _chatMessages[chatId]!.add(data);
        notifyListeners();
      }
    });
  }

  void _showLocalNotification(NotificationModel notification) {
    // Implementation depends on your notification setup
    debugPrint('New notification: ${notification.title}');
  }

  // Connection methods
  Future<void> connect() async {
    await _realTimeService.connect();
  }

  void disconnect() {
    _realTimeService.disconnect();
  }

  // Subscription methods
  void subscribeToOrderUpdates(String userId) {
    _realTimeService.subscribeToOrderUpdates(userId);
  }

  void subscribeToInventoryUpdates(String vendorId) {
    _realTimeService.subscribeToInventoryUpdates(vendorId);
  }

  void subscribeToNotifications(String userId) {
    _realTimeService.subscribeToNotifications(userId);
  }

  void subscribeToChat(String chatId) {
    _realTimeService.subscribeToChat(chatId);
  }

  void subscribeToAnalytics(String vendorId) {
    _realTimeService.subscribeToAnalytics(vendorId);
  }

  // Action methods
  void sendChatMessage(String chatId, String message, String senderId) {
    _realTimeService.sendChatMessage(chatId, message, senderId);
  }

  void updateOrderStatus(String orderId, String status) {
    _realTimeService.updateOrderStatus(orderId, status);
  }

  void updateInventory(String itemId, int quantity) {
    _realTimeService.updateInventory(itemId, quantity);
  }

  void updateLocation(double latitude, double longitude, String userId) {
    _realTimeService.updateLocation(latitude, longitude, userId);
  }

  // Clear methods
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // Update notification as read
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectionStatusSubscription.cancel();
    _notificationSubscription.cancel();
    _orderUpdatesSubscription.cancel();
    _inventoryUpdatesSubscription.cancel();
    _analyticsUpdatesSubscription.cancel();
    _chatSubscription.cancel();
    _realTimeService.dispose();
    super.dispose();
  }
}
