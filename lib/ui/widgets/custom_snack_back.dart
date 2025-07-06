import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


import '../../resources/constants/image_constant.dart';

void customSnackBar(BuildContext context, String message,
    {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          SizedBox(
            width: 24.h,
            height: 24.h,
            child: SvgPicture.asset(isError ? errorIcon : successIcon),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 12,
                decorationColor: Colors.white,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0C0C0C),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: const Color(0xFFE6E6E6)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
    ),
  );
}
