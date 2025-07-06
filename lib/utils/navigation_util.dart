import 'package:flutter/material.dart';

void navToWithScreenName(
    {required BuildContext context,
    required Widget screen,
    bool isReplacement = false,
    bool isPushAndRemoveUntil = false}) {
  if (isReplacement) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => screen));
  } else if (isPushAndRemoveUntil) {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => screen), (route) => false);
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
}
