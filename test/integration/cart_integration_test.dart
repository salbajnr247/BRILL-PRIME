
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brill_prime/providers/cart_provider.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/ui/cart/cart_screen.dart';
import 'package:brill_prime/models/cart_item_model.dart';

// Mock AuthProvider for testing
class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  bool _isLoggedIn = false;
  
  @override
  bool get isLoggedIn => _isLoggedIn;
  
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Cart Integration Tests', () {
    late CartProvider cartProvider;
    late MockAuthProvider authProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      cartProvider = CartProvider();
      authProvider = MockAuthProvider();
      await Future.delayed(Duration(milliseconds: 100));
    });

    Widget createApp() {
      return MaterialApp(
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ],
          child: const CartScreen(),
        ),
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Screen')),
          '/guest-checkout': (context) => const Scaffold(body: Text('Guest Checkout Screen')),
          '/sign-up': (context) => const Scaffold(body: Text('Sign Up Screen')),
          '/checkout': (context) => const Scaffold(body: Text('Checkout Screen')),
        },
      );
    }

    testWidgets('complete cart workflow - add, modify, save, checkout', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Initially empty cart
      expect(find.text('Your cart is empty'), findsOneWidget);

      // Add items programmatically (simulating adding from product pages)
      final item1 = CartItem(
        commodityId: '1',
        name: 'Product 1',
        price: 10.0,
        quantity: 1,
        image: 'product1.jpg',
        vendorId: 'vendor1',
        vendorName: 'Vendor A',
      );

      final item2 = CartItem(
        commodityId: '2',
        name: 'Product 2',
        price: 20.0,
        quantity: 1,
        image: 'product2.jpg',
        vendorId: 'vendor2',
        vendorName: 'Vendor B',
      );

      cartProvider.addItem(item1);
      cartProvider.addItem(item2);
      await tester.pumpAndSettle();

      // Verify items are displayed
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('Cart (2)'), findsOneWidget);

      // Test quantity increase
      final increaseButtons = find.byIcon(Icons.add);
      await tester.tap(increaseButtons.first);
      await tester.pumpAndSettle();

      expect(find.text('Total (3 items)'), findsOneWidget);
      expect(find.text('₦40.00'), findsOneWidget);

      // Test save for later
      await tester.tap(find.text('Save for later').first);
      await tester.pumpAndSettle();

      expect(find.text('Cart (1)'), findsOneWidget);
      expect(find.text('Saved (1)'), findsOneWidget);

      // Switch to saved tab and verify
      await tester.tap(find.text('Saved (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Move to Cart'), findsOneWidget);

      // Move back to cart
      await tester.tap(find.text('Move to Cart'));
      await tester.pumpAndSettle();

      // Switch back to cart tab
      await tester.tap(find.text('Cart (2)'));
      await tester.pumpAndSettle();

      // Test checkout flow when not logged in
      authProvider.setLoggedIn(false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout Options'), findsOneWidget);

      // Test guest checkout
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      expect(find.text('Guest Checkout Screen'), findsOneWidget);
      expect(cartProvider.isGuestCheckout, true);
    });

    testWidgets('persistence workflow - cart should persist across app restarts', (WidgetTester tester) async {
      // Add items to cart
      final item = CartItem(
        commodityId: '1',
        name: 'Persistent Product',
        price: 15.0,
        quantity: 2,
        image: 'persistent.jpg',
        vendorId: 'vendor1',
        vendorName: 'Persistent Vendor',
      );

      cartProvider.addItem(item);
      cartProvider.saveForLater('1');

      // Simulate app restart by creating new provider
      final newCartProvider = CartProvider();
      await Future.delayed(Duration(milliseconds: 200)); // Wait for loading

      // Create new app instance with new provider
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<CartProvider>.value(value: newCartProvider),
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: const CartScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify data persisted
      expect(find.text('Saved (1)'), findsOneWidget);
      
      await tester.tap(find.text('Saved (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Persistent Product'), findsOneWidget);
    });

    testWidgets('multi-vendor cart workflow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Add items from different vendors
      final item1 = CartItem(
        commodityId: '1',
        name: 'Vendor A Product',
        price: 10.0,
        quantity: 1,
        image: 'productA.jpg',
        vendorId: 'vendorA',
        vendorName: 'Vendor A',
      );

      final item2 = CartItem(
        commodityId: '2',
        name: 'Vendor B Product',
        price: 20.0,
        quantity: 1,
        image: 'productB.jpg',
        vendorId: 'vendorB',
        vendorName: 'Vendor B',
      );

      final item3 = CartItem(
        commodityId: '3',
        name: 'Another Vendor A Product',
        price: 15.0,
        quantity: 1,
        image: 'productA2.jpg',
        vendorId: 'vendorA',
        vendorName: 'Vendor A',
      );

      cartProvider.addItem(item1);
      cartProvider.addItem(item2);
      cartProvider.addItem(item3);
      await tester.pumpAndSettle();

      // Verify multi-vendor message
      expect(find.text('Items from 2 vendors'), findsOneWidget);
      expect(find.text('Total (3 items)'), findsOneWidget);
      expect(find.text('₦45.00'), findsOneWidget);

      // Verify all products are shown
      expect(find.text('Vendor A Product'), findsOneWidget);
      expect(find.text('Vendor B Product'), findsOneWidget);
      expect(find.text('Another Vendor A Product'), findsOneWidget);
    });

    testWidgets('empty states workflow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Initially empty
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);

      // Switch to saved tab - should also be empty
      await tester.tap(find.text('Saved (0)'));
      await tester.pumpAndSettle();

      expect(find.text('No saved items'), findsOneWidget);
      expect(find.text('Items you save for later will appear here'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
    });

    testWidgets('logged in user checkout workflow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle();

      // Add item
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.0,
        quantity: 1,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      authProvider.setLoggedIn(true);
      await tester.pumpAndSettle();

      // Proceed to checkout
      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      // Should go directly to checkout (no dialog)
      expect(find.text('Checkout Screen'), findsOneWidget);
    });
  });
}
