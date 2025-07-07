
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';
import 'dart:async';

import '../../lib/providers/order_management_provider.dart';
import '../../lib/services/api_client.dart';
import '../../lib/models/consumer_order_model.dart';
import '../../lib/models/order_action_model.dart';

// Generate mocks
@GenerateMocks([ApiClient, BuildContext])
import 'order_management_provider_test.mocks.dart';

void main() {
  group('OrderManagementProvider Tests', () {
    late OrderManagementProvider provider;
    late MockApiClient mockApiClient;
    late MockBuildContext mockContext;

    setUp(() {
      provider = OrderManagementProvider();
      mockApiClient = MockApiClient();
      mockContext = MockBuildContext();
    });

    tearDown(() {
      provider.dispose();
    });

    group('Real-time Updates', () {
      test('should start real-time updates', () {
        provider.startRealTimeUpdates(context: mockContext);
        
        expect(provider.isRealTimeEnabled, true);
        expect(provider.realTimeUpdateTimer, isNotNull);
      });

      test('should stop real-time updates', () {
        provider.startRealTimeUpdates(context: mockContext);
        provider.stopRealTimeUpdates();
        
        expect(provider.isRealTimeEnabled, false);
        expect(provider.realTimeUpdateTimer, isNull);
      });

      test('should not start multiple timers', () {
        provider.startRealTimeUpdates(context: mockContext);
        final firstTimer = provider.realTimeUpdateTimer;
        
        provider.startRealTimeUpdates(context: mockContext);
        final secondTimer = provider.realTimeUpdateTimer;
        
        expect(firstTimer, equals(secondTimer));
      });
    });

    group('Advanced Filtering', () {
      setUp(() {
        // Setup mock orders data
        provider.orders = [
          ConsumerOrderData(
            id: 1,
            status: 'pending',
            totalPrice: 100.0,
            createdAt: DateTime(2024, 1, 1),
          ),
          ConsumerOrderData(
            id: 2,
            status: 'shipped',
            totalPrice: 200.0,
            createdAt: DateTime(2024, 1, 15),
          ),
          ConsumerOrderData(
            id: 3,
            status: 'delivered',
            totalPrice: 50.0,
            createdAt: DateTime(2024, 2, 1),
          ),
        ];
      });

      test('should filter by status', () {
        provider.setStatusFilter('pending');
        
        expect(provider.statusFilter, 'pending');
        expect(provider.filteredOrders.length, 1);
        expect(provider.filteredOrders.first.status, 'pending');
      });

      test('should filter by date range', () {
        final fromDate = DateTime(2024, 1, 10);
        final toDate = DateTime(2024, 1, 20);
        
        provider.setDateFilter(from: fromDate, to: toDate);
        
        expect(provider.dateFromFilter, fromDate);
        expect(provider.dateToFilter, toDate);
        expect(provider.filteredOrders.length, 1);
        expect(provider.filteredOrders.first.id, 2);
      });

      test('should filter by amount range', () {
        provider.setAmountFilter(min: 75.0, max: 150.0);
        
        expect(provider.minAmountFilter, 75.0);
        expect(provider.maxAmountFilter, 150.0);
        expect(provider.filteredOrders.length, 1);
        expect(provider.filteredOrders.first.totalPrice, 100.0);
      });

      test('should clear all filters', () {
        provider.setStatusFilter('pending');
        provider.setAmountFilter(min: 50.0, max: 150.0);
        
        provider.clearFilters();
        
        expect(provider.statusFilter, 'all');
        expect(provider.minAmountFilter, isNull);
        expect(provider.maxAmountFilter, isNull);
        expect(provider.filteredOrders.length, 3);
      });

      test('should apply multiple filters simultaneously', () {
        provider.setStatusFilter('pending');
        provider.setAmountFilter(min: 50.0, max: 150.0);
        
        expect(provider.filteredOrders.length, 1);
        expect(provider.filteredOrders.first.status, 'pending');
        expect(provider.filteredOrders.first.totalPrice, 100.0);
      });
    });

    group('Bulk Processing', () {
      test('should toggle bulk mode', () {
        expect(provider.isBulkMode, false);
        
        provider.toggleBulkMode();
        expect(provider.isBulkMode, true);
        
        provider.toggleBulkMode();
        expect(provider.isBulkMode, false);
      });

      test('should clear selection when exiting bulk mode', () {
        provider.selectedOrderIds.add('1');
        provider.selectedOrderIds.add('2');
        provider.isBulkMode = true;
        
        provider.toggleBulkMode();
        
        expect(provider.isBulkMode, false);
        expect(provider.selectedOrderIds.isEmpty, true);
      });

      test('should toggle order selection', () {
        provider.toggleOrderSelection('1');
        expect(provider.selectedOrderIds.contains('1'), true);
        
        provider.toggleOrderSelection('1');
        expect(provider.selectedOrderIds.contains('1'), false);
      });

      test('should select all orders', () {
        provider.filteredOrders = [
          ConsumerOrderData(id: 1, status: 'pending', totalPrice: 100.0, createdAt: DateTime.now()),
          ConsumerOrderData(id: 2, status: 'shipped', totalPrice: 200.0, createdAt: DateTime.now()),
        ];
        
        provider.selectAllOrders();
        
        expect(provider.selectedOrderIds.length, 2);
        expect(provider.selectedOrderIds.contains('1'), true);
        expect(provider.selectedOrderIds.contains('2'), true);
      });

      test('should clear selection', () {
        provider.selectedOrderIds.addAll(['1', '2', '3']);
        
        provider.clearSelection();
        
        expect(provider.selectedOrderIds.isEmpty, true);
      });
    });

    group('Order Actions', () {
      test('should cancel order successfully', () async {
        when(mockApiClient.patchRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"status": "cancelled", "message": "Order cancelled"}'));
        
        // Mock the ApiClient instance in provider
        provider.apiClient = mockApiClient;
        
        final result = await provider.cancelOrder(
          context: mockContext,
          orderId: '123',
        );
        
        expect(result, true);
        expect(provider.loading, false);
        expect(provider.errorMessage, '');
      });

      test('should handle cancel order failure', () async {
        when(mockApiClient.patchRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (false, 'Order not found'));
        
        provider.apiClient = mockApiClient;
        
        final result = await provider.cancelOrder(
          context: mockContext,
          orderId: '123',
        );
        
        expect(result, false);
        expect(provider.loading, false);
        expect(provider.errorMessage, 'Order not found');
      });

      test('should initiate return successfully', () async {
        when(mockApiClient.postRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"status": "return_initiated", "message": "Return initiated"}'));
        
        provider.apiClient = mockApiClient;
        
        final result = await provider.initiateReturn(
          context: mockContext,
          orderId: '123',
          reason: 'Defective product',
        );
        
        expect(result, true);
        expect(provider.loading, false);
      });

      test('should track order status successfully', () async {
        when(mockApiClient.getRequest(
          any,
          context: anyNamed('context'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"status": "shipped", "message": "Order is shipped"}'));
        
        provider.apiClient = mockApiClient;
        
        await provider.trackOrderStatus(
          context: mockContext,
          orderId: '123',
        );
        
        expect(provider.orderStatus, 'shipped');
        expect(provider.loading, false);
      });
    });

    group('Bulk Operations', () {
      setUp(() {
        provider.selectedOrderIds.addAll(['1', '2', '3']);
      });

      test('should perform bulk cancel successfully', () async {
        when(mockApiClient.postRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"success": true, "message": "Orders cancelled"}'));
        
        when(mockApiClient.getRequest(
          any,
          context: anyNamed('context'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"data": []}'));
        
        provider.apiClient = mockApiClient;
        
        final result = await provider.bulkCancelOrders(context: mockContext);
        
        expect(result, true);
        expect(provider.bulkProcessing, false);
        expect(provider.selectedOrderIds.isEmpty, true);
      });

      test('should handle bulk cancel failure', () async {
        when(mockApiClient.postRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (false, 'Failed to cancel orders'));
        
        provider.apiClient = mockApiClient;
        
        final result = await provider.bulkCancelOrders(context: mockContext);
        
        expect(result, false);
        expect(provider.bulkProcessing, false);
        expect(provider.errorMessage, 'Failed to cancel orders');
      });

      test('should perform bulk status update successfully', () async {
        when(mockApiClient.patchRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"success": true, "message": "Status updated"}'));
        
        when(mockApiClient.getRequest(
          any,
          context: anyNamed('context'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"data": []}'));
        
        provider.apiClient = mockApiClient;
        
        final result = await provider.bulkUpdateStatus(
          context: mockContext,
          status: 'shipped',
        );
        
        expect(result, true);
        expect(provider.bulkProcessing, false);
        expect(provider.selectedOrderIds.isEmpty, true);
      });

      test('should return false for bulk operations with no selection', () async {
        provider.selectedOrderIds.clear();
        
        final cancelResult = await provider.bulkCancelOrders(context: mockContext);
        final updateResult = await provider.bulkUpdateStatus(
          context: mockContext,
          status: 'shipped',
        );
        
        expect(cancelResult, false);
        expect(updateResult, false);
      });
    });

    group('Error Handling', () {
      test('should handle network errors gracefully', () async {
        when(mockApiClient.getRequest(
          any,
          context: anyNamed('context'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenThrow(Exception('Network error'));
        
        provider.apiClient = mockApiClient;
        
        await provider.fetchAllOrders(context: mockContext);
        
        expect(provider.errorMessage, 'Exception: Network error');
      });

      test('should reset error message on new operations', () async {
        provider.errorMessage = 'Previous error';
        
        when(mockApiClient.patchRequest(
          any,
          context: anyNamed('context'),
          body: anyNamed('body'),
          requestName: anyNamed('requestName'),
          printResponseBody: anyNamed('printResponseBody'),
        )).thenAnswer((_) async => (true, '{"status": "cancelled"}'));
        
        provider.apiClient = mockApiClient;
        
        await provider.cancelOrder(context: mockContext, orderId: '123');
        
        expect(provider.errorMessage, '');
      });
    });

    group('State Management', () {
      test('should notify listeners on state changes', () {
        var notificationCount = 0;
        provider.addListener(() => notificationCount++);
        
        provider.setStatusFilter('pending');
        provider.toggleBulkMode();
        provider.toggleOrderSelection('1');
        
        expect(notificationCount, greaterThan(0));
      });

      test('should maintain filter state correctly', () {
        provider.setStatusFilter('shipped');
        provider.setAmountFilter(min: 100.0, max: 500.0);
        
        expect(provider.statusFilter, 'shipped');
        expect(provider.minAmountFilter, 100.0);
        expect(provider.maxAmountFilter, 500.0);
      });
    });
  });
}
