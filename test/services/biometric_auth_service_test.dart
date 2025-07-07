
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:brill_prime/services/biometric_auth_service.dart';

@GenerateMocks([LocalAuthentication])
import 'biometric_auth_service_test.mocks.dart';

void main() {
  group('BiometricAuthService Tests', () {
    late BiometricAuthService biometricAuthService;
    late MockLocalAuthentication mockLocalAuth;

    setUp(() {
      mockLocalAuth = MockLocalAuthentication();
      biometricAuthService = BiometricAuthService();
    });

    group('Biometric Availability', () {
      test('should return true when biometric is available', () async {
        // Arrange
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => true);
        when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => true);

        // Act
        final result = await biometricAuthService.isBiometricAvailable();

        // Assert
        expect(result, isTrue);
      });

      test('should return false when biometric is not available', () async {
        // Arrange
        when(mockLocalAuth.canCheckBiometrics).thenAnswer((_) async => false);
        when(mockLocalAuth.isDeviceSupported()).thenAnswer((_) async => false);

        // Act
        final result = await biometricAuthService.isBiometricAvailable();

        // Assert
        expect(result, isFalse);
      });
    });

    group('Authentication', () {
      test('should return true on successful authentication', () async {
        // Arrange
        when(mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => true);

        // Act
        final result = await biometricAuthService.authenticate();

        // Assert
        expect(result, isTrue);
      });

      test('should return false on failed authentication', () async {
        // Arrange
        when(mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => false);

        // Act
        final result = await biometricAuthService.authenticate();

        // Assert
        expect(result, isFalse);
      });

      test('should handle authentication exception', () async {
        // Arrange
        when(mockLocalAuth.authenticate(
          localizedReason: anyNamed('localizedReason'),
          options: anyNamed('options'),
        )).thenThrow(Exception('Authentication failed'));

        // Act
        final result = await biometricAuthService.authenticate();

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
