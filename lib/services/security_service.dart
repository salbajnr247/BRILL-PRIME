
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class SecurityService {
  static const String _failedLoginAttemptsKey = 'failed_login_attempts';
  static const String _accountLockedUntilKey = 'account_locked_until';
  static const String _sessionTokenKey = 'session_token';
  static const String _sessionExpiresKey = 'session_expires';
  static const String _lastLoginKey = 'last_login';
  
  static const int maxFailedAttempts = 5;
  static const int lockoutDurationMinutes = 30;
  static const int sessionDurationHours = 24;

  /// Record a login attempt (successful or failed)
  Future<void> recordLoginAttempt(bool successful) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (successful) {
        // Reset failed attempts on successful login
        await prefs.setInt(_failedLoginAttemptsKey, 0);
        await prefs.remove(_accountLockedUntilKey);
        await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
      } else {
        // Increment failed attempts
        final currentAttempts = prefs.getInt(_failedLoginAttemptsKey) ?? 0;
        final newAttempts = currentAttempts + 1;
        await prefs.setInt(_failedLoginAttemptsKey, newAttempts);
        
        // Lock account if max attempts reached
        if (newAttempts >= maxFailedAttempts) {
          final lockUntil = DateTime.now().add(Duration(minutes: lockoutDurationMinutes));
          await prefs.setString(_accountLockedUntilKey, lockUntil.toIso8601String());
        }
      }
    } catch (e) {
      debugPrint('Error recording login attempt: $e');
    }
  }

  /// Check if account is currently locked
  Future<bool> isAccountLocked() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final failedAttempts = prefs.getInt(_failedLoginAttemptsKey) ?? 0;
      
      if (failedAttempts < maxFailedAttempts) {
        return false;
      }
      
      final lockedUntilString = prefs.getString(_accountLockedUntilKey);
      if (lockedUntilString == null) {
        return false;
      }
      
      final lockedUntil = DateTime.parse(lockedUntilString);
      final now = DateTime.now();
      
      if (now.isAfter(lockedUntil)) {
        // Lock period has expired, reset failed attempts
        await prefs.setInt(_failedLoginAttemptsKey, 0);
        await prefs.remove(_accountLockedUntilKey);
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('Error checking account lock status: $e');
      return false;
    }
  }

  /// Get remaining lockout time
  Future<Duration?> getRemainingLockoutTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lockedUntilString = prefs.getString(_accountLockedUntilKey);
      
      if (lockedUntilString == null) {
        return null;
      }
      
      final lockedUntil = DateTime.parse(lockedUntilString);
      final now = DateTime.now();
      
      if (now.isAfter(lockedUntil)) {
        return null;
      }
      
      return lockedUntil.difference(now);
    } catch (e) {
      debugPrint('Error getting remaining lockout time: $e');
      return null;
    }
  }

  /// Generate a session token
  Future<String> generateSessionToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Generate random token
      final random = Random.secure();
      final tokenBytes = List<int>.generate(32, (i) => random.nextInt(256));
      final token = base64Url.encode(tokenBytes);
      
      // Set expiration time
      final expiresAt = DateTime.now().add(Duration(hours: sessionDurationHours));
      
      // Store token and expiration
      await prefs.setString(_sessionTokenKey, token);
      await prefs.setString(_sessionExpiresKey, expiresAt.toIso8601String());
      
      return token;
    } catch (e) {
      debugPrint('Error generating session token: $e');
      rethrow;
    }
  }

  /// Validate current session
  Future<bool> isSessionValid() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_sessionTokenKey);
      final expiresString = prefs.getString(_sessionExpiresKey);
      
      if (token == null || expiresString == null) {
        return false;
      }
      
      final expiresAt = DateTime.parse(expiresString);
      final now = DateTime.now();
      
      if (now.isAfter(expiresAt)) {
        // Session expired, clean up
        await invalidateSession();
        return false;
      }
      
      return true;
    } catch (e) {
      debugPrint('Error validating session: $e');
      return false;
    }
  }

  /// Get current session token
  Future<String?> getSessionToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_sessionTokenKey);
    } catch (e) {
      debugPrint('Error getting session token: $e');
      return null;
    }
  }

  /// Invalidate current session
  Future<void> invalidateSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_sessionExpiresKey);
    } catch (e) {
      debugPrint('Error invalidating session: $e');
    }
  }

  /// Hash password securely
  String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate salt for password hashing
  String generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  /// Validate password strength
  Map<String, dynamic> validatePasswordStrength(String password) {
    final validations = {
      'minLength': password.length >= 8,
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasLowercase': password.contains(RegExp(r'[a-z]')),
      'hasNumbers': password.contains(RegExp(r'[0-9]')),
      'hasSpecialChars': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };

    final score = validations.values.where((v) => v).length;
    final isStrong = score >= 4;

    return {
      'isValid': isStrong,
      'score': score,
      'validations': validations,
      'suggestions': _getPasswordSuggestions(validations),
    };
  }

  List<String> _getPasswordSuggestions(Map<String, bool> validations) {
    final suggestions = <String>[];
    
    if (!validations['minLength']!) {
      suggestions.add('Use at least 8 characters');
    }
    if (!validations['hasUppercase']!) {
      suggestions.add('Include uppercase letters');
    }
    if (!validations['hasLowercase']!) {
      suggestions.add('Include lowercase letters');
    }
    if (!validations['hasNumbers']!) {
      suggestions.add('Include numbers');
    }
    if (!validations['hasSpecialChars']!) {
      suggestions.add('Include special characters');
    }

    return suggestions;
  }

  /// Get security metrics
  Future<Map<String, dynamic>> getSecurityMetrics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final failedAttempts = prefs.getInt(_failedLoginAttemptsKey) ?? 0;
      final lastLogin = prefs.getString(_lastLoginKey);
      final isLocked = await isAccountLocked();
      final sessionValid = await isSessionValid();

      return {
        'failedLoginAttempts': failedAttempts,
        'isAccountLocked': isLocked,
        'lastLogin': lastLogin,
        'sessionValid': sessionValid,
        'lockoutTime': await getRemainingLockoutTime(),
      };
    } catch (e) {
      debugPrint('Error getting security metrics: $e');
      return {};
    }
  }

  /// Clear all security data (for logout)
  Future<void> clearSecurityData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_failedLoginAttemptsKey);
      await prefs.remove(_accountLockedUntilKey);
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_sessionExpiresKey);
    } catch (e) {
      debugPrint('Error clearing security data: $e');
    }
  }
}
