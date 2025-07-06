import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryFlagWidget extends StatelessWidget {
  final double dimension;
  final String flagUrl;
  final double borderWidth;
  final bool showBorder;
  const CountryFlagWidget({
    super.key,
    this.dimension = 30,
    this.borderWidth = 2.4,
    this.showBorder = true,
    required this.flagUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: dimension.h,
      width: dimension.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: showBorder
              ? Border.all(
                  color: const Color.fromRGBO(193, 232, 246, 1), width: 2.4.w)
              : Border.all(width: 0, color: Colors.transparent),
          image:
              DecorationImage(image: NetworkImage(flagUrl), fit: BoxFit.cover)),
    );
  }
}
