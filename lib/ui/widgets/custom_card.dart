import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import 'custom_text.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String leadingIcon;
  final Color? bgColor;
  final Color titleColor;
  final Color subTitleColor;
  final VoidCallback onTap;
  final double iconSize;
  final Color arrowColor;
  final double height;
  final IconData trailingIcon;
  final String svgIcon;
  const CustomListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.leadingIcon = "",
    this.iconSize = 46,
    this.titleColor = black,
    this.arrowColor = white,
    this.height = 82,
    this.trailingIcon = Icons.arrow_forward_ios,
    this.subTitleColor = const Color.fromRGBO(255, 255, 255, 0.58),
    this.svgIcon = "",
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.r),
        // height: height.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r), color: bgColor),
        child: Row(
          children: [
            if (leadingIcon.isNotEmpty)
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: iconSize.h,
                    width: iconSize.h,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(leadingIcon))),
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                ],
              ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BodyTextPrimaryWithLineHeight(
                  text: title,
                  textColor: titleColor,
                  fontWeight: boldFont,
                  lineHeight: 1.28,
                ),
                if (subTitle.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: 4.h,
                      ),
                      CustomTextNoOverFlow(
                        text: subTitle,
                        textColor: subTitleColor,
                        fontSize: 12,
                        fontWeight: mediumFont,
                      )
                    ],
                  ),
              ],
            )),
            if (svgIcon.isEmpty)
              Icon(
                trailingIcon,
                color: arrowColor,
                size: 15.h,
              ),
            if (svgIcon.isNotEmpty) SvgPicture.asset(svgIcon),
          ],
        ),
      ),
    );
  }
}
