import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../Widgets/custom_text.dart';

class LoadMoreWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const LoadMoreWidget(
      {super.key, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: isLoading
          ? const CupertinoActivityIndicator()
          : InkWell(
              onTap: onTap,
              child: const Center(
                child: BodyTextPrimaryWithLineHeight(
                  text: "Load More",
                  fontWeight: mediumFont,
                  textColor: mainColor,
                ),
              ),
            ),
    );
  }
}
