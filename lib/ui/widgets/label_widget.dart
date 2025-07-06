import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/font_constants.dart';
import 'custom_text.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  const LabelWidget(
      {super.key,
      required this.label,
      this.textColor = const Color(0xFF333333),
      this.fontWeight = boldFont,
      this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomTextWithLineHeight(
              text: label,
              textColor: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            )
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
      ],
    );
  }
}
