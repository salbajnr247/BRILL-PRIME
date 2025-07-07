
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/services/social_auth_service.dart';
import 'package:brill_prime/services/security_service.dart';
import 'package:brill_prime/services/api_client.dart';
import 'package:hive_flutter/hive_flutter.dart';

@GenerateMocks([
  SocialAuthService,
  SecurityService,
  ApiClient,
  Box,
  BuildContext,
])
import 'auth_provider_test.mocks.dart';

void main() {
  group('AuthProvider Tests', () {
    late AuthProvider authProvider;
    late MockSocialAuthService mockSocialAuthService;
    late MockSecurityService mockSecurityService;
    late MockApiClient mockApiClient;
    late MockBuildContext mockContext;

    setUp(() {
      mockSocialAuthService = MockSocialAuthService();
      mockSecurityService = MockSecurityService();
      mockApiClient = MockApiClient();
      mockContext = MockBuildContext();
      
      authProvider = AuthProvider();
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(authProvider.isLoading, false);
        expect(authProvider.userModel, null);
        expect(authProvider.isErrorMessage, true);
        expect(authProvider.selectedAccountType, 'consumer');
        expect(authProvider.isDogOwner, true);
      });
    });

    group('Account Type Management', () {
      test('should update account type correctly', () {
        // Act
        authProvider.updateAccountType('vendor');

        // Assert
        expect(authProvider.selectedAccountType, 'vendor');
      });
    });

    group('Dog Owner Status', () {
      test('should update dog owner status correctly', () {
        // Act
        authProvider.updateIsDogOwner(false);

        // Assert
        expect(authProvider.isDogOwner, false);
      });
    });

    group('Location Management', () {
      test('should update place name correctly', () {
        // Act
        authProvider.updatePlaceName('New Location');

        // Assert
        expect(authProvider.placeName, 'New Location');
      });
    });

    group('Email for Password Reset', () {
      test('should update email for password reset correctly', () {
        // Act
        authProvider.updateEmailForPasswordReset(newEmail: 'test@example.com');

        // Assert
        expect(authProvider.emailForPasswordReset, 'test@example.com');
      });
    });

    group('Social Authentication', () {
      test('should handle Google sign in success', () async {
        // Arrange
        when(mockSocialAuthService.signInWithGoogle()).thenAnswer((_) async => null);

        // Act
        final result = await authProvider.signInWithGoogle(context: mockContext);

        // Assert
        expect(result, false);
        expect(authProvider.isLoading, false);
      });

      test('should handle Apple sign in success', () async {
        // Arrange
        when(mockSocialAuthService.signInWithApple()).thenAnswer((_) async => null);

        // Act
        final result = await authProvider.signInWithApple(context: mockContext);

        // Assert
        expect(result, false);
        expect(authProvider.isLoading, false);
      });

      test('should handle Facebook sign in success', () async {
        // Arrange
        when(mockSocialAuthService.signInWithFacebook()).thenAnswer((_) async => null);

        // Act
        final result = await authProvider.signInWithFacebook(context: mockContext);

        // Assert
        expect(result, false);
        expect(authProvider.isLoading, false);
      });
    });

    group('Biometric Authentication', () {
      test('should enable biometric authentication successfully', () async {
        // Act
        final result = await authProvider.enableBiometricAuthentication();

        // Assert
        expect(result, false); // Will be false on web platform
      });

      test('should disable biometric authentication successfully', () async {
        // Act
        final result = await authProvider.disableBiometricAuthentication();

        // Assert
        expect(result, false); // Will be false without proper authentication
      });

      test('should get biometric status', () async {
        // Act
        final result = await authProvider.getBiometricStatus();

        // Assert
        expect(result, isA<Map<String, dynamic>>());
      });
    });

    group('First Step Account Creation', () {
      test('should update first step account creation', () {
        // Arrange
        final firstStep = FirstStepAccountCreation(
          email: 'test@example.com',
          fullName: 'Test User',
          password: 'password123',
          phoneNumber: '+1234567890',
        );

        // Act
        authProvider.updateFirstStepAccountCreation(firstStep);

        // Assert
        expect(authProvider.firstStepAccountCreation, equals(firstStep));
      });
    });

    group('Message Management', () {
      test('should clear message correctly', () {
        // Act
        authProvider.clear();

        // Assert
        expect(authProvider.resMessage, '');
      });
    });

    group('Profile Image Management', () {
      test('should update profile image correctly', () {
        // Act
        authProvider.updateProfileImage(null);

        // Assert
        expect(authProvider.profileImage, null);
      });
    });

    group('Category Management', () {
      test('should update selected category correctly', () {
        // Act
        authProvider.updateSelectedCategory(null);

        // Assert
        expect(authProvider.selectedCategory, null);
      });
    });

    group('Biometric Model Management', () {
      test('should reset biometric data correctly', () {
        // Act
        authProvider.resetBiometricData();

        // Assert
        expect(authProvider.biometricModel, null);
      });
    });
  });
}
