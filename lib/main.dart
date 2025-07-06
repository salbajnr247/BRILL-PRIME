import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
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
import 'resources/constants/color_constants.dart';
import 'resources/constants/string_constants.dart';
import 'ui/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Auth is now configured for production use

  await Hive.initFlutter();
  Hive.registerAdapter(HiveUserModelAdapter());
  Hive.registerAdapter(HiveBiometricModelAdapter());
  await Hive.openBox<HiveUserModel>(userBox);
  await Hive.openBox<HiveBiometricModel>(biometricBox);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}