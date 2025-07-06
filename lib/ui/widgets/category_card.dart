import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/color_constants.dart';
import 'custom_text.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageIcon;
  final Color bgColor;
  final VoidCallback onTap;
  final double height;
  final double paddingTop;
  final double paddingLeft;
  final double iconHeight;
  final double titleToIconHeight;
  final double fontSize;
  const CategoryCard(
      {super.key,
      required this.title,
      required this.bgColor,
      required this.onTap,
      this.iconHeight = 101,
      this.paddingLeft = 18,
      this.paddingTop = 13,
      this.titleToIconHeight = 12,
      this.fontSize = 12,
      this.height = 144,
      required this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height.h,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(7)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: paddingTop.h,
            ),
            Medium12px(
              text: title,
              textColor: white,
              fontSize: fontSize,
              lineHeight: 1.5,
            ),
            // SizedBox(height: titleToIconHeight.h,),
            const Spacer(),
            Center(
              child: Container(
                height: iconHeight.h,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imageIcon))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
