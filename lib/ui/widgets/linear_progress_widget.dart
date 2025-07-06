import 'package:flutter/material.dart';

import '../../resources/constants/color_constants.dart';

class LinearProgressIndicatorWidget extends StatelessWidget {
  final double progress;
  final Color backGroundColor;
  final Color activeColor;
  const LinearProgressIndicatorWidget(
      {super.key,
      required this.progress,
      this.backGroundColor = const Color.fromRGBO(217, 217, 217, 1),
      this.activeColor = savingsDeepGreenColor});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Expanded(
        //   child: LinearPercentIndicator(
        //     lineHeight: 4.h,
        //     padding: EdgeInsets.zero,
        //     barRadius: const Radius.circular(43),
        //     percent: progress < 0 ? 0 : progress,
        //     backgroundColor: backGroundColor,
        //     progressColor: activeColor,
        //   ),
        // ),
      ],
    );
  }
}
