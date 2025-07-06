import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import 'custom_text.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final Color textColor;
  final bool showLeadingIcon;
  final FontWeight fontWeight;
  final VoidCallback onTap;
  final Color bgColor;
  final String icon;
  const CustomContainer(
      {super.key,
      required this.title,
      required this.onTap,
      this.bgColor = cardColor,
      this.icon = "",
      this.textColor = const Color.fromRGBO(0, 0, 0, 0.67),
      this.fontWeight = boldFont,
      this.showLeadingIcon = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9), color: bgColor),
        child: Row(
          mainAxisAlignment: showLeadingIcon
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (showLeadingIcon) SvgPicture.asset(icon),
            const SizedBox(
              width: 11,
            ),
            SemiBold12px(
              text: title,
              fontWeight: semiBoldFont,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
