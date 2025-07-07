
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brill_prime/ui/cart/cart_screen.dart';
import 'package:brill_prime/providers/cart_provider.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/models/cart_item_model.dart';

// Mock AuthProvider
class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  bool _isLoggedIn = false;
  
  @override
  bool get isLoggedIn => _isLoggedIn;
  
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
  
  // Implement other required methods with default values
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  group('CartScreen Widget Tests', () {
    late CartProvider cartProvider;
    late MockAuthProvider authProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      cartProvider = CartProvider();
      authProvider = MockAuthProvider();
      await Future.delayed(Duration(milliseconds: 100));
    });

    Widget createWidgetUnderTest() {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
              ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ],
            child: const CartScreen(),
          ),
        ),
      );
    }

    testWidgets('should show empty cart message when cart is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Add items to get started'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    });

    testWidgets('should display cart items when cart has items', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.99,
        quantity: 2,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Vendor: Test Vendor'), findsOneWidget);
      expect(find.text('₦25.99'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should show cart and saved tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Cart (0)'), findsOneWidget);
      expect(find.text('Saved (0)'), findsOneWidget);
    });

    testWidgets('should update tab counts correctly', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.99,
        quantity: 1,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Cart (1)'), findsOneWidget);
      expect(find.text('Saved (0)'), findsOneWidget);

      // Save item for later
      cartProvider.saveForLater('1');
      await tester.pumpAndSettle();

      expect(find.text('Cart (0)'), findsOneWidget);
      expect(find.text('Saved (1)'), findsOneWidget);
    });

    testWidgets('should handle quantity increase and decrease', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 10.0,
        quantity: 1,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap increase button
      final increaseButton = find.byIcon(Icons.add);
      expect(increaseButton, findsOneWidget);
      await tester.tap(increaseButton);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);

      // Find and tap decrease button
      final decreaseButton = find.byIcon(Icons.remove);
      expect(decreaseButton, findsOneWidget);
      await tester.tap(decreaseButton);
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should show cart summary when items exist', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.99,
        quantity: 2,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Total (2 items)'), findsOneWidget);
      expect(find.text('₦51.98'), findsOneWidget);
      expect(find.text('Proceed to Checkout'), findsOneWidget);
    });

    testWidgets('should handle save for later action', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.99,
        quantity: 1,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap save for later button
      final saveButton = find.text('Save for later');
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Switch to saved tab to verify
      await tester.tap(find.text('Saved (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('Saved 1 item(s)'), findsOneWidget);
    });

    testWidgets('should handle remove item action', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.99,
        quantity: 1,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Find and tap remove button
      final removeButton = find.text('Remove');
      expect(removeButton, findsOneWidget);
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      expect(find.text('Your cart is empty'), findsOneWidget);
    });

    testWidgets('should show guest checkout dialog when user not logged in', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Test Product',
        price: 25.99,
        quantity: 1,
        image: 'test.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      authProvider.setLoggedIn(false);
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap checkout button
      await tester.tap(find.text('Proceed to Checkout'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout Options'), findsOneWidget);
      expect(find.text('Sign In to Continue'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
    });

    testWidgets('should show saved items correctly', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Saved Product',
        price: 15.50,
        quantity: 3,
        image: 'saved.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      cartProvider.saveForLater('1');
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Switch to saved tab
      await tester.tap(find.text('Saved (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Product'), findsOneWidget);
      expect(find.text('Saved 3 item(s)'), findsOneWidget);
      expect(find.text('Move to Cart'), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });

    testWidgets('should handle move to cart from saved items', (WidgetTester tester) async {
      final item = CartItem(
        commodityId: '1',
        name: 'Saved Product',
        price: 15.50,
        quantity: 1,
        image: 'saved.jpg',
        vendorId: 'vendor1',
        vendorName: 'Test Vendor',
      );

      cartProvider.addItem(item);
      cartProvider.saveForLater('1');
      
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Switch to saved tab
      await tester.tap(find.text('Saved (1)'));
      await tester.pumpAndSettle();

      // Move to cart
      await tester.tap(find.text('Move to Cart'));
      await tester.pumpAndSettle();

      // Switch back to cart tab
      await tester.tap(find.text('Cart (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Saved Product'), findsOneWidget);
    });
  });
}
