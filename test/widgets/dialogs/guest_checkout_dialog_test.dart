
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brill_prime/widgets/dialogs/guest_checkout_dialog.dart';
import 'package:brill_prime/providers/cart_provider.dart';

void main() {
  group('GuestCheckoutDialog Widget Tests', () {
    late CartProvider cartProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      cartProvider = CartProvider();
      await Future.delayed(Duration(milliseconds: 100));
    });

    Widget createWidgetUnderTest() {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ChangeNotifierProvider<CartProvider>.value(
                      value: cartProvider,
                      child: const GuestCheckoutDialog(),
                    ),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
          routes: {
            '/login': (context) => const Scaffold(body: Text('Login Screen')),
            '/guest-checkout': (context) => const Scaffold(body: Text('Guest Checkout Screen')),
            '/sign-up': (context) => const Scaffold(body: Text('Sign Up Screen')),
          },
        ),
      );
    }

    testWidgets('should display dialog with correct content', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Open dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout Options'), findsOneWidget);
      expect(find.text('Choose how you\'d like to proceed with your order'), findsOneWidget);
      expect(find.text('Sign In to Continue'), findsOneWidget);
      expect(find.text('Continue as Guest'), findsOneWidget);
      expect(find.text('Create an Account'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    });

    testWidgets('should show benefits section', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Benefits of having an account:'), findsOneWidget);
      expect(find.text('Track your orders'), findsOneWidget);
      expect(find.text('Save items for later'), findsOneWidget);
      expect(find.text('Faster checkout'), findsOneWidget);
      expect(find.text('Order history'), findsOneWidget);
      
      // Check for benefit icons
      expect(find.byIcon(Icons.check_circle_outline), findsNWidgets(4));
    });

    testWidgets('should navigate to login when sign in button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign In to Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('should enable guest checkout and navigate when guest button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(cartProvider.isGuestCheckout, false);

      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      expect(cartProvider.isGuestCheckout, true);
      expect(cartProvider.cartSessionId, isNotNull);
      expect(find.text('Guest Checkout Screen'), findsOneWidget);
    });

    testWidgets('should navigate to sign up when create account is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create an Account'));
      await tester.pumpAndSettle();

      expect(find.text('Sign Up Screen'), findsOneWidget);
    });

    testWidgets('should have correct button styles', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Check for login icon
      expect(find.byIcon(Icons.login), findsOneWidget);
      
      // Check for guest icon
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Find the buttons
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In to Continue');
      final guestButton = find.widgetWithText(OutlinedButton, 'Continue as Guest');
      
      expect(signInButton, findsOneWidget);
      expect(guestButton, findsOneWidget);
    });

    testWidgets('should close dialog properly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Checkout Options'), findsOneWidget);

      // Tap outside dialog to close
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle();

      expect(find.text('Checkout Options'), findsNothing);
    });
  });
}
