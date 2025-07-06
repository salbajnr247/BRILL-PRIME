import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/constants/font_constants.dart';
import 'custom_text.dart';

class InvalidInputWidget extends StatelessWidget {
  final String message;
  const InvalidInputWidget({super.key, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        children: [
          SvgPicture.asset(""),
          SizedBox(
            width: 5.w,
          ),
          CustomTextWithLineHeight(
            alignCenter: true,
            text: message,
            fontWeight: mediumFont,
            textColor: const Color(0xFFFF784B),
            fontSize: 12,
          )
        ],
      ),
    );
  }
}
