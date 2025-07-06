import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Check if the device supports biometrics
  Future<bool> isBiometricAvailable() async {
    if (kIsWeb) {
      return false;
    }
    
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      debugPrint("Error checking biometric availability: $e");
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) {
      return [];
    }
    
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint("Error getting available biometrics: $e");
      return [];
    }
  }

  // Get biometric type description
  String getBiometricTypeDescription(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return "Face ID";
    } else if (types.contains(BiometricType.fingerprint)) {
      return "Fingerprint";
    } else if (types.contains(BiometricType.iris)) {
      return "Iris";
    } else if (types.contains(BiometricType.strong)) {
      return "Biometric";
    } else if (types.contains(BiometricType.weak)) {
      return "Biometric";
    }
    return "Biometric";
  }

  // Authenticate with biometrics
  Future<bool> authenticate({String? customReason}) async {
    debugPrint("Biometric authentication attempt");
    
    try {
      if (kIsWeb) {
        debugPrint("Biometric authentication not supported on web");
        return false;
      }

      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        debugPrint("Biometric authentication not available");
        return false;
      }

      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        debugPrint("No biometric methods available");
        return false;
      }

      final biometricType = getBiometricTypeDescription(availableBiometrics);
      final reason = customReason ?? 'Use $biometricType to authenticate';

      return await _auth.authenticate(
        localizedReason: reason,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            deviceCredentialsRequiredTitle: 'Device credentials required',
            deviceCredentialsSetupDescription: 'Device credentials are required for authentication',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Biometric authentication is not set up on your device',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Biometric authentication is not set up on your device',
            lockOut: 'Biometric authentication is locked out',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      debugPrint("Biometric authentication error: $e");
      return false;
    }
  }

  // Quick login authentication
  Future<bool> authenticateForLogin() async {
    return await authenticate(
      customReason: 'Use biometrics to quickly sign in to your account',
    );
  }

  // Transaction authentication
  Future<bool> authenticateForTransaction({required String amount}) async {
    return await authenticate(
      customReason: 'Confirm transaction of ₦$amount with biometrics',
    );
  }

  // Settings access authentication
  Future<bool> authenticateForSettings() async {
    return await authenticate(
      customReason: 'Use biometrics to access secure settings',
    );
  }
}
