// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/bottom_nav_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/favourites_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/order_management_provider.dart';
import '../../providers/payment_methods_provider.dart';
import '../../providers/review_provider.dart';
import '../../providers/search_provider.dart';
import '../../providers/toll_gate_provider.dart';
import '../../providers/vendor_provider.dart';
import '../../providers/real_time_provider.dart';
import '../../resources/routes_manager.dart';
import '../../resources/theme_manager.dart';
import '../splash_screen/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // requestFirebasePermission();
    WidgetsBinding.instance.addObserver(this);

    // New Implementation
    // _checkInitialMessage();
    // Listen for messages when the app is in the foreground
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   _handleNotification(message);
    // });

    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       flutterLocalNotificationsPlugin.show(
    //           notification.hashCode,
    //           notification.title,
    //           notification.body,
    //           NotificationDetails(
    //             android: AndroidNotificationDetails(
    //               channel.id,
    //               channel.name,
    //               // channel.description,
    //               color: Colors.blue,
    //               icon: "@mipmap/notification_icon",
    //             ),
    //           ));
    //     }
    //   });
    //
    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //     final prefs = await SharedPreferences.getInstance();
    //     prefs.setBool(notificationAvailable, true);
    //     RemoteNotification? notification = message.notification;
    //     debugPrint("Notification::: ${notification?.body}");
    //     AndroidNotification? android = message.notification?.android;
    //     if (notification != null && android != null) {
    //       showDialog(
    //         // context: context,
    //           barrierDismissible: false,
    //           builder: (_) {
    //             return AlertDialog(
    //               title: Text(notification.title ?? ""),
    //               content: SingleChildScrollView(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [Text(notification.body ?? "")],
    //                 ),
    //               ),
    //             );
    //           },
    //           context: context);
    //     }
    //   });
    //
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //     final prefs = await SharedPreferences.getInstance();
    //     final bool hasNotification =
    //         prefs.getBool(notificationAvailable) ?? false;
    //     debugPrint("Has notification::::::::::::::::$hasNotification");
    //
    //     // IF IT HAS NOTIFICATION ON RESUME SEND THE USER TO THE NOTIFICATION SCREEN
    //     if (hasNotification) {
    //       debugPrint("Has notification==========");
    //       prefs.setBool(notificationAvailable, false);
    //     }
    //   });
    //
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //     // if (auth.userIsLoggedIn) {
    //     //   await PushNotificationService().init(context: context);
    //     // }
    //   });
    // }

    // Future<void> _checkInitialMessage() async {
    //   // Check if the app was launched by tapping a notification
    //   RemoteMessage? initialMessage = await messaging.getInitialMessage();
    //   if (initialMessage != null) {
    //     // Handle the notification when the app is launched directly from the notification
    //     _handleNotification(initialMessage);
    //   }
    // }

    // Future<void> _checkForNotifications() async {
    //   // Handle incoming notifications when the app resumes from background
    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     _handleNotification(message, isOnResume: true, isOnMessageOpenApp: true);
    //   });
    // }

    // void _handleNotification(RemoteMessage message,
    //     {bool isOnResume = false, bool isOnMessageOpenApp = false}) {
    // Access the notification payload

    // To avoid duplicating notification
    // if (!notificationProvider.showingNotification) {
    //   if (isOnResume) {
    //     notificationProvider.updateShowingNotification(newValue: true);
    //   }
    //   if (message.notification != null) {
    //     debugPrint(
    //         'New Notification Implementation Title: ${message.notification!.title}');
    //     debugPrint(
    //         'New Notification Implementation Body: ${message.notification!.body}');
    //   }
    //
    //   if (message.data.isNotEmpty && isOnMessageOpenApp) {
    // final newNotificationObject = NotificationObject(
    //     notificationType: message.data["type"] ?? "",
    //     id: message.data["id"] ?? "");
    //
    // earnProvider.updateTaskIdFromNotification(null);
    // notificationProvider.updateNotificationObject(null);
    // // context.pushNamed(NotificationScreen.routeName);
    // auth.updateAppOpenedFromNotification(value: true);
    // notificationProvider.updateSelectedRemoteNotification(message);
    // notificationProvider.updateNotificationObject(newNotificationObject);
    //
    // if (isOnResume && notificationProvider.notificationObject != null) {
    //   notificationProvider.updateShowingNotification(newValue: true);
    //   debugPrint(
    //       'Send user to checkAndRouteNotification method: ${message.data}');
    //   checkAndRouteNotification(
    //       context: AppNavigation.rootNavigatorKey.currentState!.context,
    //       advertProvider: advertProvider,
    //       earnProvider: earnProvider,
    //       notificationProvider: notificationProvider);
    // }
    // debugPrint('New Notification Implementation Data: ${message.data}');
    //   }
    // }
    // }

    // Future<void> requestFirebasePermission() async {
    //   FirebaseMessaging messaging = FirebaseMessaging.instance;
    //   NotificationSettings settings = await messaging.requestPermission();
    // }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      return;
    }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {}

// ON RESUMED, CHECK THE PREVIOUS TIME USER HAVE SPENT ON THE APP
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        useInheritedMediaQuery: true,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => AuthProvider()),
                ChangeNotifierProvider(create: (_) => BottomNavProvider()),
                ChangeNotifierProvider(create: (_) => DashboardProvider()),
                ChangeNotifierProvider(create: (_) => FavouritesProvider()),
                ChangeNotifierProvider(create: (_) => NotificationProvider()),
                ChangeNotifierProvider(create: (_) => CartProvider()),
                ChangeNotifierProvider(create: (_) => SearchProvider()),
                ChangeNotifierProvider(create: (_) => ReviewProvider()),
                ChangeNotifierProvider(create: (_) => TollGateProvider()),
                ChangeNotifierProvider(
                    create: (_) => OrderManagementProvider()),
                ChangeNotifierProvider(create: (_) => PaymentMethodsProvider()),
                ChangeNotifierProvider(create: (_) => VendorProvider()),
                ChangeNotifierProvider(create: (_) => RealTimeProvider()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: RouteGenerator.getRoute,
                initialRoute: Routes.splashRoute,
                home: const SplashScreen(),
                theme: getApplicationTheme(),
              ),
            ));
  }
}