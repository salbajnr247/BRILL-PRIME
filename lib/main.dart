import 'package:brill_prime/providers/image_upload_provider.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/bank_provider.dart';
import 'package:brill_prime/providers/bottom_nav_provider.dart';
import 'package:brill_prime/providers/dashboard_provider.dart';
import 'package:brill_prime/providers/in_app_browser_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/endpoints.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/resources/keys/api_keys.dart';
import 'package:brill_prime/ui/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/hive_models/biometric_detail_model.dart';
import 'models/hive_models/hive_user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supaBaseURL,
    anonKey: anonKey,
  );
  // Configure system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: mainColor,
    statusBarColor: mainColor,
  ));
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // Initialize Hive

  await Hive.initFlutter();
  Hive.registerAdapter(HiveUserModelAdapter());
  Hive.registerAdapter(HiveBiometricModelAdapter());
  await Hive.openBox<HiveBiometricModel>(biometricBox);
  await Hive.openBox<HiveUserModel>(userBox);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
        ChangeNotifierProvider(create: (context) => InAppBrowserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
        ChangeNotifierProvider(create: (context) => TollGateProvider()),
        ChangeNotifierProvider(create: (context) => VendorProvider()),
        ChangeNotifierProvider(create: (context) => BankProvider()),
        ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
