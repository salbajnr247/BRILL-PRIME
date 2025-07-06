import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../Widgets/title_widget.dart';
import 'long_divider.dart';

class CustomAppbar extends StatelessWidget {
  final String title;
  final Widget? widget;
  final bool showArrowBack;
  final bool showDivider;
  const CustomAppbar(
      {super.key,
      required this.title,
      this.widget,
      this.showArrowBack = true,
      this.showDivider = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
          child: widget ??
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showArrowBack)
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(backArrowSvg)),
                  TitleWidget(
                    title: title,
                    fontSize: 16,
                    fontWeight: semiBoldFont,
                    textColor: blackTextColor,
                  ),
                  SvgPicture.asset(
                    backArrowSvg,
                    color: Colors.transparent,
                  ),
                ],
              ),
        ),
        if (showDivider)
          SizedBox(
            height: 20.h,
          ),
        if (showDivider) const LongDivider(),
      ],
    );
  }
}
