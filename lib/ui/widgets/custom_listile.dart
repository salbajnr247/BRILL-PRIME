import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import 'custom_text.dart';

class CustomListTileWidget extends StatelessWidget {
  final String title;
  final String leadingIcon;
  final String subTitle;
  final Color bgColor;
  final double horizontalPadding;
  final double verticalPadding;
  final FontWeight titleFontWeight;
  final FontWeight subTitleFontWeight;
  final double leadingIconDimension;
  final IconData trailingIcon;
  final VoidCallback onTap;
  const CustomListTileWidget(
      {super.key,
      required this.title,
      required this.leadingIcon,
      required this.subTitle,
      required this.onTap,
      this.bgColor = white,
      this.horizontalPadding = 15,
      this.verticalPadding = 13,
      this.leadingIconDimension = 46,
      this.titleFontWeight = boldFont,
      this.subTitleFontWeight = mediumFont,
      this.trailingIcon = Icons.arrow_forward_ios});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(10.r)),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding.w,
          vertical: verticalPadding.h,
        ),
        child: Row(
          children: [
            Container(
              height: leadingIconDimension.h,
              width: leadingIconDimension.h,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(leadingIcon), fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 11.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWithLineHeight(
                  text: title,
                  fontWeight: titleFontWeight,
                  textColor: black,
                  fontSize: 14,
                ),
                CustomTextWithLineHeight(
                  text: subTitle,
                  fontWeight: subTitleFontWeight,
                  textColor: const Color(0x93282828),
                  fontSize: 12,
                ),
              ],
            )),
            Icon(
              trailingIcon,
              size: 15.h,
              color: const Color.fromRGBO(41, 45, 50, 1),
            )
          ],
        ),
      ),
    );
  }
}
