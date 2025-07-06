import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../resources/constants/dimension_constants.dart';
import '../../../../resources/constants/font_constants.dart';
import '../../../Widgets/custom_text.dart';

class SectionHeaderWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String seeMoreText;
  const SectionHeaderWidget(
      {super.key,
      required this.onTap,
      required this.title,
      this.seeMoreText = ""});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyTextPrimaryWithLineHeight(
              text: title,
              textColor: const Color(0xFF0C0C0C),
              fontSize: 14,
              fontWeight: semiBoldFont,
            ),
            BodyTextPrimaryWithLineHeight(
              text: seeMoreText,
              textColor: const Color(0xFFD89B65),
              fontSize: 13,
              fontWeight: mediumFont,
            ),
          ],
        ),
      ),
    );
  }
}
