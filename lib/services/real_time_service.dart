
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../utils/functions.dart';
import '../resources/constants/endpoints.dart';

class RealTimeService {
  static final RealTimeService _instance = RealTimeService._internal();
  factory RealTimeService() => _instance;
  RealTimeService._internal();

  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;
  
  // Stream controllers for different real-time events
  final StreamController<Map<String, dynamic>> _orderUpdatesController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _inventoryUpdatesController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _chatController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _analyticsUpdatesController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _locationUpdatesController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();

  // Getters for streams
  Stream<Map<String, dynamic>> get orderUpdates => _orderUpdatesController.stream;
  Stream<Map<String, dynamic>> get inventoryUpdates => _inventoryUpdatesController.stream;
  Stream<Map<String, dynamic>> get notifications => _notificationController.stream;
  Stream<Map<String, dynamic>> get chatMessages => _chatController.stream;
  Stream<Map<String, dynamic>> get analyticsUpdates => _analyticsUpdatesController.stream;
  Stream<Map<String, dynamic>> get locationUpdates => _locationUpdatesController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      final token = getToken();
      final wsUrl = basedURL.replaceFirst('http', 'ws') + '/ws?token=$token';
      
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnection,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStatusController.add(true);
      
      // Start heartbeat
      _startHeartbeat();
      
      log('WebSocket connected successfully');
    } catch (e) {
      log('WebSocket connection failed: $e');
      _handleReconnection();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = json.decode(message);
      final eventType = data['type'] as String?;
      final payload = data['payload'] as Map<String, dynamic>?;

      if (payload == null) return;

      switch (eventType) {
        case 'order_update':
          _orderUpdatesController.add(payload);
          break;
        case 'inventory_update':
          _inventoryUpdatesController.add(payload);
          break;
        case 'notification':
          _notificationController.add(payload);
          break;
        case 'chat_message':
          _chatController.add(payload);
          break;
        case 'analytics_update':
          _analyticsUpdatesController.add(payload);
          break;
        case 'location_update':
          _locationUpdatesController.add(payload);
          break;
        case 'pong':
          // Heartbeat response
          break;
        default:
          log('Unknown message type: $eventType');
      }
    } catch (e) {
      log('Error parsing WebSocket message: $e');
    }
  }

  void _handleError(error) {
    log('WebSocket error: $error');
    _isConnected = false;
    _connectionStatusController.add(false);
    _handleReconnection();
  }

  void _handleDisconnection() {
    log('WebSocket disconnected');
    _isConnected = false;
    _connectionStatusController.add(false);
    _stopHeartbeat();
    _handleReconnection();
  }

  void _handleReconnection() {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      log('Max reconnection attempts reached');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      log('Attempting to reconnect... (${_reconnectAttempts}/$maxReconnectAttempts)');
      connect();
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected && _channel != null) {
        sendMessage('ping', {});
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void sendMessage(String type, Map<String, dynamic> payload) {
    if (!_isConnected || _channel == null) {
      log('Cannot send message: WebSocket not connected');
      return;
    }

    try {
      final message = json.encode({
        'type': type,
        'payload': payload,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      _channel!.sink.add(message);
    } catch (e) {
      log('Error sending WebSocket message: $e');
    }
  }

  // Specific methods for different real-time events
  void subscribeToOrderUpdates(String userId) {
    sendMessage('subscribe_orders', {'user_id': userId});
  }

  void subscribeToInventoryUpdates(String vendorId) {
    sendMessage('subscribe_inventory', {'vendor_id': vendorId});
  }

  void subscribeToNotifications(String userId) {
    sendMessage('subscribe_notifications', {'user_id': userId});
  }

  void subscribeToChat(String chatId) {
    sendMessage('subscribe_chat', {'chat_id': chatId});
  }

  void subscribeToAnalytics(String vendorId) {
    sendMessage('subscribe_analytics', {'vendor_id': vendorId});
  }

  void subscribeToLocationUpdates(String userId) {
    sendMessage('subscribe_location', {'user_id': userId});
  }

  void sendChatMessage(String chatId, String message, String senderId) {
    sendMessage('chat_message', {
      'chat_id': chatId,
      'message': message,
      'sender_id': senderId,
    });
  }

  void updateLocation(double latitude, double longitude, String userId) {
    sendMessage('location_update', {
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  void updateOrderStatus(String orderId, String status) {
    sendMessage('order_status_update', {
      'order_id': orderId,
      'status': status,
    });
  }

  void updateInventory(String itemId, int quantity) {
    sendMessage('inventory_update', {
      'item_id': itemId,
      'quantity': quantity,
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _stopHeartbeat();
    
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _connectionStatusController.add(false);
    _reconnectAttempts = 0;
    
    log('WebSocket disconnected manually');
  }

  void dispose() {
    disconnect();
    _orderUpdatesController.close();
    _inventoryUpdatesController.close();
    _notificationController.close();
    _chatController.close();
    _analyticsUpdatesController.close();
    _locationUpdatesController.close();
    _connectionStatusController.close();
  }
}
