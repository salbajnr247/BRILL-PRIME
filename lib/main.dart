import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/hive_models/biometric_detail_model.dart';
import 'models/hive_models/hive_user_model.dart';
import 'providers/address_book_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/bank_provider.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/favourites_provider.dart';
import 'providers/image_upload_provider.dart';
import 'providers/in_app_browser_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/order_management_provider.dart';
import 'providers/payment_methods_provider.dart';
import 'providers/review_provider.dart';
import 'providers/search_provider.dart';
import 'providers/toll_gate_provider.dart';
import 'providers/vendor_provider.dart';
import 'resources/constants/string_constants.dart';
import 'ui/app/my_app.dart';
import 'services/push_notifications.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  //Initialize Hive
  await Hive.initFlutter();

  //Register adapter
  Hive.registerAdapter(HiveUserModelAdapter());
  Hive.registerAdapter(HiveBiometricModelAdapter());

  //open box
  await Hive.openBox<HiveUserModel>(userBox);
  await Hive.openBox<HiveBiometricModel>(biometricBox);

  const supaBaseURL = 'https://xrddnmvjmtxjjrjzlxqo.supabase.co';
  const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhyZGRubXZqbXR4ampyant6bHhxbyIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzI0NzI3MjA5LCJleHAiOjIwNDAzMDMyMDl9.xRQjGCUOhLN5p9QJOkJHVcCLKvBWBFYfVwKJdVkDFJo';

  await Supabase.initialize(
    url: supaBaseURL,
    anonKey: anonKey,
  );

  await PushNotifications.init();
  runApp(const MyApp());
}