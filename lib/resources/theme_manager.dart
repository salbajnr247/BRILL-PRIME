import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:flutter/material.dart';
import 'constants/color_constants.dart';
import 'constants/styles_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      primaryColor: mainColor,
      disabledColor: disabledButtonColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,

      //  Card Theme
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: cardElevation,
      ),

      //    AppBar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: white,
        elevation: appBarElevation,
        titleTextStyle: getAppBarTitleStyle(textColor: mainColor),
      ),

      //   Button theme
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          buttonColor: mainColor,
          splashColor: mainColor),

      //  Elevated button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        textStyle: getAppBarTitleStyle(textColor: white),
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonBorderRadius),
        ),
      )),

      //  Text Theme
      textTheme: TextTheme(
          displayLarge: getBoldStyle(textColor: mainColor, fontSize: 24),
          displayMedium: getPageSubtitleStyle(textColor: mainColor),
          bodyLarge: getRegularStyle(textColor: lightTextColor)),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(contentPadding),
        hintStyle: getHintStyle(textColor: hintColor),
        labelStyle: getHintStyle(textColor: labelColor),
        errorStyle: getHintStyle(textColor: errorColor),

        //  Enable Borders
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: hintColor,
              width: inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(buttonBorderRadius)),
        disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: hintColor,
              width: inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(buttonBorderRadius)),

        //  Focus Borders
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: mainColor,
              width: inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(buttonBorderRadius)),

        //  Error Border
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: errorColor,
              width: inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(buttonBorderRadius)),

        //  Focus Error Border
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: errorColor,
              width: inputBorderSide,
            ),
            borderRadius: BorderRadius.circular(buttonBorderRadius)),
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: mainColor)
          .copyWith(surface: appBgColor));
}
