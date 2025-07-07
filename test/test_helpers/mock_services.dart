
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:brill_prime/services/social_auth_service.dart';
import 'package:brill_prime/services/biometric_auth_service.dart';
import 'package:brill_prime/services/security_service.dart';
import 'package:brill_prime/services/api_client.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

@GenerateMocks([
  // Firebase & Social Auth
  FirebaseAuth,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  UserCredential,
  User,
  
  // Local Auth & Security
  LocalAuthentication,
  SharedPreferences,
  
  // Services
  SocialAuthService,
  BiometricAuthService,
  SecurityService,
  ApiClient,
  
  // Providers
  AuthProvider,
  
  // Storage
  Box,
  
  // WebSocket
  WebSocketChannel,
  
  // Flutter
  BuildContext,
])
import 'mock_services.mocks.dart';

// Export all mocks for easy access
export 'mock_services.mocks.dart';

class TestHelpers {
  static MockFirebaseAuth createMockFirebaseAuth() {
    return MockFirebaseAuth();
  }
  
  static MockSocialAuthService createMockSocialAuthService() {
    return MockSocialAuthService();
  }
  
  static MockBiometricAuthService createMockBiometricAuthService() {
    return MockBiometricAuthService();
  }
  
  static MockSecurityService createMockSecurityService() {
    return MockSecurityService();
  }
  
  static MockApiClient createMockApiClient() {
    return MockApiClient();
  }
  
  static MockAuthProvider createMockAuthProvider() {
    return MockAuthProvider();
  }
  
  static MockSharedPreferences createMockSharedPreferences() {
    return MockSharedPreferences();
  }
  
  static MockLocalAuthentication createMockLocalAuthentication() {
    return MockLocalAuthentication();
  }
}
