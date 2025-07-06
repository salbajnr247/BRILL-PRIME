import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/consumer/consumer_home.dart';
import 'package:brill_prime/ui/forgot_password_flow/forgot_password_screen.dart';
import 'package:brill_prime/ui/sign_up_option/sign_up_option_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../utils/navigation_util.dart';
import '../Widgets/custom_text.dart';
import '../Widgets/title_widget.dart';
import '../signup_screen/sign_up_screen.dart';
import '../vendor/complete_vendor_profile_screen.dart';
import '../vendor/vendor_home_screen.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;

  @override
  void initState() {
    emailController.text = kDebugMode ? "raymonddangdat@gmail.com" : '';
    emailController.text = kDebugMode ? "oushwa@mailto.plus" : "";
    // emailController.text = kDebugMode ? "sqeway@mailto.plus" : "";
    // emailController.text =
    //     kDebugMode ? "uxyben@mailto.plus" : ""; // email for merchant
    emailController.text = kDebugMode ? "youdag@mailto.plus" : "";
    emailController.text = kDebugMode ? "dangdat.fpk@gmail.com" : "";
    emailController.text = kDebugMode ? "ohvyke@mailto.plus" : "";
    // emailController.text = kDebugMode ? "realdangdat@gmail.com" : "";
    // emailController.text = kDebugMode ? "mwoton@mailto.plus" : "";
    // emailController.text = kDebugMode ? "utuca@mailto.plus" : "";
    emailController.text = kDebugMode ? "etypqa@mailto.plus" : "";
    passwordController.text = kDebugMode ? "Smart001@@" : '';
    super.initState();
    //   5531886652142950
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (authProvider.resMessage != '') {
                customSnackBar(context, authProvider.resMessage);

                ///Clear the response message to avoid duplicate
                authProvider.clear();
              }
            });
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: topPadding.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 46,
                            width: 60,
                            child: Image.asset(splashScreenLogo),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const TitleWidget(
                          title: "Sign In",
                          textColor: Color.fromRGBO(11, 26, 81, 1),
                          fontWeight: extraBoldFont,
                          fontSize: 25,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Email or phone number",
                          emailController,
                          isCapitalizeSentence: false,
                          type: TextInputType.emailAddress,
                          prefixIcon: const PrefixIcon(icon: emailIcon),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  PwdField(
                      hint: "Password",
                      controller: passwordController,
                      isObscured: obscure,
                      hasBorder: true,
                      onTap: () {
                        setState(() => obscure = !obscure);
                      },
                      prefixIcon: const PrefixIcon(icon: lockIcon)),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      navToWithScreenName(
                        context: context,
                        screen: const ForgotPasswordScreen(),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyTextPrimaryWithLineHeight(
                          text: "Forgot password?",
                          textColor: Color.fromRGBO(19, 19, 19, 1),
                          fontWeight: thinFont,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        BodyTextPrimaryWithLineHeight(
                          text: "Reset password",
                          textColor: Color.fromRGBO(11, 26, 81, 1),
                          fontWeight: boldFont,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 19.h,
                  ),
                  authProvider.isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : MainButton(
                          "Sign In",
                          fontWeight: mediumFont,
                          () async {
                            if (emailController.text.length < 4) {
                              customSnackBar(
                                context,
                                "Please enter a valid email",
                              );
                            } else if (passwordController.text.trim().length <
                                8) {
                              customSnackBar(context,
                                  "Password must be at least 8 characters");
                            } else {
                              final isLoggedIn = await authProvider.loginUser(
                                  context: context,
                                  password: passwordController.text,
                                  email: emailController.text);
                              if (isLoggedIn && context.mounted) {
                                if (authProvider.userProfile?.data.role ==
                                    consumer.toUpperCase()) {
                                  navToWithScreenName(
                                      context: context,
                                      screen: ConsumerHomePage(
                                        currentLocation:
                                            authProvider.userCurrentLocation!,
                                      ));
                                } else if (authProvider
                                        .userProfile?.data.role ==
                                    vendor.toUpperCase()) {
                                  if (authProvider.userProfile?.data.vendor ==
                                      null) {
                                    navToWithScreenName(
                                        context: context,
                                        screen: const CompleteVendorScreen());
                                  } else {
                                    navToWithScreenName(
                                        context: context,
                                        screen: const VendorHomeScreen());
                                  }
                                } else {}
                              }
                            }
                          },
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: BodyTextPrimaryWithLineHeight(
                          text: "or continue with",
                          fontWeight: thinFont,
                          textColor: Color.fromRGBO(19, 19, 19, 1),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialLoginIconWidget(iconName: googleIcon, onTap: () {}),
                      const SizedBox(
                        width: 20,
                      ),
                      SocialLoginIconWidget(iconName: appleLogo, onTap: () {}),
                      const SizedBox(
                        width: 20,
                      ),
                      SocialLoginIconWidget(
                          iconName: facebookLogo, onTap: () {}),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      navToWithScreenName(
                          context: context,
                          screen: const SignUpOptionScreen(),
                          isReplacement: true);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyTextPrimaryWithLineHeight(
                          text: "Don't have an account?",
                          textColor: Color.fromRGBO(19, 19, 19, 1),
                          fontWeight: thinFont,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        BodyTextPrimaryWithLineHeight(
                          text: signUp,
                          textColor: Color.fromRGBO(11, 26, 81, 1),
                          fontWeight: boldFont,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            );
          })),
    );
  }
}
