import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/login_screen/login_screen.dart';
import 'package:brill_prime/utils/constants.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../models/first_step_account_creation.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../resources/constants/string_constants.dart';
import '../../utils/navigation_util.dart';
import '../Widgets/title_widget.dart';
import '../confirm_email/confirm_email_screen.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscure = true;
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
                          title: signUp,
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
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Full Name",
                          fullNameController,
                          isCapitalizeSentence: true,
                          type: TextInputType.name,
                          prefixIcon: const PrefixIcon(icon: nameIcon),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Email",
                          emailController,
                          isCapitalizeSentence: false,
                          type: TextInputType.emailAddress,
                          prefixIcon: const PrefixIcon(icon: emailIcon),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomField(
                          "Phone number",
                          phoneController,
                          isCapitalizeSentence: false,
                          length: 11,
                          formatters: numbersOnlyFormat,
                          type: TextInputType.phone,
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
                  SizedBox(height: 16.h),
                  PwdField(
                      hint: "Confirm Password",
                      controller: confirmPasswordController,
                      isObscured: obscure,
                      hasBorder: true,
                      onTap: () {
                        setState(() => obscure = !obscure);
                      },
                      prefixIcon: const PrefixIcon(icon: lockIcon)),
                  SizedBox(
                    height: 19.h,
                  ),
                  authProvider.isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : MainButton(
                          signUp,
                          fontWeight: mediumFont,
                          () async {
                            if (fullNameController.text.trim().length < 5) {
                              customSnackBar(
                                  context, "Enter a valid full name");
                            } else if (emailController.text.length < 4) {
                              customSnackBar(
                                context,
                                "Please enter a valid email",
                              );
                            } else if (passwordController.text.trim().length <
                                8) {
                              customSnackBar(context,
                                  "Password must be at least 8 characters");
                            } else if (!passwordController.text
                                .isValidPassword()) {
                              customSnackBar(context,
                                  "Password must contain at least one uppercase letter, one lowercase letter, one numeric digit, and one special character.");
                            } else {
                              final firstStepAccountCreation =
                                  FirstStepAccountCreation(
                                phoneNumber: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                fullName: fullNameController.text.trim(),
                              );
                              authProvider.updateFirstStepAccountCreation(
                                  firstStepAccountCreation);

                              final isRegistered = await authProvider
                                  .registerUser(context: context);
                              if (isRegistered && context.mounted) {
                                navToWithScreenName(
                                    context: context,
                                    screen: const ConfirmEmailScreen());
                              }
                            }
                          },
                        ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Center(
                    child: SizedBox(
                      width: 258.w,
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'By clicking the button above you agree to the Brill Prime',
                              style: TextStyle(
                                color: Color.fromRGBO(46, 46, 46, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' Terms of Service ',
                              style: TextStyle(
                                  color: Color.fromRGBO(46, 46, 46, 1),
                                  fontSize: 14,
                                  fontWeight: boldFont,
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(
                              text: 'and ',
                              style: TextStyle(
                                color: Color.fromRGBO(46, 46, 46, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy ',
                              style: TextStyle(
                                  color: Color.fromRGBO(46, 46, 46, 1),
                                  fontSize: 14,
                                  fontWeight: boldFont,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                    height: 15,
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
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      navToWithScreenName(
                          context: context, screen: const LoginScreen());
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyTextPrimaryWithLineHeight(
                          text: "Already have an account?",
                          textColor: Color.fromRGBO(19, 19, 19, 1),
                          fontWeight: thinFont,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        BodyTextPrimaryWithLineHeight(
                          text: "Sign In",
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

class PrefixIcon extends StatelessWidget {
  final String icon;
  const PrefixIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SvgPicture.asset(icon),
    );
  }
}

class SocialLoginIconWidget extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;
  const SocialLoginIconWidget(
      {super.key, required this.iconName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(height: 50, width: 50, child: Image.asset(iconName)),
    );
  }
}
