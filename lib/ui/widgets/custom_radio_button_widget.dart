import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/color_constants.dart';

class CustomRadioButtonWidget extends StatelessWidget {
  final bool isSelected;
  final double dimension;
  final Color selectedColor;
  final Color unselectedColor;
  const CustomRadioButtonWidget(
      {super.key,
      this.isSelected = false,
      this.dimension = 24,
      this.selectedColor = const Color.fromRGBO(255, 28, 137, 1),
      this.unselectedColor = inputBorderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimension.h,
      height: dimension.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? selectedColor : unselectedColor,
          )),
      child: Container(
        width: 20.h,
        height: 20.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            color: isSelected ? selectedColor : appBgColor),
      ),
    );
  }
}
