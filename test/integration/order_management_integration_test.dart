
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import '../../lib/ui/orders/order_management_screen.dart';
import '../../lib/providers/order_management_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Order Management Integration Tests', () {
    testWidgets('Complete order management workflow', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => OrderManagementProvider(),
            child: const OrderManagementScreen(),
          ),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Test 1: Verify initial UI elements
      expect(find.text('Order Management'), findsOneWidget);
      expect(find.byIcon(Icons.sync_disabled), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);

      // Test 2: Toggle real-time updates
      await tester.tap(find.byIcon(Icons.sync_disabled));
      await tester.pump();
      expect(find.byIcon(Icons.sync), findsOneWidget);

      // Test 3: Open filter dialog
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      expect(find.text('Filter Orders'), findsOneWidget);

      // Test 4: Apply status filter
      final statusDropdown = find.byType(DropdownButtonFormField<String>);
      await tester.tap(statusDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pending').last);
      await tester.pumpAndSettle();

      // Close filter dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Test 5: Enter bulk mode
      await tester.tap(find.byIcon(Icons.check_box_outline_blank));
      await tester.pump();
      expect(find.byIcon(Icons.check_box), findsOneWidget);

      // Test 6: Verify bulk mode UI changes
      // (This would require actual order data to test selection)

      // Test 7: Exit bulk mode
      await tester.tap(find.byIcon(Icons.check_box));
      await tester.pump();
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);

      // Test 8: Turn off real-time updates
      await tester.tap(find.byIcon(Icons.sync));
      await tester.pump();
      expect(find.byIcon(Icons.sync_disabled), findsOneWidget);
    });

    testWidgets('Filter functionality integration test', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => OrderManagementProvider(),
            child: const OrderManagementScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open filter dialog
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Test amount range filtering
      final minAmountField = find.widgetWithText(TextFormField, '').first;
      await tester.enterText(minAmountField, '50');
      await tester.pump();

      final maxAmountField = find.widgetWithText(TextFormField, '').last;
      await tester.enterText(maxAmountField, '200');
      await tester.pump();

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify filter summary appears
      expect(find.textContaining('Active filters'), findsOneWidget);
      expect(find.text('Clear'), findsOneWidget);

      // Clear filters
      await tester.tap(find.text('Clear'));
      await tester.pump();
    });

    testWidgets('Real-time updates integration test', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => OrderManagementProvider(),
            child: const OrderManagementScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Start real-time updates
      await tester.tap(find.byIcon(Icons.sync_disabled));
      await tester.pump();

      // Verify icon changed
      expect(find.byIcon(Icons.sync), findsOneWidget);

      // Wait a bit to simulate real-time behavior
      await tester.pump(const Duration(seconds: 1));

      // Stop real-time updates
      await tester.tap(find.byIcon(Icons.sync));
      await tester.pump();

      // Verify icon changed back
      expect(find.byIcon(Icons.sync_disabled), findsOneWidget);
    });

    testWidgets('Error handling integration test', (tester) async {
      final provider = OrderManagementProvider();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: const OrderManagementScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Simulate an error state
      provider.errorMessage = 'Network connection failed';
      provider.notifyListeners();
      await tester.pump();

      // Verify error message is displayed
      expect(find.text('Network connection failed'), findsOneWidget);
    });
  });
}
