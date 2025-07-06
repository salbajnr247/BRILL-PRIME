import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:flutter/material.dart';

class CustomSelectionButtonWidget extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const CustomSelectionButtonWidget(
      {super.key,
      required this.title,
      this.isActive = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomContainerButton(
      onTap: onTap,
      title: title,
      borderColor: mainColor,
      horizontalPadding: 20,
      verticalPadding: 7,
      fontSize: 12,
      borderRadius: 5,
      bgColor: isActive ? mainColor : white,
      textColor: isActive ? white : const Color.fromRGBO(19, 19, 19, 1),
    );
  }
}
