import 'dart:io';

import 'package:flutter/material.dart';

Future<bool> connectionChecker() async {
  debugPrint("Connection checker called");
  try {
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      debugPrint("Check connection result: $result}");
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}
