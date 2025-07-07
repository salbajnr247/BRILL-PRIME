
import 'package:brill_prime/ui/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/bottom_nav_provider.dart';
import 'package:brill_prime/providers/cart_provider.dart';
import 'package:brill_prime/providers/dashboard_provider.dart';
import 'package:brill_prime/providers/favourites_provider.dart';
import 'package:brill_prime/providers/image_upload_provider.dart';
import 'package:brill_prime/providers/in_app_browser_provider.dart';
import 'package:brill_prime/providers/notification_provider.dart';
import 'package:brill_prime/providers/order_management_provider.dart';
import 'package:brill_prime/providers/payment_methods_provider.dart';
import 'package:brill_prime/providers/review_provider.dart';
import 'package:brill_prime/providers/search_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/providers/address_book_provider.dart';
import 'package:brill_prime/providers/bank_provider.dart';

void main() {
  group('BrillPrime App Tests', () {
    testWidgets('App smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => BottomNavProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => DashboardProvider()),
            ChangeNotifierProvider(create: (_) => FavouritesProvider()),
            ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
            ChangeNotifierProvider(create: (_) => InAppBrowserProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
            ChangeNotifierProvider(create: (_) => OrderManagementProvider()),
            ChangeNotifierProvider(create: (_) => PaymentMethodsProvider()),
            ChangeNotifierProvider(create: (_) => ReviewProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => TollGateProvider()),
            ChangeNotifierProvider(create: (_) => VendorProvider()),
            ChangeNotifierProvider(create: (_) => AddressBookProvider()),
            ChangeNotifierProvider(create: (_) => BankProvider()),
          ],
          child: const MyApp(),
        ),
      );

      // Verify the app builds without crashing
      await tester.pumpAndSettle();
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
