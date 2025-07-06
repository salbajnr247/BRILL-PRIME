
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

class SocialAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Check if web platform
      if (kIsWeb) {
        // Web-specific Google Sign In
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        
        return await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile/Desktop Google Sign In
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
        if (googleUser == null) {
          // User cancelled the sign-in
          return null;
        }

        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      rethrow;
    }
  }

  // Apple Sign In
  Future<UserCredential?> signInWithApple() async {
    try {
      // Check if Apple Sign In is available
      if (!kIsWeb && !Platform.isIOS && !Platform.isMacOS) {
        debugPrint('Apple Sign In is not available on this platform');
        return null;
      }

      if (!kIsWeb && !await SignInWithApple.isAvailable()) {
        debugPrint('Apple Sign In is not available on this device');
        return null;
      }

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: kIsWeb
            ? WebAuthenticationOptions(
                clientId: 'com.brill.prime.service',
                redirectUri: Uri.parse(
                  'https://brill-prime-app-ef084.firebaseapp.com/__/auth/handler',
                ),
              )
            : null,
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      debugPrint('Apple Sign In Error: $e');
      rethrow;
    }
  }

  // Facebook Sign In
  Future<UserCredential?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential = 
            FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

        // Once signed in, return the UserCredential
        return await _auth.signInWithCredential(facebookAuthCredential);
      } else if (loginResult.status == LoginStatus.cancelled) {
        debugPrint('Facebook Sign In cancelled by user');
        return null;
      } else {
        debugPrint('Facebook Sign In failed: ${loginResult.status}');
        throw Exception('Facebook Sign In failed: ${loginResult.message}');
      }
    } catch (e) {
      debugPrint('Facebook Sign In Error: $e');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Get user info for backend
  Map<String, dynamic>? getUserInfoForBackend() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'providerId': user.providerData.isNotEmpty ? user.providerData.first.providerId : null,
    };
  }
}
