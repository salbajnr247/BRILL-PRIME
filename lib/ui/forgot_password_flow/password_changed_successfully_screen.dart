import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../resources/constants/string_constants.dart';
import '../../utils/navigation_util.dart';
import '../Widgets/custom_text.dart';
import '../Widgets/title_widget.dart';
import '../login_screen/login_screen.dart';
import '../widgets/components.dart';

class PasswordChangedSuccessfullyScreen extends StatefulWidget {
  final bool isPIN;
  const PasswordChangedSuccessfullyScreen({super.key, this.isPIN = false});

  @override
  State<PasswordChangedSuccessfullyScreen> createState() =>
      _PasswordChangedSuccessfullyScreenState();
}

class _PasswordChangedSuccessfullyScreenState
    extends State<PasswordChangedSuccessfullyScreen> {
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
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 285.h,
                      ),
                      SizedBox(
                        height: 73.h,
                        width: 74.h,
                        child: Image.asset(passwordChangedImg),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      TitleWidget(
                        title: widget.isPIN ? "PIN Changed" : passwordChanged,
                        fontSize: 23,
                      ),
                      BodyTextLightWithLineHeight(
                        text: widget.isPIN
                            ? "Your PIN has been changed \nsuccessfully"
                            : yourPasswordHasBeenChanged,
                        alignCenter: true,
                        fontWeight: mediumFont,
                        textColor: blackTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                child: MainButton(
                  widget.isPIN ? "Done" : "Back to Log in",
                  () async {
                    if (widget.isPIN) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } else {
                      navToWithScreenName(
                          context: context,
                          screen: const LoginScreen(),
                          isPushAndRemoveUntil: true);
                    }
                  },
                ),
              ),
              SizedBox(
                height: bottomPadding.h,
              )
            ],
          )),
    );
  }
}
