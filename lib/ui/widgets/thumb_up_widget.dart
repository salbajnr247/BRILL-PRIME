import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThumbUpWidget extends StatelessWidget {
  const ThumbUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122.h,
      width: 122.h,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(""), fit: BoxFit.cover)),
    );
  }
}
