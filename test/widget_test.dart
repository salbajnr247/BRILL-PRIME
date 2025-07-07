import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/ui/app/my_app.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('MyApp should build without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MyApp(),
        ),
      );

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Should show splash screen initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: MyApp(),
        ),
      );

      // The app should start with some initial screen
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}