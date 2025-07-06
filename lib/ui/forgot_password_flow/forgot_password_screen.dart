import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/signup_screen/sign_up_screen.dart';
import 'package:brill_prime/ui/widgets/dialogs/check_your_email_dialog.dart';
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
import '../widgets/textfields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

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
          child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: topPadding.h,
                ),
                const CustomAppbar(
                  title: "",
                  showArrowBack: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 28.h,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextWithLineHeight(
                              text: "Reset Password",
                              textColor: blackTextColor,
                              fontWeight: boldFont,
                              fontSize: 20,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Enter your email",
                                emailController,
                                isCapitalizeSentence: false,
                                type: TextInputType.emailAddress,
                                prefixIcon: const PrefixIcon(icon: emailIcon),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const BodyTextPrimaryWithLineHeight(
                            text: "A link would be sent to your email"),
                        const SizedBox(
                          height: 40,
                        ),
                        authProvider.requestingForgotPassword
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : MainButton(
                                "Submit",
                                () async {
                                  if (emailController.text.trim().length > 5) {
                                    authProvider.updateEmailForPasswordReset(
                                        newEmail: emailController.text);
                                    final requested = await authProvider
                                        .forgotPassword(context: context);
                                    if (mounted && requested) {
                                      if (context.mounted) {
                                        showCheckYourEmailDialog(context);
                                      }
                                    }
                                  }
                                },
                              )
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
            );
          })),
    );
  }
}
