import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/signup_screen/sign_up_screen.dart';
import 'package:brill_prime/ui/widgets/dialogs/passowrd_reset_successfully_dialog.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../Widgets/custom_text.dart';
import '../widgets/components.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: topPadding.h,
              ),
              const CustomAppbar(title: ""),
              SizedBox(
                height: 32.h,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CustomTextWithLineHeight(
                        text: "Set New Password",
                        textColor: blackTextColor,
                        fontWeight: semiBoldFont,
                        fontSize: 20,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      PwdField(
                        hint: "Enter your password",
                        controller: passwordController,
                        isObscured: obscure,
                        hasBorder: true,
                        onTap: () {
                          setState(() => obscure = !obscure);
                        },
                        prefixIcon: const PrefixIcon(icon: lockIcon),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      PwdField(
                        hint: "Confirm your password",
                        controller: confirmPasswordController,
                        isObscured: obscure,
                        hasBorder: true,
                        onTap: () {
                          setState(() => obscure = !obscure);
                        },
                        prefixIcon: const PrefixIcon(icon: lockIcon),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Consumer<AuthProvider>(
                          builder: (ctx, authProvider, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (authProvider.resMessage != '') {
                            customSnackBar(context, authProvider.resMessage);

                            ///Clear the response message to avoid duplicate
                            authProvider.clear();
                          }
                        });
                        return authProvider.resettingPassword
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : MainButton(
                                "Reset password",
                                () async {
                                  if (passwordController.text.trim().length <
                                      8) {
                                    customSnackBar(context,
                                        "Password must be at least 8 characters");
                                  } else if (passwordController.text.trim() !=
                                      confirmPasswordController.text.trim()) {
                                    customSnackBar(
                                        context, "Password mismatch");
                                  } else if (!passwordController.text
                                      .isValidPassword()) {
                                    customSnackBar(context,
                                        "Password must contain at least one uppercase letter, one lowercase letter, one numeric digit, and one special character.");
                                  } else {
                                    if (!authProvider.resettingPassword) {
                                      final passwordReset =
                                          await authProvider.resetPassword(
                                              context: context,
                                              newPassword:
                                                  passwordController.text);
                                      if (mounted && passwordReset) {
                                        if (context.mounted) {
                                          showPasswordResetSuccessfullyDialog(
                                              context);
                                        }
                                      }
                                    }
                                  }
                                },
                              );
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              SizedBox(
                height: bottomPadding.h,
              )
            ],
          )),
    );
  }
}
