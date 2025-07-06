import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/color_constants.dart';

class PinUnfilled extends StatelessWidget {
  const PinUnfilled({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      width: 25.h,
      height: 25.h,
      decoration: BoxDecoration(
          color: white,
          border: Border.all(
            width: 0.5.w,
            color: const Color.fromRGBO(0, 0, 0, 0.33),
          ),
          borderRadius: BorderRadius.circular(100.r)),
    );
  }
}

class PinFilled extends StatelessWidget {
  const PinFilled({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.h,
      height: 25.h,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(49, 184, 95, 1),
          borderRadius: BorderRadius.circular(100.r)),
    );
  }
}

class PassCodeFilled extends StatelessWidget {
  const PassCodeFilled({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.h,
      height: 55.h,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(8.r)),
      child: Container(
        height: 15.h,
        width: 15.w,
        decoration: BoxDecoration(
            color: black, borderRadius: BorderRadius.circular(100.r)),
      ),
    );
  }
}

class PasscodeUnfilled extends StatelessWidget {
  const PasscodeUnfilled({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55.h,
      height: 55.h,
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(8.r)),
    );
  }
}
