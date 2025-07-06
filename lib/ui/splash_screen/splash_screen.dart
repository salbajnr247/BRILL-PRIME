import 'dart:async';
import 'package:brill_prime/ui/login_option/login_option_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/connectivity.dart';
import '../../resources/constants/image_constant.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/biometric_auth_service.dart';
import '../../utils/navigation_util.dart';
import '../get_started_screen/get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final BiometricAuthService _biometricAuth = BiometricAuthService();
  // Check if Biometric is available on the app

  Timer? _timer;

  late AuthProvider auth;
  late DashboardProvider dashboardProvider;
  _startDelay() {
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  void _checkBiometricSupport() async {
    bool isAvailable = await _biometricAuth.isBiometricAvailable();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    auth = context.watch<AuthProvider>();
    dashboardProvider = context.watch<DashboardProvider>();
    return Scaffold(
      backgroundColor: splashBgColor,
      body: SafeArea(
          bottom: false,
          top: false,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: splashBgColor),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: 250.w, child: Image.asset(splashScreenLogo)),
                      SizedBox(
                        height: 9.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  _goNext() async {
    debugPrint("CONNECTED TO THE INTERNET============= IN INIT STATE");

    final sharedPref = await SharedPreferences.getInstance();

    _checkBiometricSupport();
    if (mounted) {
      await auth.getBiometricCredentials(context);
    }
    bool isConnected = await connectionChecker();

    if (isConnected) {
      debugPrint("CONNECTED TO THE INTERNET=============");

      bool isFirstTimeUser = sharedPref.getBool(showOnBoarding) == null ||
          sharedPref.getBool(showOnBoarding) == true;

      if (isFirstTimeUser) {
        if (mounted) {
          navToWithScreenName(
              context: context,
              screen: const GetStartedScreen(),
              isReplacement: true);
        }
      } else {
        if (mounted) {
          bool hasUserData = await auth.updateUserData(context);
          if (hasUserData) {
            if (!mounted) return;
            bool fetchedProfile = await auth.getProfile(context: context);
            if (fetchedProfile) {
              dashboardProvider.updateSearchFilter();
              if (mounted) {
                if (mounted) {
                  navToWithScreenName(
                      context: context, screen: const LoginOptionScreen());
                }
              }
            } else {
              if (mounted) {
                navToWithScreenName(
                    context: context, screen: const LoginOptionScreen());
              }
            }
          } else {
            navToWithScreenName(
                context: context, screen: const LoginOptionScreen());
          }
        }
      }
    } else {
      debugPrint("NOT CONNECTED TO THE INTERNET=============");
      if (mounted) {
        navToWithScreenName(context: context, screen: const GetStartedScreen());
      }
    }
  }
}
