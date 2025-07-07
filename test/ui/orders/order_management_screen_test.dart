
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import '../../../lib/ui/orders/order_management_screen.dart';
import '../../../lib/providers/order_management_provider.dart';
import '../../../lib/models/consumer_order_model.dart';

@GenerateMocks([OrderManagementProvider])
import 'order_management_screen_test.mocks.dart';

void main() {
  group('OrderManagementScreen Widget Tests', () {
    late MockOrderManagementProvider mockProvider;

    setUp(() {
      mockProvider = MockOrderManagementProvider();
      
      // Setup default mock responses
      when(mockProvider.loading).thenReturn(false);
      when(mockProvider.errorMessage).thenReturn('');
      when(mockProvider.isRealTimeEnabled).thenReturn(false);
      when(mockProvider.isBulkMode).thenReturn(false);
      when(mockProvider.selectedOrderIds).thenReturn(<String>{});
      when(mockProvider.filteredOrders).thenReturn([]);
      when(mockProvider.statusFilter).thenReturn('all');
      when(mockProvider.dateFromFilter).thenReturn(null);
      when(mockProvider.dateToFilter).thenReturn(null);
      when(mockProvider.minAmountFilter).thenReturn(null);
      when(mockProvider.maxAmountFilter).thenReturn(null);
      when(mockProvider.bulkProcessing).thenReturn(false);
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: ChangeNotifierProvider<OrderManagementProvider>.value(
          value: mockProvider,
          child: const OrderManagementScreen(),
        ),
      );
    }

    testWidgets('should display app bar with correct title', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Order Management'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should show loading indicator when loading', (tester) async {
      when(mockProvider.loading).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when present', (tester) async {
      when(mockProvider.errorMessage).thenReturn('Network error occurred');
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Network error occurred'), findsOneWidget);
    });

    testWidgets('should show real-time sync icon in app bar', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byIcon(Icons.sync_disabled), findsOneWidget);
      
      when(mockProvider.isRealTimeEnabled).thenReturn(true);
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byIcon(Icons.sync), findsOneWidget);
    });

    testWidgets('should display filter and bulk mode icons', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    });

    testWidgets('should show bulk mode icon as checked when enabled', (tester) async {
      when(mockProvider.isBulkMode).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byIcon(Icons.check_box), findsOneWidget);
    });

    testWidgets('should display orders list', (tester) async {
      final mockOrders = [
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
      ];
      
      when(mockProvider.filteredOrders).thenReturn(mockOrders);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('Order #1'), findsOneWidget);
      expect(find.text('Order #2'), findsOneWidget);
      expect(find.text('Status: pending'), findsOneWidget);
      expect(find.text('Status: shipped'), findsOneWidget);
    });

    testWidgets('should show empty state when no orders', (tester) async {
      when(mockProvider.filteredOrders).thenReturn([]);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('No orders found'), findsOneWidget);
    });

    testWidgets('should display filter summary when filters are active', (tester) async {
      when(mockProvider.statusFilter).thenReturn('pending');
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.textContaining('Active filters'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
    });

    testWidgets('should show bulk actions bar when orders are selected', (tester) async {
      when(mockProvider.isBulkMode).thenReturn(true);
      when(mockProvider.selectedOrderIds).thenReturn({'1', '2'});
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.text('2 selected'), findsOneWidget);
      expect(find.text('Select All'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);
      expect(find.text('Actions'), findsOneWidget);
    });

    testWidgets('should show checkboxes in bulk mode', (tester) async {
      when(mockProvider.isBulkMode).thenReturn(true);
      when(mockProvider.filteredOrders).thenReturn([
        ConsumerOrderData(
          id: 1,
          status: 'pending',
          totalPrice: 100.0,
          createdAt: DateTime.now(),
        ),
      ]);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('should show action buttons for individual orders', (tester) async {
      when(mockProvider.filteredOrders).thenReturn([
        ConsumerOrderData(
          id: 1,
          status: 'pending',
          totalPrice: 100.0,
          createdAt: DateTime.now(),
        ),
      ]);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      expect(find.byIcon(Icons.assignment_return), findsOneWidget);
    });

    testWidgets('should open filter dialog when filter icon is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      
      expect(find.text('Filter Orders'), findsOneWidget);
    });

    testWidgets('should toggle bulk mode when bulk icon is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.byIcon(Icons.check_box_outline_blank));
      
      verify(mockProvider.toggleBulkMode()).called(1);
    });

    testWidgets('should toggle real-time updates when sync icon is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.byIcon(Icons.sync_disabled));
      
      verify(mockProvider.startRealTimeUpdates(context: anyNamed('context'))).called(1);
    });

    testWidgets('should show loading indicator in bulk actions when processing', (tester) async {
      when(mockProvider.isBulkMode).thenReturn(true);
      when(mockProvider.selectedOrderIds).thenReturn({'1'});
      when(mockProvider.bulkProcessing).thenReturn(true);
      
      await tester.pumpWidget(createWidgetUnderTest());
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    group('Filter Dialog Tests', () {
      testWidgets('should display all filter options', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        
        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();
        
        expect(find.text('Status'), findsOneWidget);
        expect(find.text('From Date'), findsOneWidget);
        expect(find.text('To Date'), findsOneWidget);
        expect(find.text('Min Amount'), findsOneWidget);
        expect(find.text('Max Amount'), findsOneWidget);
      });

      testWidgets('should have status dropdown with options', (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        
        await tester.tap(find.byIcon(Icons.filter_list));
        await tester.pumpAndSettle();
        
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      });
    });

    group('Bulk Actions Dialog Tests', () {
      testWidgets('should show bulk actions dialog', (tester) async {
        when(mockProvider.isBulkMode).thenReturn(true);
        when(mockProvider.selectedOrderIds).thenReturn({'1', '2'});
        
        await tester.pumpWidget(createWidgetUnderTest());
        
        await tester.tap(find.text('Actions'));
        await tester.pumpAndSettle();
        
        expect(find.text('Bulk Actions'), findsOneWidget);
        expect(find.text('2 orders selected'), findsOneWidget);
        expect(find.text('Cancel Orders'), findsOneWidget);
        expect(find.text('Update Status'), findsOneWidget);
      });
    });
  });
}
