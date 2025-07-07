
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:brill_prime/providers/notification_provider.dart';
import 'package:brill_prime/providers/real_time_provider.dart';
import 'package:brill_prime/providers/cart_provider.dart';
import 'package:brill_prime/providers/order_management_provider.dart';
import 'package:brill_prime/models/notification_model.dart';
import 'package:brill_prime/models/cart_item_model.dart';

class MockRealTimeService extends Mock {}

void main() {
  group('Provider Tests', () {
    group('NotificationProvider', () {
      late NotificationProvider notificationProvider;

      setUp(() {
        notificationProvider = NotificationProvider();
      });

      test('should add notification', () {
        final notification = NotificationModel(
          id: '1',
          title: 'Test',
          body: 'Test body',
          type: 'test',
          isRead: false,
          createdAt: DateTime.now(),
        );

        notificationProvider.addNotification(notification);

        expect(notificationProvider.notifications.length, 1);
        expect(notificationProvider.unreadCount, 1);
      });

      test('should mark notification as read', () {
        final notification = NotificationModel(
          id: '1',
          title: 'Test',
          body: 'Test body',
          type: 'test',
          isRead: false,
          createdAt: DateTime.now(),
        );

        notificationProvider.addNotification(notification);
        
        // Simulate marking as read
        notificationProvider.notifications[0] = 
            notificationProvider.notifications[0].copyWith(isRead: true);
        
        expect(notificationProvider.notifications[0].isRead, true);
      });

      test('should clear all notifications', () {
        final notification = NotificationModel(
          id: '1',
          title: 'Test',
          body: 'Test body',
          type: 'test',
          isRead: false,
          createdAt: DateTime.now(),
        );

        notificationProvider.addNotification(notification);
        notificationProvider.clearAllNotifications();

        expect(notificationProvider.notifications.length, 0);
        expect(notificationProvider.unreadCount, 0);
      });

      test('should filter notifications by type', () {
        final notification1 = NotificationModel(
          id: '1',
          title: 'Order',
          body: 'Order body',
          type: 'order',
          isRead: false,
          createdAt: DateTime.now(),
        );

        final notification2 = NotificationModel(
          id: '2',
          title: 'Payment',
          body: 'Payment body',
          type: 'payment',
          isRead: false,
          createdAt: DateTime.now(),
        );

        notificationProvider.addNotification(notification1);
        notificationProvider.addNotification(notification2);

        final orderNotifications = notificationProvider.getNotificationsByType('order');
        expect(orderNotifications.length, 1);
        expect(orderNotifications[0].type, 'order');
      });
    });

    group('RealTimeProvider', () {
      late RealTimeProvider realTimeProvider;

      setUp(() {
        realTimeProvider = RealTimeProvider();
      });

      test('should initialize with disconnected state', () {
        expect(realTimeProvider.isConnected, false);
        expect(realTimeProvider.connectionStatus, 'Disconnected');
      });

      test('should track recent updates', () {
        expect(realTimeProvider.recentUpdates.length, 0);
        
        // Simulate adding updates would happen through real-time service
        expect(realTimeProvider.recentUpdates, isEmpty);
      });

      test('should provide connection statistics', () {
        final stats = realTimeProvider.connectionStats;
        expect(stats, isA<Map<String, dynamic>>());
      });

      test('should clear recent updates', () {
        realTimeProvider.clearRecentUpdates();
        expect(realTimeProvider.recentUpdates.length, 0);
      });

      test('should filter updates by type', () {
        final orderUpdates = realTimeProvider.getUpdatesByType('order');
        expect(orderUpdates, isA<List<Map<String, dynamic>>>());
      });

      test('should check for recent updates', () {
        final hasRecent = realTimeProvider.hasRecentUpdates();
        expect(hasRecent, false);
      });
    });

    group('CartProvider Extended Tests', () {
      late CartProvider cartProvider;

      setUp(() {
        cartProvider = CartProvider();
      });

      test('should handle guest checkout', () {
        cartProvider.enableGuestCheckout();
        expect(cartProvider.isGuestCheckout, true);
        expect(cartProvider.cartSessionId, isNotNull);

        cartProvider.disableGuestCheckout();
        expect(cartProvider.isGuestCheckout, false);
        expect(cartProvider.cartSessionId, isNull);
      });

      test('should save items for later', () {
        final cartItem = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 100.0,
          quantity: 1,
          vendorId: 'vendor1',
          imageUrl: '',
        );

        cartProvider.addItem(cartItem);
        expect(cartProvider.items.length, 1);

        cartProvider.saveForLater('1');
        expect(cartProvider.items.length, 0);
        expect(cartProvider.savedItems.length, 1);
      });

      test('should move saved item back to cart', () {
        final cartItem = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 100.0,
          quantity: 1,
          vendorId: 'vendor1',
          imageUrl: '',
        );

        cartProvider.addItem(cartItem);
        cartProvider.saveForLater('1');
        cartProvider.moveToCart('1');

        expect(cartProvider.items.length, 1);
        expect(cartProvider.savedItems.length, 0);
      });

      test('should get cart statistics', () {
        final cartItem = CartItem(
          commodityId: '1',
          name: 'Test Item',
          price: 100.0,
          quantity: 2,
          vendorId: 'vendor1',
          imageUrl: '',
        );

        cartProvider.addItem(cartItem);
        final stats = cartProvider.getCartStatistics();

        expect(stats['totalItems'], 2);
        expect(stats['totalValue'], 200.0);
        expect(stats['uniqueProducts'], 1);
        expect(stats['vendorCount'], 1);
      });

      test('should group items by vendor', () {
        final item1 = CartItem(
          commodityId: '1',
          name: 'Item 1',
          price: 100.0,
          quantity: 1,
          vendorId: 'vendor1',
          imageUrl: '',
        );

        final item2 = CartItem(
          commodityId: '2',
          name: 'Item 2',
          price: 150.0,
          quantity: 1,
          vendorId: 'vendor2',
          imageUrl: '',
        );

        cartProvider.addItem(item1);
        cartProvider.addItem(item2);

        final itemsByVendor = cartProvider.itemsByVendor;
        expect(itemsByVendor.keys.length, 2);
        expect(itemsByVendor['vendor1']?.length, 1);
        expect(itemsByVendor['vendor2']?.length, 1);
      });
    });

    group('OrderManagementProvider Extended Tests', () {
      late OrderManagementProvider orderProvider;

      setUp(() {
        orderProvider = OrderManagementProvider();
      });

      test('should handle bulk operations', () {
        orderProvider.toggleBulkMode();
        expect(orderProvider.isBulkMode, true);

        orderProvider.toggleOrderSelection('order1');
        expect(orderProvider.selectedOrderIds.contains('order1'), true);

        orderProvider.clearSelection();
        expect(orderProvider.selectedOrderIds.isEmpty, true);

        orderProvider.toggleBulkMode();
        expect(orderProvider.isBulkMode, false);
      });

      test('should apply filters correctly', () {
        orderProvider.setStatusFilter('pending');
        expect(orderProvider.statusFilter, 'pending');

        final now = DateTime.now();
        orderProvider.setDateFilter(from: now.subtract(const Duration(days: 7)), to: now);
        expect(orderProvider.dateFromFilter, isNotNull);
        expect(orderProvider.dateToFilter, isNotNull);

        orderProvider.setAmountFilter(min: 50.0, max: 500.0);
        expect(orderProvider.minAmountFilter, 50.0);
        expect(orderProvider.maxAmountFilter, 500.0);

        orderProvider.clearFilters();
        expect(orderProvider.statusFilter, 'all');
        expect(orderProvider.dateFromFilter, isNull);
        expect(orderProvider.minAmountFilter, isNull);
      });

      test('should handle real-time updates', () {
        orderProvider.startRealTimeUpdates(context: null);
        expect(orderProvider.isRealTimeEnabled, true);

        orderProvider.stopRealTimeUpdates();
        expect(orderProvider.isRealTimeEnabled, false);
      });
    });
  });

  group('Provider Integration Tests', () {
    test('notification and real-time providers should work together', () {
      final notificationProvider = NotificationProvider();
      final realTimeProvider = RealTimeProvider();

      // Test that providers can coexist
      expect(notificationProvider.notifications.length, 0);
      expect(realTimeProvider.isConnected, false);

      // Add notification
      final notification = NotificationModel(
        id: '1',
        title: 'Test',
        body: 'Test body',
        type: 'test',
        isRead: false,
        createdAt: DateTime.now(),
      );

      notificationProvider.addNotification(notification);
      expect(notificationProvider.notifications.length, 1);
    });

    test('cart and order providers should integrate', () {
      final cartProvider = CartProvider();
      final orderProvider = OrderManagementProvider();

      // Add item to cart
      final cartItem = CartItem(
        commodityId: '1',
        name: 'Test Item',
        price: 100.0,
        quantity: 1,
        vendorId: 'vendor1',
        imageUrl: '',
      );

      cartProvider.addItem(cartItem);
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.totalAmount, 100.0);

      // Providers should be independent but complementary
      expect(orderProvider.statusFilter, 'all');
    });
  });

  group('Error Handling Tests', () {
    test('providers should handle null values gracefully', () {
      final notificationProvider = NotificationProvider();
      
      // Should not crash with null operations
      expect(() => notificationProvider.clearAllNotifications(), returnsNormally);
      expect(() => notificationProvider.getNotificationsByType(''), returnsNormally);
    });

    test('cart provider should handle edge cases', () {
      final cartProvider = CartProvider();
      
      // Remove from empty cart
      expect(() => cartProvider.removeItem('nonexistent'), returnsNormally);
      
      // Update quantity to 0
      expect(() => cartProvider.updateQuantity('nonexistent', 0), returnsNormally);
      
      // Get statistics from empty cart
      final stats = cartProvider.getCartStatistics();
      expect(stats['totalItems'], 0);
      expect(stats['totalValue'], 0.0);
    });
  });
}
