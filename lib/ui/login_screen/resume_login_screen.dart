import 'dart:io' as platform;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../services/biometric_auth_service.dart';
import '../../utils/functions.dart';
import '../../utils/navigation_util.dart';
import '../Widgets/custom_text.dart';
import '../bottom_nav_screens/bottom_nav_screen.dart';
import '../widgets/components.dart';
import 'login_screen.dart';

class ResumeLoginScreen extends StatefulWidget {
  const ResumeLoginScreen({super.key});

  @override
  State<ResumeLoginScreen> createState() => _ResumeLoginScreenState();
}

class _ResumeLoginScreenState extends State<ResumeLoginScreen> {
  int authAttempts = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Removed unused authProvider variable
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
            return Column(
              children: [
                SizedBox(
                  height: topPadding.h,
                ),
                SizedBox(
                  height: 28.h,
                ),
                SvgPicture.asset(
                  logoSvg,
                  height: 45,
                  width: 45,
                ),
                SizedBox(
                  height: 28.h,
                ),
                // const ResumeUserInfoWidget(),
                const SizedBox(
                  height: 28,
                ),

                SvgPicture.asset(
                  platform.Platform.isIOS ? faceIdIcon : fingerPrintIcon,
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  height: 28,
                ),
                BodyTextPrimaryWithLineHeight(
                    text: platform.Platform.isIOS
                        ? "Click to log in with Face ID"
                        : "Click to log in with Fingerprint"),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
                      width: 200,
                      child: MainButton(
                          platform.Platform.isIOS
                              ? "Verify Face"
                              : "Verify Fingerprint", () async {
                        if (authAttempts < 3) {
                          BiometricAuthService biometricAuthService =
                              BiometricAuthService();
                          bool isBioAuthenticated =
                              await biometricAuthService.authenticate();
                          if (isBioAuthenticated) {
                            if (!mounted) return;
                            final bioModel = authProvider.biometricModel;
                            if (bioModel != null &&
                                bioModel.email != null &&
                                bioModel.password != null) {
                              if (!context.mounted) return;
                              final success = await authProvider.biometricLogin(
                                email: bioModel.email!,
                                password: bioModel.password!,
                                context: context,
                              );
                              if (!mounted) return;
                              if (success) {
                                if (context.mounted) {
                                  navToWithScreenName(
                                    context: context,
                                    screen: const BottomNavScreen(),
                                    isPushAndRemoveUntil: true,
                                  );
                                }
                              } else {
                                if (!mounted) return;
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Biometric login failed')),
                                  );
                                }
                              }
                            } else {
                              if (!mounted) return;
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'No biometric credentials found')),
                                );
                              }
                            }
                          } else {
                            authAttempts += 1;
                            setState(() {});
                            debugPrint("Number of attempt:::: $authAttempts");
                          }
                        } else {
                          if (context.mounted) {
                            navToWithScreenName(
                              context: context,
                              screen: const LoginScreen(),
                              isPushAndRemoveUntil: true,
                            );
                          }
                        }
                      })),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        clearHiveData();
                        navToWithScreenName(
                            context: context,
                            screen: const LoginScreen(),
                            isPushAndRemoveUntil: true);
                      },
                      child: const BodyTextPrimaryWithLineHeight(
                        text: "Switch Account",
                        textColor: mainColor,
                        fontWeight: mediumFont,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        clearHiveData();
                        navToWithScreenName(
                            context: context,
                            screen: const LoginScreen(),
                            isPushAndRemoveUntil: true);
                      },
                      child: const BodyTextPrimaryWithLineHeight(
                        text: "Login with Password",
                        textColor: mainColor,
                        fontWeight: mediumFont,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                  height: bottomPadding.h,
                )
              ],
            );
          })),
    );
  }
}
