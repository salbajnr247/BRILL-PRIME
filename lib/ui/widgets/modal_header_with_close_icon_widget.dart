import 'package:brill_prime/ui/widgets/pull_down_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/constants/dimension_constants.dart';

class ModalHeaderWithCloseIconWidget extends StatelessWidget {
  const ModalHeaderWithCloseIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: horizontalPadding.w),
          child: Container(width: 40),
        ),
        const PullDownIndicator(),
        Padding(
          padding: EdgeInsets.only(right: horizontalPadding.w),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("")),
        )
      ],
    );
  }
}
