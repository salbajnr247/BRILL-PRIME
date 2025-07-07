
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brill_prime/services/security_service.dart';

@GenerateMocks([SharedPreferences])
import 'security_service_test.mocks.dart';

void main() {
  group('SecurityService Tests', () {
    late SecurityService securityService;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      securityService = SecurityService();
    });

    group('Login Attempts', () {
      test('should record successful login attempt', () async {
        // Arrange
        when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);
        when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

        // Act
        await securityService.recordLoginAttempt(true);

        // Assert
        verify(mockSharedPreferences.setInt('failed_login_attempts', 0)).called(1);
      });

      test('should record failed login attempt', () async {
        // Arrange
        when(mockSharedPreferences.getInt('failed_login_attempts')).thenReturn(0);
        when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);

        // Act
        await securityService.recordLoginAttempt(false);

        // Assert
        verify(mockSharedPreferences.setInt('failed_login_attempts', 1)).called(1);
      });
    });

    group('Account Lockout', () {
      test('should return true when account is locked', () async {
        // Arrange
        when(mockSharedPreferences.getInt('failed_login_attempts')).thenReturn(5);
        when(mockSharedPreferences.getString('account_locked_until'))
            .thenReturn(DateTime.now().add(Duration(minutes: 30)).toIso8601String());

        // Act
        final result = await securityService.isAccountLocked();

        // Assert
        expect(result, isTrue);
      });

      test('should return false when account is not locked', () async {
        // Arrange
        when(mockSharedPreferences.getInt('failed_login_attempts')).thenReturn(2);

        // Act
        final result = await securityService.isAccountLocked();

        // Assert
        expect(result, isFalse);
      });

      test('should return false when lockout time has expired', () async {
        // Arrange
        when(mockSharedPreferences.getInt('failed_login_attempts')).thenReturn(5);
        when(mockSharedPreferences.getString('account_locked_until'))
            .thenReturn(DateTime.now().subtract(Duration(minutes: 1)).toIso8601String());

        // Act
        final result = await securityService.isAccountLocked();

        // Assert
        expect(result, isFalse);
      });
    });

    group('Session Management', () {
      test('should generate session token', () async {
        // Arrange
        when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

        // Act
        await securityService.generateSessionToken();

        // Assert
        verify(mockSharedPreferences.setString(contains('session_token'), any)).called(1);
      });

      test('should validate session token', () async {
        // Arrange
        when(mockSharedPreferences.getString('session_token')).thenReturn('valid_token');
        when(mockSharedPreferences.getString('session_expires'))
            .thenReturn(DateTime.now().add(Duration(hours: 1)).toIso8601String());

        // Act
        final result = await securityService.isSessionValid();

        // Assert
        expect(result, isTrue);
      });

      test('should invalidate expired session token', () async {
        // Arrange
        when(mockSharedPreferences.getString('session_token')).thenReturn('valid_token');
        when(mockSharedPreferences.getString('session_expires'))
            .thenReturn(DateTime.now().subtract(Duration(hours: 1)).toIso8601String());

        // Act
        final result = await securityService.isSessionValid();

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
