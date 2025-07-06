import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Check if the device supports biometrics
  Future<bool> isBiometricAvailable() async {
    if (kIsWeb) {
      // Biometrics not fully supported on web
      return false;
    }
    return await _auth.canCheckBiometrics;
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) {
      // Web platform doesn't support biometrics fully
      return [];
    }
    return await _auth.getAvailableBiometrics();
  }

  // Authenticate with biometrics

  Future<bool> authenticate() async {
    debugPrint("Biometric attempt=====");
    try {
      if (kIsWeb) {
        // Web platform doesn't support biometric authentication
        debugPrint("Biometric authentication not supported on web");
        return false;
      }
      
      return await _auth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint("Biometric authentication error: $e");
      return false;
    }
  }
}
