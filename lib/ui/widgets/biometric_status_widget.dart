
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/image_constant.dart';
import 'custom_text.dart';
import 'dart:io' as platform;

class BiometricStatusWidget extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onTap;
  final bool showToggle;

  const BiometricStatusWidget({
    Key? key,
    required this.isEnabled,
    required this.onTap,
    this.showToggle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isEnabled ? mainColor.withOpacity(0.2) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isEnabled ? mainColor.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              platform.Platform.isIOS ? faceIdIcon : fingerPrintIcon,
              height: 24.w,
              width: 24.w,
              color: isEnabled ? mainColor : Colors.grey[500],
            ),
          ),

          SizedBox(width: 16.w),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyTextPrimaryWithLineHeight(
                  text: platform.Platform.isIOS ? "Face ID" : "Fingerprint",
                  fontWeight: FontWeight.w600,
                  textColor: blackTextColor,
                  fontSize: 16,
                ),
                SizedBox(height: 4.h),
                BodyTextPrimaryWithLineHeight(
                  text: isEnabled 
                      ? "Enabled for quick access"
                      : "Tap to enable secure login",
                  fontWeight: FontWeight.normal,
                  textColor: Colors.grey[600]!,
                  fontSize: 13,
                ),
              ],
            ),
          ),

          // Toggle or chevron
          if (showToggle)
            Switch(
              value: isEnabled,
              onChanged: (_) => onTap(),
              activeColor: mainColor,
              activeTrackColor: mainColor.withOpacity(0.3),
            )
          else
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24.w,
            ),
        ],
      ),
    );
  }
}
