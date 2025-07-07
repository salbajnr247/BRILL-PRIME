
import 'package:flutter/foundation.dart';
import '../services/real_time_service.dart';
import '../models/notification_model.dart';

class RealTimeProvider extends ChangeNotifier {
  final RealTimeService _realTimeService = RealTimeService();
  
  bool _isConnected = false;
  String _connectionStatus = 'Disconnected';
  List<Map<String, dynamic>> _recentUpdates = [];
  Map<String, dynamic> _connectionStats = {};
  
  // Connection state
  bool get isConnected => _isConnected;
  String get connectionStatus => _connectionStatus;
  List<Map<String, dynamic>> get recentUpdates => _recentUpdates;
  Map<String, dynamic> get connectionStats => _connectionStats;

  RealTimeProvider() {
    _setupConnectionListener();
  }

  void _setupConnectionListener() {
    _realTimeService.connectionStatus.listen((isConnected) {
      _isConnected = isConnected;
      _connectionStatus = isConnected ? 'Connected' : 'Disconnected';
      _updateConnectionStats();
      notifyListeners();
    });
    
    // Listen to all real-time events for tracking
    _setupEventListeners();
  }

  void _setupEventListeners() {
    // Order updates
    _realTimeService.orderUpdates.listen((update) {
      _addRecentUpdate('order', update);
    });
    
    // Inventory updates
    _realTimeService.inventoryUpdates.listen((update) {
      _addRecentUpdate('inventory', update);
    });
    
    // Notifications
    _realTimeService.notifications.listen((notification) {
      _addRecentUpdate('notification', notification);
    });
    
    // Chat messages
    _realTimeService.chatMessages.listen((message) {
      _addRecentUpdate('chat', message);
    });
    
    // Analytics updates
    _realTimeService.analyticsUpdates.listen((analytics) {
      _addRecentUpdate('analytics', analytics);
    });
    
    // Location updates
    _realTimeService.locationUpdates.listen((location) {
      _addRecentUpdate('location', location);
    });
  }

  void _addRecentUpdate(String type, Map<String, dynamic> data) {
    final update = {
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _recentUpdates.insert(0, update);
    
    // Keep only last 50 updates
    if (_recentUpdates.length > 50) {
      _recentUpdates = _recentUpdates.take(50).toList();
    }
    
    _updateConnectionStats();
    notifyListeners();
  }

  void _updateConnectionStats() {
    final now = DateTime.now();
    final oneHourAgo = now.subtract(const Duration(hours: 1));
    
    final recentUpdatesCount = _recentUpdates.where((update) {
      final timestamp = DateTime.tryParse(update['timestamp'] ?? '');
      return timestamp != null && timestamp.isAfter(oneHourAgo);
    }).length;
    
    _connectionStats = {
      'isConnected': _isConnected,
      'lastConnectionTime': now.toIso8601String(),
      'recentUpdatesCount': recentUpdatesCount,
      'totalUpdatesReceived': _recentUpdates.length,
      'updateTypes': _getUpdateTypeCounts(),
    };
  }

  Map<String, int> _getUpdateTypeCounts() {
    final counts = <String, int>{};
    for (final update in _recentUpdates) {
      final type = update['type'] as String;
      counts[type] = (counts[type] ?? 0) + 1;
    }
    return counts;
  }

  // Connection management
  Future<void> connect() async {
    try {
      await _realTimeService.connect();
      _connectionStatus = 'Connecting...';
      notifyListeners();
    } catch (e) {
      _connectionStatus = 'Connection Failed';
      notifyListeners();
      debugPrint('Real-time connection failed: $e');
    }
  }

  void disconnect() {
    _realTimeService.disconnect();
    _connectionStatus = 'Disconnected';
    _isConnected = false;
    notifyListeners();
  }

  // Subscription management
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

  void subscribeToLocationUpdates(String userId) {
    _realTimeService.subscribeToLocationUpdates(userId);
  }

  // Send methods
  void sendChatMessage(String chatId, String message, String senderId) {
    _realTimeService.sendChatMessage(chatId, message, senderId);
  }

  void updateLocation(double latitude, double longitude, String userId) {
    _realTimeService.updateLocation(latitude, longitude, userId);
  }

  void updateOrderStatus(String orderId, String status) {
    _realTimeService.updateOrderStatus(orderId, status);
  }

  void updateInventory(String itemId, int quantity) {
    _realTimeService.updateInventory(itemId, quantity);
  }

  // Utility methods
  void clearRecentUpdates() {
    _recentUpdates.clear();
    _updateConnectionStats();
    notifyListeners();
  }

  List<Map<String, dynamic>> getUpdatesByType(String type) {
    return _recentUpdates
        .where((update) => update['type'] == type)
        .toList();
  }

  bool hasRecentUpdates({Duration? within}) {
    within ??= const Duration(minutes: 5);
    final cutoff = DateTime.now().subtract(within);
    
    return _recentUpdates.any((update) {
      final timestamp = DateTime.tryParse(update['timestamp'] ?? '');
      return timestamp != null && timestamp.isAfter(cutoff);
    });
  }

  @override
  void dispose() {
    _realTimeService.dispose();
    super.dispose();
  }
}
