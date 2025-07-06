import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../utils/navigation_util.dart';
import '../Widgets/custom_text.dart';
import '../Widgets/title_widget.dart';
import '../login_screen/login_screen.dart';
import '../widgets/components.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_snack_back.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  TextEditingController otpController = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  Color incompleteContainerColor = const Color(0xFF282828);
  Color completeContainerColor = const Color.fromRGBO(49, 184, 95, 1);
  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    // customSnackBar(context,
    //     "6-digit Verification code has been send to your email address.");
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          // top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopPadding(),
              const CustomAppbar(title: ""),
              SizedBox(
                height: 31.h,
              ),
              Expanded(
                child:
                    Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (authProvider.resMessage != '') {
                      customSnackBar(context, authProvider.resMessage);

                      ///Clear the response message to avoid duplicate
                      authProvider.clear();
                    }
                  });
                  return SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: Column(
                      children: [
                        const TitleWidget(
                          title: "Verify it’s you",
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textStyle: const TextStyle(
                              color: Colors.black, fontWeight: mediumFont),
                          length: 6,
                          obscureText: false,
                          autoFocus: true,
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.circle,
                            fieldHeight: 58,
                            fieldWidth: 58,
                            activeBorderWidth: 1,
                            selectedBorderWidth: 1,
                            inactiveBorderWidth: 1,
                            disabledBorderWidth: 1,
                            errorBorderWidth: 1,
                            activeColor: mainColor,
                            inactiveColor: borderGrey,
                            inactiveFillColor: white,
                            selectedColor: mainColor,
                            selectedFillColor: white,
                            activeFillColor: white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            debugPrint("Completed");
                            setState(() {});
                          },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            return true;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const BodyTextLightWithLineHeight(
                          text: "A verification code has been sent to",
                          textColor: Color.fromRGBO(19, 19, 19, 1),
                          fontSize: 12,
                        ),
                        BodyTextLightWithLineHeight(
                          text:
                              "${authProvider.firstStepAccountCreation?.email}",
                          textColor: const Color.fromRGBO(11, 26, 81, 1),
                          fontSize: 12,
                          fontWeight: boldFont,
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        authProvider.isVerifyingOTP
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : MainButton(
                                "Submit",
                                () async {
                                  if (otpController.text
                                              .trim()
                                              .toString()
                                              .length ==
                                          6 &&
                                      !authProvider.isVerifyingOTP) {
                                    final emailVerified =
                                        await authProvider.verifyOTP(
                                            otp: otpController.text,
                                            context: context);
                                    if (mounted && emailVerified) {
                                      if (context.mounted) {
                                        navToWithScreenName(
                                            context: context,
                                            screen: const LoginScreen());
                                      }
                                    } else {
                                      otpController.text = "";
                                      setState(() {});
                                    }
                                  }
                                },
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const BodyTextLightWithLineHeight(
                                  text: "Did not get code? ",
                                  textColor: Color.fromRGBO(11, 26, 81, 1),
                                  fontWeight: mediumFont,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (!authProvider.isVerifyingOTP ||
                                        !authProvider.requestingOTP) {
                                      authProvider.requestOTP(
                                          email: authProvider
                                                  .firstStepAccountCreation
                                                  ?.email ??
                                              authProvider
                                                  .emailForPasswordReset,
                                          context: context);
                                    }
                                  },
                                  child: BodyTextLightWithLineHeight(
                                    text: authProvider.requestingOTP
                                        ? "Resending..."
                                        : "Resend",
                                    textColor:
                                        const Color.fromRGBO(11, 26, 81, 1),
                                    fontWeight: mediumFont,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          )),
    );
  }
}
