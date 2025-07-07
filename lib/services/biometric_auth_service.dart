
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _biometricTokenKey = 'biometric_token';

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

  // Check if biometric is enabled for the app
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      debugPrint("Error checking biometric enabled status: $e");
      return false;
    }
  }

  // Enable biometric authentication
  Future<bool> enableBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setBool(_biometricEnabledKey, true);
      
      // Generate and store a biometric token for additional security
      if (success) {
        final token = DateTime.now().millisecondsSinceEpoch.toString();
        await prefs.setString(_biometricTokenKey, token);
      }
      
      return success;
    } catch (e) {
      debugPrint("Error enabling biometric: $e");
      return false;
    }
  }

  // Disable biometric authentication
  Future<bool> disableBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_biometricTokenKey);
      return await prefs.setBool(_biometricEnabledKey, false);
    } catch (e) {
      debugPrint("Error disabling biometric: $e");
      return false;
    }
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

      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        debugPrint("Biometric authentication not enabled for this app");
        return false;
      }

      final availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        debugPrint("No biometric methods available");
        return false;
      }

      final biometricType = getBiometricTypeDescription(availableBiometrics);
      final reason = customReason ?? 'Use $biometricType to authenticate';

      final result = await _auth.authenticate(
        localizedReason: reason,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            deviceCredentialsRequiredTitle: 'Device credentials required',
            deviceCredentialsSetupDescription: 'Device credentials are required for authentication',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Biometric authentication is not set up on your device',
            biometricHint: 'Touch the fingerprint sensor',
            biometricNotRecognized: 'Biometric not recognized, try again',
            biometricRequiredTitle: 'Biometric authentication required',
            biometricSuccess: 'Biometric authentication successful',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to settings',
            goToSettingsDescription: 'Biometric authentication is not set up on your device',
            lockOut: 'Biometric authentication is locked out',
            localizedFallbackTitle: 'Use Passcode',
          ),
        ],
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (result) {
        // Validate biometric token for additional security
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_biometricTokenKey);
        if (token == null) {
          debugPrint("Biometric token not found, authentication failed");
          return false;
        }
      }

      return result;
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

  // Data access authentication
  Future<bool> authenticateForDataAccess() async {
    return await authenticate(
      customReason: 'Use biometrics to access sensitive data',
    );
  }

  // Get biometric status info
  Future<Map<String, dynamic>> getBiometricStatus() async {
    final isAvailable = await isBiometricAvailable();
    final isEnabled = await isBiometricEnabled();
    final availableTypes = await getAvailableBiometrics();
    
    return {
      'isAvailable': isAvailable,
      'isEnabled': isEnabled,
      'availableTypes': availableTypes.map((e) => e.name).toList(),
      'description': getBiometricTypeDescription(availableTypes),
    };
  }
}
