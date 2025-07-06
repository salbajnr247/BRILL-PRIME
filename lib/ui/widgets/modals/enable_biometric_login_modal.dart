import 'dart:io' as platform;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../resources/constants/color_constants.dart';
import '../../../../../resources/constants/dimension_constants.dart';
import '../../../../../resources/constants/font_constants.dart';
import '../../../../../resources/constants/image_constant.dart';
import '../../Widgets/custom_text.dart';
import '../components.dart';

Future showEnableBiometricLoginModal(BuildContext importedContext) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: importedContext,
    isDismissible: false,
    backgroundColor: white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(modalRadius.r),
          topRight: Radius.circular(modalRadius.r)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(modalRadius.r),
                  topRight: Radius.circular(modalRadius.r)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.2,
                          maxHeight: MediaQuery.of(context).size.height * 0.4),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          const SizedBox(height: 30),
                          const BodyTextPrimaryWithLineHeight(
                            text: "Enable Biometric Login",
                            fontWeight: boldFont,
                            textColor: blackTextColor,
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          SvgPicture.asset(
                            platform.Platform.isIOS
                                ? faceIdIcon
                                : fingerPrintIcon,
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                child: MainButton(
                                    "Enable", fontSize: 14, () async {}),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const BodyTextPrimaryWithLineHeight(
                                text: "Not Now",
                                fontWeight: semiBoldFont,
                                textColor: mainColor,
                              )),
                          SizedBox(
                            height: topPadding.h,
                          ),
                        ],
                      )),
                ],
              ),
            )),
      );
    },
  );
}
