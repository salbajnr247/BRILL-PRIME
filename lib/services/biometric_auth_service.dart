import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';

  /// Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      if (kIsWeb) {
        debugPrint('Biometric authentication not supported on web');
        return false;
      }

      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      return isAvailable || isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types on the device
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      if (kIsWeb) return [];
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate using biometric
  Future<bool> authenticate({
    String? customReason,
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      if (kIsWeb) {
        debugPrint('Biometric authentication not supported on web');
        return false;
      }

      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        debugPrint('Biometric authentication not available');
        return false;
      }

      final String reason = customReason ?? 'Please authenticate to access your account';

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: reason,
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Authentication',
            cancelButton: 'Cancel',
            deviceCredentialsRequiredTitle: 'Device credentials required',
            deviceCredentialsSetupDescription: 'Please set up device credentials',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Please set up biometric authentication in Settings',
          ),
          IOSAuthMessages(
            cancelButton: 'Cancel',
            goToSettingsButton: 'Go to Settings',
            goToSettingsDescription: 'Please set up biometric authentication in Settings',
            lockOut: 'Biometric authentication is disabled. Please lock and unlock your screen to enable it.',
          ),
        ],
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false,
        ),
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    } catch (e) {
      debugPrint('Unexpected biometric authentication error: $e');
      return false;
    }
  }

  /// Enable biometric authentication
  Future<bool> enableBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_biometricEnabledKey, true);
    } catch (e) {
      debugPrint('Error enabling biometric: $e');
      return false;
    }
  }

  /// Disable biometric authentication
  Future<bool> disableBiometric() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setBool(_biometricEnabledKey, false);
    } catch (e) {
      debugPrint('Error disabling biometric: $e');
      return false;
    }
  }

  /// Check if biometric authentication is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_biometricEnabledKey) ?? false;
    } catch (e) {
      debugPrint('Error checking biometric enabled status: $e');
      return false;
    }
  }

  /// Get comprehensive biometric status
  Future<Map<String, dynamic>> getBiometricStatus() async {
    try {
      final isAvailable = await isBiometricAvailable();
      final isEnabled = await isBiometricEnabled();
      final availableBiometrics = await getAvailableBiometrics();

      return {
        'isAvailable': isAvailable,
        'isEnabled': isEnabled,
        'availableBiometrics': availableBiometrics.map((e) => e.toString()).toList(),
        'isDeviceSupported': await _localAuth.isDeviceSupported(),
        'canCheckBiometrics': kIsWeb ? false : await _localAuth.canCheckBiometrics,
      };
    } catch (e) {
      debugPrint('Error getting biometric status: $e');
      return {
        'isAvailable': false,
        'isEnabled': false,
        'availableBiometrics': <String>[],
        'isDeviceSupported': false,
        'canCheckBiometrics': false,
        'error': e.toString(),
      };
    }
  }

  /// Authenticate for specific features
  Future<bool> authenticateForFeature(String feature) async {
    final reasons = {
      'login': 'Authenticate to log in to your account',
      'payment': 'Authenticate to confirm payment',
      'settings': 'Authenticate to access security settings',
      'delete_account': 'Authenticate to delete your account',
      'change_password': 'Authenticate to change your password',
    };

    final reason = reasons[feature] ?? 'Please authenticate to continue';
    return await authenticate(customReason: reason);
  }
}