import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import 'components.dart';
import 'custom_text.dart';

class EarnAndAdvertiseCard extends StatelessWidget {
  final String title;
  final String text;
  final String btnText;
  final String img;
  final VoidCallback btnTap;
  const EarnAndAdvertiseCard(
      {super.key,
      required this.title,
      required this.text,
      required this.btnText,
      required this.btnTap,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215.h,
      padding: EdgeInsets.only(left: 7.w, top: 10.h, right: 16.w),
      decoration:
          BoxDecoration(color: white, borderRadius: BorderRadius.circular(5.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWithLineHeight(
            text: title,
            textColor: black,
            fontSize: 15,
            fontWeight: semiBoldFont,
          ),
          SizedBox(
            height: 11.h,
          ),
          SizedBox(
            width: 146.w,
            child: CustomTextWithLineHeight(
              text: text,
              textColor: black,
              fontSize: 8,
              fontWeight: mediumFont,
              lineHeight: 1.49,
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          MainButton(
            "Activate Now",
            () {},
            fontSize: 10,
            height: 35,
            border: 5,
            color: const Color.fromRGBO(11, 123, 204, 1),
          ),
          SizedBox(
            height: 12.h,
          ),
          Container(
            height: 88.h,
            width: 127.w,
            decoration: BoxDecoration(
                color: Colors.red,
                image:
                    DecorationImage(image: AssetImage(img), fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}
