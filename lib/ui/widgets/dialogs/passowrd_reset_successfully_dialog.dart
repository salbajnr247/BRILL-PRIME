import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/ui/login_screen/login_screen.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../resources/constants/image_constant.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../Widgets/custom_text.dart';
import '../components.dart';
import '../custom_snack_back.dart';

Future<void> showPasswordResetSuccessfullyDialog(
  BuildContext importedContext, {
  bool barrierDismissible = false,
}) async {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: importedContext,
      builder: (BuildContext context) => PasswordResetSuccessfullyDialog(
            importedContext: importedContext,
          ));
}

class PasswordResetSuccessfullyDialog extends StatefulWidget {
  final BuildContext importedContext;
  const PasswordResetSuccessfullyDialog(
      {super.key, required this.importedContext});

  @override
  State<PasswordResetSuccessfullyDialog> createState() =>
      _PasswordResetSuccessfullyDialogState();
}

class _PasswordResetSuccessfullyDialogState
    extends State<PasswordResetSuccessfullyDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: Colors.transparent,
        child: CustomContainerButton(
          onTap: () {},
          title: "",
          borderRadius: 12,
          height: 320,
          verticalPadding: 10,
          horizontalPadding: 20,
          useHeight: true,
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(congratulationsIcon)),
              SizedBox(
                height: 20.h,
              ),
              const BodyTextPrimaryWithLineHeight(
                text: "Password Reset Successful",
                textColor: Color(0xFF181B01),
                fontSize: 16,
                fontWeight: extraBoldFont,
              ),
              SizedBox(
                height: 20.h,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BodyTextPrimaryWithLineHeight(
                  text:
                      "You can now  login to Brill Prime with your new password",
                  textColor: Color(0xFF181B01),
                  fontSize: 12,
                  alignCenter: true,
                  fontWeight: lightFont,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (authProvider.resMessage != '') {
                    customSnackBar(context, authProvider.resMessage,
                        isError: authProvider.isErrorMessage);

                    ///Clear the response message to avoid duplicate
                    authProvider.clear();
                  }
                });
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                          child: MainButton("Login now", () async {
                        Navigator.pop(context);
                        navToWithScreenName(
                            context: widget.importedContext,
                            screen: const LoginScreen(),
                            isPushAndRemoveUntil: true);
                      })),
                    ],
                  ),
                );
              })
            ],
          ),
        ));
  }
}
