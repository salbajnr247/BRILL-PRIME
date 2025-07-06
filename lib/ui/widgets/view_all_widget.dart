import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/string_constants.dart';
import '../Widgets/custom_text.dart';

class ViewAllWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color titleTextColor;
  final Color subTitleTextColor;
  final FontWeight titleFontWeight;
  final double titleFontSize;
  final double subTitleFontSize;
  final String subTitle;
  final String leadingIcon;
  final int padding;
  const ViewAllWidget(
      {super.key,
      required this.title,
      required this.onTap,
      this.subTitleTextColor = const Color(0xFF647A9A),
      this.titleFontWeight = semiBoldFont,
      this.titleTextColor = const Color(0xFF647A9A),
      this.titleFontSize = 16,
      this.subTitle = viewAll,
      this.subTitleFontSize = 14,
      this.padding = horizontalPadding,
      this.leadingIcon = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (leadingIcon.isNotEmpty) SvgPicture.asset(leadingIcon),
              BodyTextLightWithLineHeight(
                fontSize: titleFontSize,
                text: title,
                fontWeight: titleFontWeight,
                textColor: titleTextColor,
              ),
            ],
          ),
          InkWell(
            onTap: onTap,
            child: BodyTextLightWithLineHeight(
              text: subTitle,
              fontSize: subTitleFontSize,
              underline: true,
              textColor: subTitleTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
