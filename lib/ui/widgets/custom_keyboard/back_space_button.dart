import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../resources/constants/image_constant.dart';

Widget backSpaceButton(BuildContext context, {bool isPlainText = false}) {
  return Container(
    height: 51.h,
    width: 59.w,
    // decoration: BoxDecoration(
    //   color: isPlainText ? appBgColor : cardColor,
    //   borderRadius: BorderRadius.circular(100),
    // ),
    alignment: Alignment.center,
    child: isPlainText
        ? SizedBox(height: 16.h, child: Image.asset(spaceBar))
        : SvgPicture.asset(backSpace),
  );
}

Widget emptyButton({bool isPlainText = false}) {
  return Container(
    alignment: Alignment.center,
    height: 56.h,
    width: 64.w,
    child: SvgPicture.asset(
      isPlainText ? plainTextTouchId : touchId,
      height: 28.h,
      width: 28.h,
    ),
  );
}
