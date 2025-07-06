import 'package:flutter/material.dart';

class CustomVerticalDividerWidget extends StatelessWidget {
  final double height;
  final Color color;
  const CustomVerticalDividerWidget(
      {super.key, this.height = 15, this.color = const Color(0xFF0A0A0B)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
      width: 1,
    );
  }
}
