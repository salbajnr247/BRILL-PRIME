import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:flutter/material.dart';

import 'color_constants.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, Color textColor, FontWeight fontWeight,
    {bool underline = false}
    // ignore: unused_element
    ) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: textColor,
    decoration: underline ? TextDecoration.underline : null,
    fontWeight: fontWeight,
  );
}

TextStyle _getTextStyleWithLineHeight(double fontSize, String fontFamily,
    Color textColor, FontWeight fontWeight, double lineHeight,
    {double letterSpacing = 0,
    required bool showLineThrough,
    bool underline = false}) {
  return TextStyle(
      fontSize: fontSize,
      fontFamily: fontFamily,
      color: textColor,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: lineHeight,
      decoration: showLineThrough
          ? TextDecoration.lineThrough
          : underline
              ? TextDecoration.underline
              : null);
}

TextStyle _getDecoratedTextStyle(
  double fontSize,
  String fontFamily,
  Color textColor,
  FontWeight fontWeight,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    color: textColor,
    fontWeight: fontWeight,
    decoration: TextDecoration.underline,
  );
}

//Bold Style
TextStyle getBoldStyle({double fontSize = 24, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, semiBoldFont);
}

//Bold Style
TextStyle getAppBarTitleStyle(
    {double fontSize = 16, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, titleFont);
}

//Bold Style
// TextStyle getDecoratedTextStyle({double fontSize = 16, required Color textColor}){
//   return _getDecoratedTextStyle(fontSize, FontConstants.fontFamily, textColor, FontWeightManager.title);
// }

TextStyle getDecoratedTextStyle(
    {double fontSize = 16, required Color textColor}) {
  return _getDecoratedTextStyle(
    fontSize,
    FontConstants.fontFamily,
    textColor,
    mediumFont,
  );
}

//Bold Style
TextStyle getCustomTextStyle({
  required double fontSize,
  required Color textColor,
  required FontWeight fontWeight,
  String fontFamily = FontConstants.fontFamily,
  bool underlined = false,
}) {
  return _getTextStyle(fontSize, fontFamily, textColor, fontWeight,
      underline: underlined);
}

TextStyle getRichTextStyle(
    {required double fontSize,
    required Color textColor,
    required FontWeight fontWeight,
    bool showLineThrough = false,
    String fontFamily = FontConstants.fontFamily}) {
  return _getTextStyleWithLineHeight(
      fontSize, fontFamily, textColor, fontWeight, 1.5,
      showLineThrough: showLineThrough);
}

TextStyle textInputStyle() {
  return _getTextStyle(14, FontConstants.fontFamily, black, regularFont);
}

//TextStyle with line height
TextStyle getTextStyleWithLineHeight({
  required double fontSize,
  required Color textColor,
  required FontWeight fontWeight,
  double letterSpacing = 0,
  bool showLineThrough = false,
  bool underLine = false,
  double lineHeight = 16 * 1.5,
  String fontFamily = FontConstants.fontFamily,
}) {
  return _getTextStyleWithLineHeight(
      fontSize, fontFamily, textColor, fontWeight, lineHeight,
      letterSpacing: letterSpacing,
      showLineThrough: showLineThrough,
      underline: underLine);
}

//Bold Style
TextStyle getHintStyle({double fontSize = 14, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, hintWeightFont);
}

//Page subtitle Style
TextStyle getPageSubtitleStyle(
    {double fontSize = 20, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, titleFont);
}

//Regular Style
TextStyle getRegularStyle({double fontSize = 16, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, regularFont);
}

//Semibold Style
TextStyle getSemiBoldStyle({double fontSize = 24, required Color textColor}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, textColor, semiBoldFont);
}
