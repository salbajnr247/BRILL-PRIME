import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authentucate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Oops! Biometric authentication required!',
              cancelButton: 'No thanks',
            ),
            // IOSAuthMessages(
            //   cancelButton: 'No thanks',
            // ),
          ],
          localizedReason: "Use Face Id to authenticate",
          options: const AuthenticationOptions(
              useErrorDialogs: true, stickyAuth: true));
    } catch (e) {
      debugPrint("Local Auth Exception: ${e.toString()}");
      return false;
    }
  }
}
