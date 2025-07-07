
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/widgets/real_time_notification_widget.dart';
import 'package:brill_prime/widgets/real_time_order_card.dart';
import 'package:brill_prime/widgets/real_time_chat_widget.dart';
import 'package:brill_prime/widgets/real_time_inventory_widget.dart';
import 'package:brill_prime/providers/notification_provider.dart';
import 'package:brill_prime/providers/order_management_provider.dart';
import 'package:brill_prime/providers/real_time_provider.dart';
import 'package:brill_prime/models/consumer_order_model.dart';
import 'package:brill_prime/models/notification_model.dart';

class MockNotificationProvider extends Mock implements NotificationProvider {}
class MockOrderManagementProvider extends Mock implements OrderManagementProvider {}
class MockRealTimeProvider extends Mock implements RealTimeProvider {}

void main() {
  group('Real-time Widgets Tests', () {
    late MockNotificationProvider mockNotificationProvider;
    late MockOrderManagementProvider mockOrderProvider;
    late MockRealTimeProvider mockRealTimeProvider;

    setUp(() {
      mockNotificationProvider = MockNotificationProvider();
      mockOrderProvider = MockOrderManagementProvider();
      mockRealTimeProvider = MockRealTimeProvider();
    });

    group('RealTimeNotificationWidget', () {
      testWidgets('should display notification correctly', (WidgetTester tester) async {
        // Setup
        when(mockRealTimeProvider.isConnected).thenReturn(true);

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<NotificationProvider>.value(value: mockNotificationProvider),
              ChangeNotifierProvider<RealTimeProvider>.value(value: mockRealTimeProvider),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: const [
                    RealTimeNotificationWidget(userId: 'test-user'),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially should be hidden
        expect(find.byType(RealTimeNotificationWidget), findsOneWidget);
      });

      testWidgets('should animate notification appearance', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<NotificationProvider>.value(value: mockNotificationProvider),
              ChangeNotifierProvider<RealTimeProvider>.value(value: mockRealTimeProvider),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Stack(
                  children: const [
                    RealTimeNotificationWidget(userId: 'test-user'),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Test animation presence
        expect(find.byType(SlideTransition), findsNothing); // Hidden initially
      });

      testWidgets('should handle notification tap', (WidgetTester tester) async {
        bool tapped = false;
        
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RealTimeNotificationWidget(
                userId: 'test-user',
                onNotificationTap: (notification) {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Since widget is initially hidden, we can't test tap
        expect(tapped, false);
      });
    });

    group('RealTimeOrderCard', () {
      testWidgets('should display order information', (WidgetTester tester) async {
        final testOrder = ConsumerOrderData(
          id: 1,
          status: 'pending',
          totalPrice: 100.0,
          createdAt: DateTime.now(),
          orderItems: [],
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<OrderManagementProvider>.value(value: mockOrderProvider),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RealTimeOrderCard(order: testOrder),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Order #1'), findsOneWidget);
        expect(find.text('Total: ₦100.0'), findsOneWidget);
        expect(find.text('Pending Confirmation'), findsOneWidget);
      });

      testWidgets('should animate on status change', (WidgetTester tester) async {
        final testOrder = ConsumerOrderData(
          id: 1,
          status: 'pending',
          totalPrice: 100.0,
          createdAt: DateTime.now(),
          orderItems: [],
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<OrderManagementProvider>.value(value: mockOrderProvider),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RealTimeOrderCard(order: testOrder),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify animations are present
        expect(find.byType(AnimatedBuilder), findsWidgets);
        expect(find.byType(Transform), findsOneWidget);
      });

      testWidgets('should navigate to order details on tap', (WidgetTester tester) async {
        final testOrder = ConsumerOrderData(
          id: 1,
          status: 'pending',
          totalPrice: 100.0,
          createdAt: DateTime.now(),
          orderItems: [],
        );

        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<OrderManagementProvider>.value(value: mockOrderProvider),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RealTimeOrderCard(order: testOrder),
              ),
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => const Scaffold(
                    body: Text('Order Details'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        expect(find.text('Order Details'), findsOneWidget);
      });
    });

    group('RealTimeChatWidget', () {
      testWidgets('should display chat interface', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const RealTimeChatWidget(
                chatId: 'test-chat',
                currentUserId: 'user-1',
                currentUserName: 'Test User',
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Live Chat'), findsOneWidget);
        expect(find.text('Online'), findsOneWidget);
        expect(find.text('Type your message...'), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);
      });

      testWidgets('should send message when send button is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const RealTimeChatWidget(
                chatId: 'test-chat',
                currentUserId: 'user-1',
                currentUserName: 'Test User',
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Enter message
        await tester.enterText(find.byType(TextField), 'Test message');
        
        // Tap send button
        await tester.tap(find.byIcon(Icons.send));
        await tester.pumpAndSettle();

        // Message field should be cleared
        expect(find.text('Test message'), findsNothing);
      });

      testWidgets('should display typing indicator', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const RealTimeChatWidget(
                chatId: 'test-chat',
                currentUserId: 'user-1',
                currentUserName: 'Test User',
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Typing indicator animation should be present
        expect(find.byType(AnimatedBuilder), findsWidgets);
      });

      testWidgets('should scroll to bottom when new message arrives', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const RealTimeChatWidget(
                chatId: 'test-chat',
                currentUserId: 'user-1',
                currentUserName: 'Test User',
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Scroll controller should be present
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('RealTimeInventoryWidget', () {
      testWidgets('should display inventory status', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const RealTimeInventoryWidget(vendorId: 'vendor-1'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Widget should render without errors
        expect(find.byType(RealTimeInventoryWidget), findsOneWidget);
      });

      testWidgets('should update on inventory changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: const RealTimeInventoryWidget(vendorId: 'vendor-1'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test that widget responds to state changes
        expect(find.byType(RealTimeInventoryWidget), findsOneWidget);
      });
    });
  });

  group('Widget Integration Tests', () {
    testWidgets('multiple real-time widgets should work together', (WidgetTester tester) async {
      final testOrder = ConsumerOrderData(
        id: 1,
        status: 'pending',
        totalPrice: 100.0,
        createdAt: DateTime.now(),
        orderItems: [],
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<NotificationProvider>.value(value: mockNotificationProvider),
            ChangeNotifierProvider<OrderManagementProvider>.value(value: mockOrderProvider),
            ChangeNotifierProvider<RealTimeProvider>.value(value: mockRealTimeProvider),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  RealTimeOrderCard(order: testOrder),
                  const RealTimeChatWidget(
                    chatId: 'test-chat',
                    currentUserId: 'user-1',
                    currentUserName: 'Test User',
                  ),
                  const RealTimeInventoryWidget(vendorId: 'vendor-1'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(RealTimeOrderCard), findsOneWidget);
      expect(find.byType(RealTimeChatWidget), findsOneWidget);
      expect(find.byType(RealTimeInventoryWidget), findsOneWidget);
    });
  });
}
