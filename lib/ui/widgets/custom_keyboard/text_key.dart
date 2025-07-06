import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../custom_text.dart';

class TextKey extends StatelessWidget {
  final bool isPlainText;
  const TextKey(
      {super.key,
      required this.text,
      required this.onTextInput,
      this.flex = 1,
      this.isPlainText = false});

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTextInput.call(text);
        },
        child: isPlainText
            ? Container(
                height: 51.h,
                width: 50.w,
                alignment: Alignment.center,
                child: BodyTextPrimaryWithLineHeight(
                    text: text,
                    fontSize: 24,
                    fontWeight: boldFont,
                    textColor: black))
            : Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: white)),
                alignment: Alignment.center,
                child: BodyTextPrimaryWithLineHeight(
                    text: text,
                    fontSize: 24,
                    fontWeight: mediumFont,
                    textColor: white)));
  }
}

class TextKeyPlain extends StatelessWidget {
  const TextKeyPlain({
    super.key,
    required this.text,
    required this.onTextInput,
    this.flex = 1,
  });

  final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTextInput.call(text);
        },
        child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: white)),
            alignment: Alignment.center,
            child: BodyTextPrimaryWithLineHeight(
                text: text,
                fontSize: 24,
                fontWeight: mediumFont,
                textColor: white)));
  }
}
