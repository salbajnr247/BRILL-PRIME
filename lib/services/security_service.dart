
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SecurityService {
  static const String _deviceIdKey = 'device_id';
  static const String _sessionTokenKey = 'session_token';
  static const String _lastLoginKey = 'last_login';
  static const String _failedAttemptsKey = 'failed_attempts';
  static const String _lockoutTimeKey = 'lockout_time';
  static const int _maxFailedAttempts = 5;
  static const int _lockoutDurationMinutes = 15;

  // Generate secure device ID
  Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);
      
      if (deviceId == null) {
        deviceId = await _generateDeviceId();
        await prefs.setString(_deviceIdKey, deviceId);
      }
      
      return deviceId;
    } catch (e) {
      debugPrint("Error getting device ID: $e");
      return _generateRandomString(32);
    }
  }

  // Generate device-specific ID
  Future<String> _generateDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      
      String deviceIdentifier = '';
      
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceIdentifier = '${androidInfo.id}_${androidInfo.model}_${androidInfo.manufacturer}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceIdentifier = '${iosInfo.identifierForVendor}_${iosInfo.model}_${iosInfo.systemVersion}';
      } else {
        deviceIdentifier = packageInfo.packageName;
      }
      
      // Hash the device identifier for privacy
      final bytes = utf8.encode(deviceIdentifier + packageInfo.version);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      debugPrint("Error generating device ID: $e");
      return _generateRandomString(32);
    }
  }

  // Generate random string
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  // Generate session token
  Future<String> generateSessionToken() async {
    try {
      final deviceId = await getDeviceId();
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final randomString = _generateRandomString(16);
      
      final tokenData = '$deviceId:$timestamp:$randomString';
      final bytes = utf8.encode(tokenData);
      final digest = sha256.convert(bytes);
      
      final sessionToken = digest.toString();
      
      // Store session token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sessionTokenKey, sessionToken);
      
      return sessionToken;
    } catch (e) {
      debugPrint("Error generating session token: $e");
      return _generateRandomString(64);
    }
  }

  // Validate session token
  Future<bool> validateSessionToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedToken = prefs.getString(_sessionTokenKey);
      return storedToken == token && token.isNotEmpty;
    } catch (e) {
      debugPrint("Error validating session token: $e");
      return false;
    }
  }

  // Clear session
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_lastLoginKey);
    } catch (e) {
      debugPrint("Error clearing session: $e");
    }
  }

  // Record login attempt
  Future<void> recordLoginAttempt(bool success) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (success) {
        // Clear failed attempts on successful login
        await prefs.remove(_failedAttemptsKey);
        await prefs.remove(_lockoutTimeKey);
        await prefs.setInt(_lastLoginKey, DateTime.now().millisecondsSinceEpoch);
      } else {
        // Increment failed attempts
        final failedAttempts = (prefs.getInt(_failedAttemptsKey) ?? 0) + 1;
        await prefs.setInt(_failedAttemptsKey, failedAttempts);
        
        // Set lockout if max attempts reached
        if (failedAttempts >= _maxFailedAttempts) {
          final lockoutTime = DateTime.now().add(
            Duration(minutes: _lockoutDurationMinutes)
          ).millisecondsSinceEpoch;
          await prefs.setInt(_lockoutTimeKey, lockoutTime);
        }
      }
    } catch (e) {
      debugPrint("Error recording login attempt: $e");
    }
  }

  // Check if account is locked
  Future<bool> isAccountLocked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lockoutTime = prefs.getInt(_lockoutTimeKey);
      
      if (lockoutTime == null) return false;
      
      if (DateTime.now().millisecondsSinceEpoch < lockoutTime) {
        return true;
      } else {
        // Lockout period expired, clear lockout
        await prefs.remove(_lockoutTimeKey);
        await prefs.remove(_failedAttemptsKey);
        return false;
      }
    } catch (e) {
      debugPrint("Error checking account lock: $e");
      return false;
    }
  }

  // Get remaining lockout time
  Future<Duration?> getRemainingLockoutTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lockoutTime = prefs.getInt(_lockoutTimeKey);
      
      if (lockoutTime == null) return null;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < lockoutTime) {
        return Duration(milliseconds: lockoutTime - now);
      }
      
      return null;
    } catch (e) {
      debugPrint("Error getting remaining lockout time: $e");
      return null;
    }
  }

  // Get failed attempts count
  Future<int> getFailedAttemptsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_failedAttemptsKey) ?? 0;
    } catch (e) {
      debugPrint("Error getting failed attempts count: $e");
      return 0;
    }
  }

  // Hash password securely
  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate salt
  String generateSalt() {
    return _generateRandomString(32);
  }

  // Validate password strength
  Map<String, dynamic> validatePasswordStrength(String password) {
    final hasMinLength = password.length >= 8;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    final score = [hasMinLength, hasUppercase, hasLowercase, hasDigits, hasSpecialChar]
        .where((criteria) => criteria).length;
    
    String strength;
    if (score < 3) {
      strength = 'Weak';
    } else if (score < 5) {
      strength = 'Medium';
    } else {
      strength = 'Strong';
    }
    
    return {
      'score': score,
      'strength': strength,
      'hasMinLength': hasMinLength,
      'hasUppercase': hasUppercase,
      'hasLowercase': hasLowercase,
      'hasDigits': hasDigits,
      'hasSpecialChar': hasSpecialChar,
    };
  }

  // Encrypt sensitive data
  String encryptData(String data, String key) {
    // Simple XOR encryption (use proper encryption in production)
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final encrypted = <int>[];
    
    for (int i = 0; i < dataBytes.length; i++) {
      encrypted.add(dataBytes[i] ^ keyBytes[i % keyBytes.length]);
    }
    
    return base64.encode(encrypted);
  }

  // Decrypt sensitive data
  String decryptData(String encryptedData, String key) {
    try {
      final keyBytes = utf8.encode(key);
      final encrypted = base64.decode(encryptedData);
      final decrypted = <int>[];
      
      for (int i = 0; i < encrypted.length; i++) {
        decrypted.add(encrypted[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      return utf8.decode(decrypted);
    } catch (e) {
      debugPrint("Error decrypting data: $e");
      return '';
    }
  }
}
