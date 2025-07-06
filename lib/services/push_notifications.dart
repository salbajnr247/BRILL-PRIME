// import 'dart:developer';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import 'api_client.dart';
//
// class PushNotificationService {
//   //Initialize FCM
//   void init() async {
//     await FirebaseMessaging.instance.requestPermission();
//
//     FirebaseMessaging.instance.getToken().then((value) {
//       log("FCM Token: ${value!}");
//       updateFCMToken(value);
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (Platform.isAndroid) handleMessage(message);
//     });
//
//     FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     FirebaseMessaging.instance.onTokenRefresh.listen(updateFCMToken);
//
//     //Register FCM Topic
//     FirebaseMessaging.instance.subscribeToTopic('admin');
//   }
//
//   void handleMessage(RemoteMessage message) {
//     FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
//
//     AndroidNotificationChannel channel = const AndroidNotificationChannel(
//       'high_importance_channel', // id
//       'Transaction Notifications', // title
//       description: 'This channel is used for important notifications.',
//       importance: Importance.high, showBadge: true, playSound: true,
//     );
//     RemoteNotification? notification = message.notification;
//     if (notification != null) {
//       plugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           iOS: const DarwinNotificationDetails(
//             sound: 'default',
//             presentAlert: true,
//             presentBadge: true,
//             presentSound: true,
//           ),
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             icon: '@drawable/icon',
//           ),
//         ),
//       );
//     }
//   }
//
//   //Update FCM Token
//   Future<void> updateFCMToken(String? token) async {
//     log(token!);
//     try {
//       await ApiClient().put(
//         "notifications/update",
//         body: {'token': token},
//       );
//     } catch (e) {
//       print(e);
//     }
//   }
// }
