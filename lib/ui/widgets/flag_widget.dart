import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlagWidget extends StatelessWidget {
  final double dimension;
  const FlagWidget({super.key, this.dimension = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.h,
      width: 22.h,
      decoration: BoxDecoration(
        // color: mainColor,
        borderRadius: BorderRadius.circular(100.r),
        image: const DecorationImage(image: AssetImage(""), fit: BoxFit.cover),
        // borderRadius: BorderRadius.circular(100.r)
      ),
    );
  }
}
