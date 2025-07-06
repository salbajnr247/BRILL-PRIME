import 'dart:convert';
import 'dart:io';
import 'package:brill_prime/models/category_model.dart';
import 'package:brill_prime/models/opening_hours_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/first_step_account_creation.dart';
import '../models/hive_models/biometric_detail_model.dart';
import '../models/hive_models/hive_user_model.dart';

import '../models/password_reset_model.dart';
import '../models/user_model.dart';
import '../models/user_profile_model.dart';
import '../resources/constants/connectivity.dart';
import '../resources/constants/endpoints.dart';
import '../resources/constants/string_constants.dart';
import '../services/api_client.dart';
import '../services/biometric_auth_service.dart';
import '../services/social_auth_service.dart';
import '../ui/confirm_email/confirm_email_screen.dart';
import '../utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/navigation_util.dart';

class AuthProvider extends ChangeNotifier {
  bool isError = true;
  final SocialAuthService _socialAuthService = SocialAuthService();

  String selectedAccountType = consumer;
  void updateAccountType(String accountType) {
    selectedAccountType = accountType;
    notifyListeners();
  }

  bool isErrorMessage = true;

  bool _isDogOwner = true;
  bool get isDogOwner => _isDogOwner;

  void updateIsDogOwner(bool newValue) {
    _isDogOwner = newValue;
    notifyListeners();
  }

  Future<Position> getCurrentLocation({bool getPlaceName = false}) async {
    debugPrint("Get Current Location Method called:::::::::::::");
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied. Cannot request permissions.");
    }

    return await Geolocator.getCurrentPosition();
  }

  LatLng? userCurrentLocation = const LatLng(9.072264, 7.491302);
  Future<bool> updateUserCurrentLocation(
      {bool getPlaceNameAfter = false}) async {
    bool currentLocationFetched = false;

    Position? position = await getCurrentLocation();

    userCurrentLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();

    if (userCurrentLocation != null) {
      debugPrint(
          "The current User Longitude is:::: ${userCurrentLocation?.longitude}");
      currentLocationFetched = true;
      if (getPlaceNameAfter) {
        getPlaceName(
            latitude: userCurrentLocation?.latitude ?? 0,
            longitude: userCurrentLocation?.longitude ?? 0);
      }
    }
    notifyListeners();
    return currentLocationFetched;
  }

  String placeName = "...";

  void updatePlaceName(String name) {
    placeName = name;
    notifyListeners();
  }

  bool gettingPlaceName = false;
  Future<void> getPlaceName({double latitude = 0, double longitude = 0}) async {
    gettingPlaceName = true;
    notifyListeners();
    try {
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        placeName =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      } else {
        placeName = "";
      }
    } catch (e) {
      debugPrint("Error in reverse geocoding: $e");
      placeName = "";
    }
    gettingPlaceName = false;
    notifyListeners();
  }

  //CHECK IF USER DETAIL IS SAVED IN HIVE
  Future<bool> updateUserData(BuildContext context) async {
    debugPrint("Checking user data::::::::::::::::::");
    bool hasUserInfo = false;
    if (Hive.box<HiveUserModel>(userBox).isNotEmpty) {
      _hiveUserData = Hive.box<HiveUserModel>(userBox).getAt(0);

      if (_hiveUserData != null) {
        final bool profileFetched = await getProfile(context: context);
        if (profileFetched) {
          hasUserInfo = true;
        }
      }
    } else {
      debugPrint("No user data saved on this app");
    }
    return hasUserInfo;
  }

  //CHECK IF USER BIOMETRIC INFO
  Future<bool> getBiometricCredentials(BuildContext context) async {
    debugPrint("Checking getBiometricCredentials::::::::::::::::::");
    biometricModel = null;
    bool hasSavedCredentials = false;
    if (Hive.box<HiveBiometricModel>(biometricBox).isNotEmpty) {
      biometricModel = Hive.box<HiveBiometricModel>(biometricBox).getAt(0);
      if (biometricModel != null) {
        hasSavedCredentials = true;
      }
    } else {
      debugPrint("User doesn't have saved credentials ");
    }
    return hasSavedCredentials;
  }

  bool uploadingProfileImage = false;
  File? profileImage;
  void updateProfileImage(File? file) {
    profileImage = file;
    notifyListeners();
  }

  String fcmToken = "";
  // void getFirebaseFCMToken() async {
  //   try {
  //     final token = await FirebaseMessaging.instance.getToken();
  //     fcmToken = token ?? "";
  //     notifyListeners();
  //     debugPrint("FCM TOKEN::: $fcmToken");
  //   } catch (error) {
  //     debugPrint("Error getting FCM Token::: ${error.toString()}");
  //   }
  // }

  Future<bool> uploadProfileImage({required BuildContext context}) async {
    var networkStatus = await connectionChecker();
    bool infoSent = false;
    notifyListeners();
    const url = "$basedURL/settings/media/uploads";

    if (networkStatus) {
      uploadingProfileImage = true;
      notifyListeners();

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(url),
        );

        request.headers.addAll(headerWithTokenAndFormDataMapFunc());
        request.fields['for'] = _userProfile?.data.role ?? "";
        request.fields['lookUp'] = _userProfile?.data.id ?? "";
        request.fields['type'] = "profileImage";

        if (profileImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            profileImage!.path,
            contentType: MediaType(
                'application', 'jpg'), // Adjust the media type as needed
          ));
        } else {
          debugPrint("No Profile image============");
        }

        var response = await request.send();
        uploadingProfileImage = false;
        debugPrint("The status CODE ===== ${response.statusCode}");
        if (response.statusCode == 200 && context.mounted) {
          infoSent = true;
          notifyListeners();
        } else if (response.statusCode == 401 && context.mounted) {
          response.stream.transform(utf8.decoder).listen((value) {
            _resMessage = "${json.decode(value)['message']}";
            debugPrint("Add Clinic RESPONSE BODY::::$value");
            debugPrint("The status CODE ===== ${response.statusCode}");
            if (context.mounted) {
              getProfile(context: context);
            }
            notifyListeners();
          });
          notifyListeners();
        } else {
          response.stream.transform(utf8.decoder).listen((value) {
            _resMessage =
                "${json.decode(value)['message'] ?? 'Something went wrong'}";
            debugPrint("Upload Profile Image RESPONSE BODY::::$value");
            debugPrint("The status CODE ===== ${response.statusCode}");
            uploadingProfileImage = false;
          });
        }
      } catch (error) {
        debugPrint("Error Adding Product ${error.toString()}");
      }
    } else {}

    uploadingProfileImage = false;
    notifyListeners();

    return infoSent;
  }

  FirstStepAccountCreation? _firstStepAccountCreation;
  FirstStepAccountCreation? get firstStepAccountCreation =>
      _firstStepAccountCreation;

  void updateFirstStepAccountCreation(
      FirstStepAccountCreation? firstStepAccountCreation) {
    _firstStepAccountCreation = firstStepAccountCreation;
    notifyListeners();
  }

  String _resMessage = "";
  String get resMessage => _resMessage;
  void clear() {
    _resMessage = "";
    notifyListeners();
  }

  String _emailForPasswordReset = "";
  String get emailForPasswordReset => _emailForPasswordReset;

  void updateEmailForPasswordReset({String newEmail = ""}) {
    _emailForPasswordReset = newEmail;
    notifyListeners();
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  HiveUserModel? _hiveUserData;
  HiveUserModel? get hiveUserData => _hiveUserData;

  HiveBiometricModel? biometricModel;

  void resetBiometricData() {
    biometricModel = null;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  // Login User
  HiveBiometricModel? hiveBiometricModel;
  Future<bool> loginUser({
    required String email,
    required String password,
    required BuildContext context,
    bool isBiometric = false,
  }) async {
    /// Clear previous user info
    await clearHiveData();
    hiveBiometricModel = null;

    bool isLoggedIn = false;
    final connected = await connectionChecker();

    String url = loginEndpoint;
    if (context.mounted && connected) {
      _isLoading = true;
      notifyListeners();
      final body = {
        "email": email.toLowerCase(),
        "password": password,
        "role": selectedAccountType.toUpperCase()
      };

      try {
        debugPrint("The Login Payload is: $body");
        (bool, String) loginRequest = await ApiClient().postRequest(url,
            context: context,
            body: body,
            printResponseBody: true,
            requestName: "Login");

        if (loginRequest.$1) {
          ///The user is logged in
          ///
          ///
          // Update Firebase token
          // updateFirebaseFCMToken(context: context);
          isLoggedIn = true;
          _isLoading = false;
          _userModel = userModelFromJson(loginRequest.$2);

          HiveUserModel hiveUserModel = HiveUserModel(
              userId: "",
              fullName: "",
              email: "",
              token: _userModel?.data.accessToken,
              phoneNumber: "",
              userName: "",
              address: "",
              vcn: "",
              role: "");
          _hiveUserData = hiveUserModel;

          Hive.box<HiveUserModel>(userBox)
              .put(hiveUserModel.userId, hiveUserModel);

          // Prepare BioMetric login
          // hiveBiometricModel =
          //     HiveBiometricModel(email: email, password: password);
          //GET USER PROFILE
          // if (context.mounted) {
          if (context.mounted) {
            await getProfile(context: context);
          }
          // }

          isLoggedIn = true;
          _isLoading = false;
          notifyListeners();
        } else if (loginRequest.$2 == "Email must be verified") {
          _resMessage = loginRequest.$2;
          _isLoading = false;
          _emailForPasswordReset = email;
          notifyListeners();
          if (context.mounted) {
            requestOTP(email: email, context: context);
            navToWithScreenName(
                context: context, screen: const ConfirmEmailScreen());
          }
        } else {
          _resMessage = loginRequest.$2;
          _isLoading = false;
          notifyListeners();
        }
      } catch (error) {
        _isLoading = false;

        _resMessage = "Error loging in";
        notifyListeners();
        debugPrint("Caught Login Error ${error.toString()}");
      }
    } else {
      _resMessage = "Internet connection is not available";
      _isLoading = false;
      notifyListeners();
    }
    return isLoggedIn;
  }

  Future<bool> biometricLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    /// Clear previous user info
    await clearHiveData();
    hiveBiometricModel = null;

    bool isLoggedIn = false;
    final connected = await connectionChecker();

    String url = loginEndpoint;
    if (context.mounted && connected) {
      _isLoading = true;
      notifyListeners();
      final body = {"email": email, "password": password, "type": "password"};

      debugPrint("The response body is: $body");

      (bool, String) loginRequest = await ApiClient().postRequest(url,
          context: context,
          body: body,
          printResponseBody: false,
          requestName: "biometricLogin");

      if (loginRequest.$1) {
        ///The user is logged in
        ///
        ///
        // Update Firebase token
        if (context.mounted) {
          updateFirebaseFCMToken(context: context);
        }
        isLoggedIn = true;
        _isLoading = false;
        _userModel = userModelFromJson(loginRequest.$2);

        HiveUserModel hiveUserModel = HiveUserModel(
            userId: "",
            fullName: "",
            email: "",
            token: _userModel?.data.accessToken ?? "",
            phoneNumber: "",
            userName: "",
            address: "",
            vcn: "",
            role: "");
        _hiveUserData = hiveUserModel;

        Hive.box<HiveUserModel>(userBox)
            .put(hiveUserModel.userId, hiveUserModel);

        // Prepare BioMetric login
        hiveBiometricModel =
            HiveBiometricModel(email: email, password: password);
        //GET USER PROFILE
        if (context.mounted) {
          getProfile(context: context);
        }

        isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
      } else if (loginRequest.$2 == "Email must be verified") {
        _resMessage = loginRequest.$2;
        _isLoading = false;
        _emailForPasswordReset = email;
        notifyListeners();
        if (context.mounted) {
          requestOTP(email: email, context: context);
          navToWithScreenName(
              context: context, screen: const ConfirmEmailScreen());
        }
      } else {
        _resMessage = loginRequest.$2;
        _isLoading = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _isLoading = false;
      notifyListeners();
    }
    return isLoggedIn;
  }

  Future<bool> enableBiometricAuthentication() async {
    // Check if running on web platform
    if (kIsWeb) {
      debugPrint("Biometric authentication not supported on web platform");
      return false;
    }

    BiometricAuthService biometricAuthService = BiometricAuthService();
    bool enabled = false;
    bool isAuthenticated = await biometricAuthService.authenticate();
    if (isAuthenticated) {
      //   User authenticated using biometrics
      //   Save credentials

      if (hiveBiometricModel != null) {
        Hive.box<HiveBiometricModel>(biometricBox)
            .put(hiveBiometricModel?.email, hiveBiometricModel!);
        enabled = true;
      }
    }

    return enabled;
  }

  // Google Sign In
  Future<bool> signInWithGoogle({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserCredential? userCredential = await _socialAuthService.signInWithGoogle();
      
      if (userCredential != null) {
        final User? user = userCredential.user;
        if (user != null) {
          // Create user account or login with backend
          bool success = await _handleSocialLogin(
            context: context,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
            provider: 'google',
            socialId: user.uid,
            photoUrl: user.photoURL,
          );
          
          _isLoading = false;
          notifyListeners();
          return success;
        }
      }
    } catch (e) {
      _resMessage = 'Google sign in failed. Please try again.';
      debugPrint('Google Sign In Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Apple Sign In
  Future<bool> signInWithApple({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserCredential? userCredential = await _socialAuthService.signInWithApple();
      
      if (userCredential != null) {
        final User? user = userCredential.user;
        if (user != null) {
          // Create user account or login with backend
          bool success = await _handleSocialLogin(
            context: context,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
            provider: 'apple',
            socialId: user.uid,
            photoUrl: user.photoURL,
          );
          
          _isLoading = false;
          notifyListeners();
          return success;
        }
      }
    } catch (e) {
      _resMessage = 'Apple sign in failed. Please try again.';
      debugPrint('Apple Sign In Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Facebook Sign In
  Future<bool> signInWithFacebook({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserCredential? userCredential = await _socialAuthService.signInWithFacebook();
      
      if (userCredential != null) {
        final User? user = userCredential.user;
        if (user != null) {
          // Create user account or login with backend
          bool success = await _handleSocialLogin(
            context: context,
            email: user.email ?? '',
            fullName: user.displayName ?? '',
            provider: 'facebook',
            socialId: user.uid,
            photoUrl: user.photoURL,
          );
          
          _isLoading = false;
          notifyListeners();
          return success;
        }
      }
    } catch (e) {
      _resMessage = 'Facebook sign in failed. Please try again.';
      debugPrint('Facebook Sign In Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Handle social login with backend
  Future<bool> _handleSocialLogin({
    required BuildContext context,
    required String email,
    required String fullName,
    required String provider,
    required String socialId,
    String? photoUrl,
  }) async {
    final connected = await connectionChecker();
    
    if (!connected) {
      _resMessage = "Internet connection is not available";
      return false;
    }

    try {
      // First try to login with social credentials
      final body = {
        "email": email.toLowerCase(),
        "provider": provider,
        "social_id": socialId,
        "role": selectedAccountType.toUpperCase(),
        "photo_url": photoUrl,
      };

      debugPrint("Social login payload: $body");

      (bool, String) loginRequest = await ApiClient().postRequest(
        "auth/social-login",
        context: context,
        body: body,
        printResponseBody: true,
        requestName: "Social Login"
      );

      if (loginRequest.$1) {
        // Login successful
        _userModel = userModelFromJson(loginRequest.$2);
        
        HiveUserModel hiveUserModel = HiveUserModel(
          userId: socialId,
          fullName: fullName,
          email: email,
          token: _userModel?.data.accessToken ?? "",
          phoneNumber: "",
          userName: "",
          address: "",
          vcn: "",
          role: selectedAccountType
        );
        
        _hiveUserData = hiveUserModel;
        Hive.box<HiveUserModel>(userBox).put(hiveUserModel.userId, hiveUserModel);
        
        // Get user profile
        if (context.mounted) {
          await getProfile(context: context);
        }
        
        return true;
      } else {
        // If login fails, try to register the user
        return await _registerSocialUser(
          context: context,
          email: email,
          fullName: fullName,
          provider: provider,
          socialId: socialId,
        );
      }
    } catch (e) {
      _resMessage = "Social login failed: ${e.toString()}";
      debugPrint("Social login error: $e");
      return false;
    }
  }

  // Register user from social login
  Future<bool> _registerSocialUser({
    required BuildContext context,
    required String email,
    required String fullName,
    required String provider,
    required String socialId,
  }) async {
    try {
      final body = {
        "email": email.toLowerCase(),
        "fullName": fullName,
        "provider": provider,
        "social_id": socialId,
        "role": selectedAccountType.toUpperCase(),
        "phone": "", // Can be updated later
        "photo_url": photoUrl,
      };

      debugPrint("Social registration payload: $body");

      (bool, String) registerRequest = await ApiClient().postRequest(
        "auth/social-register",
        context: context,
        body: body,
        printResponseBody: true,
        requestName: "Social Registration"
      );

      if (registerRequest.$1) {
        _userModel = userModelFromJson(registerRequest.$2);
        
        HiveUserModel hiveUserModel = HiveUserModel(
          userId: socialId,
          fullName: fullName,
          email: email,
          token: _userModel?.data.accessToken ?? "",
          phoneNumber: "",
          userName: "",
          address: "",
          vcn: "",
          role: selectedAccountType
        );
        
        _hiveUserData = hiveUserModel;
        Hive.box<HiveUserModel>(userBox).put(hiveUserModel.userId, hiveUserModel);
        
        // Get user profile
        if (context.mounted) {
          await getProfile(context: context);
        }
        
        return true;
      } else {
        _resMessage = registerRequest.$2;
        return false;
      }
    } catch (e) {
      _resMessage = "Social registration failed: ${e.toString()}";
      debugPrint("Social registration error: $e");
      return false;
    }
  }

  bool _verifyingOTP = false;
  bool get isVerifyingOTP => _verifyingOTP;
  Future<bool> verifyOTP(
      {required String otp,
      required BuildContext context,
      String verificationOption = "verification"}) async {
    bool isVerified = false;
    final connected = await connectionChecker();
    String url = verifyOtpEndpoint;
    if (context.mounted && connected) {
      _verifyingOTP = true;
      notifyListeners();
      final body = {
        "email": _firstStepAccountCreation?.email ?? "",
        "otp": otp
      };
      debugPrint("Email verification payload:::::: $body");
      (bool, String) verifyOTPRequest = await ApiClient().postRequest(url,
          context: context,
          body: body,
          printResponseBody: false,
          requestName: "Verify OTP");

      if (verifyOTPRequest.$1) {
        isVerified = true;
        _verifyingOTP = false;
        isVerified = true;
        notifyListeners();
      } else {
        _resMessage = verifyOTPRequest.$2;
        _verifyingOTP = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _verifyingOTP = false;
      notifyListeners();
    }
    return isVerified;
  }

  PasswordResetModel? passwordResetModel;
  Future<bool> verifyOTPForPasswordReset(
      {required String otp,
      required BuildContext context,
      required String email}) async {
    bool isVerified = false;
    final connected = await connectionChecker();
    String url = "auth/verify-password-reset";
    if (context.mounted && connected) {
      _verifyingOTP = true;
      notifyListeners();
      final body = {"email": email.toLowerCase(), "otp": otp};
      debugPrint("verifyPassword payload:::::: $body");
      (bool, String) verifyOTPRequest = await ApiClient().postRequest(url,
          context: context,
          body: body,
          printResponseBody: false,
          requestName: "verifyPassword");
      clearHiveData();
      if (verifyOTPRequest.$1) {
        passwordResetModel = passwordResetModelFromJson(verifyOTPRequest.$2);
        isVerified = true;
        _verifyingOTP = false;
        isVerified = true;

        HiveUserModel hiveUserModel = HiveUserModel(
            userId: "tempUserId",
            fullName: "",
            email: "",
            token: passwordResetModel?.data.accessToken,
            phoneNumber: "",
            userName: "",
            address: "",
            vcn: "",
            role: "");
        _hiveUserData = hiveUserModel;

        Hive.box<HiveUserModel>(userBox)
            .put(hiveUserModel.userId, hiveUserModel);
        notifyListeners();
      } else {
        _resMessage = verifyOTPRequest.$2;
        _verifyingOTP = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _verifyingOTP = false;
      notifyListeners();
    }
    return isVerified;
  }

  bool deletingAccount = false;
  Future<bool> deleteAccount({required BuildContext context}) async {
    bool isSuccessful = false;
    final connected = await connectionChecker();
    String url = "settings/delete/account/${_userProfile?.data.id}";
    debugPrint("delete Account URL:: $url");
    if (context.mounted && connected) {
      deletingAccount = true;
      notifyListeners();
      (bool, String) request = await ApiClient().deleteRequest(url,
          context: context,
          printResponseBody: true,
          requestName: "deleteAccount");
      if (request.$1) {
        isSuccessful = true;
        deletingAccount = false;
        isSuccessful = true;
        notifyListeners();
      } else {
        _resMessage = request.$2;
        deletingAccount = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      deletingAccount = false;
      notifyListeners();
    }
    return isSuccessful;
  }

  Future<bool> updateFirebaseFCMToken({
    required BuildContext context,
  }) async {
    bool updated = false;
    final connected = await connectionChecker();
    if (context.mounted && connected) {
      final body = {"token": fcmToken};
      debugPrint("Payload is:::: $body");
      (bool, String) requestResponse = await ApiClient().putRequest(
          "settings/add/fmc/token",
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "updateFirebaseFCMToken");

      if (requestResponse.$1) {
        updated = true;
        notifyListeners();
      } else {
        debugPrint("Could not update FCM Token");
      }
    } else {
      _resMessage = "Internet connection is not available";
      notifyListeners();
    }
    return updated;
  }

  bool _resettingPassword = false;
  bool get resettingPassword => _resettingPassword;
  Future<bool> resetPassword(
      {required BuildContext context, required String newPassword}) async {
    bool isVerified = false;
    final connected = await connectionChecker();
    String url = resetPasswordEndpoint;
    if (context.mounted && connected) {
      _resettingPassword = true;
      notifyListeners();
      final body = {
        "password": newPassword,
      };
      debugPrint("resetPassword Payload::: $body Access token");
      (bool, String) resetPasswordRequest = await ApiClient().postRequest(url,
          context: context,
          body: body,
          sentToken: passwordResetModel?.data.accessToken ?? "",
          printResponseBody: false,
          requestName: "Change Password");
      if (resetPasswordRequest.$1) {
        isVerified = true;
        _resettingPassword = false;
        isVerified = true;

        notifyListeners();
      } else {
        _resMessage = resetPasswordRequest.$2;
        _resettingPassword = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _resettingPassword = false;
      notifyListeners();
    }
    return isVerified;
  }

  bool _requestingForgotPassword = false;
  bool get requestingForgotPassword => _requestingForgotPassword;
  Future<bool> forgotPassword({
    required BuildContext context,
  }) async {
    bool requestSent = false;
    final connected = await connectionChecker();
    String url = forgotPasswordEndpoint;
    if (context.mounted && connected) {
      _requestingForgotPassword = true;
      notifyListeners();
      final body = {
        "email": _emailForPasswordReset.toLowerCase(),
      };
      debugPrint("Forgot password payload is:::: $body");
      (bool, String) verifyOTPRequest = await ApiClient().postRequest(url,
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "Forgot Password");

      if (verifyOTPRequest.$1) {
        requestSent = true;
        _requestingForgotPassword = false;
        requestSent = true;
        notifyListeners();
      } else {
        _resMessage = verifyOTPRequest.$2;
        _requestingForgotPassword = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _requestingForgotPassword = false;
      notifyListeners();
    }
    return requestSent;
  }

  bool _requestingOTP = false;
  bool get requestingOTP => _requestingOTP;
  Future<bool> requestOTP({
    required String email,
    required BuildContext context,
  }) async {
    bool isVerified = false;
    final connected = await connectionChecker();
    String url = resendOtpEndpoint;
    if (context.mounted && connected) {
      _requestingOTP = true;
      notifyListeners();
      final body = {"email": email.toLowerCase(), "purpose": "verification"};
      debugPrint("Request OTP Payload::: $body");
      (bool, String) verifyOTPRequest = await ApiClient().postRequest(url,
          context: context,
          body: body,
          printResponseBody: false,
          requestName: "Request OTP");

      if (verifyOTPRequest.$1) {
        isVerified = true;
        _requestingOTP = false;
        _resMessage = "Verification code sent";
        isVerified = true;
        notifyListeners();
      } else {
        _resMessage = verifyOTPRequest.$2;
        _requestingOTP = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _requestingOTP = false;
      notifyListeners();
    }
    return isVerified;
  }

  //REGISTER USER
  Future<bool> registerUser({
    required BuildContext context,
  }) async {
    bool isRegistered = false;
    final connected = await connectionChecker();

    if (context.mounted && connected) {
      _isLoading = true;
      notifyListeners();

      final body = {
        "email": _firstStepAccountCreation?.email ?? "",
        "fullName": _firstStepAccountCreation?.fullName ?? "",
        "password": _firstStepAccountCreation?.password ?? "",
        "phone": _firstStepAccountCreation?.phoneNumber ?? "",
        "role": selectedAccountType.toUpperCase()
      };

      debugPrint("Payload::::$body");

      (bool, String) registerUserRequest = await ApiClient().postRequest(
          signUpEndpoint,
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "Registration");
      if (registerUserRequest.$1) {
        ///The user is logged in
        isRegistered = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _resMessage = registerUserRequest.$2;
        _isLoading = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _isLoading = false;
      notifyListeners();
    }
    return isRegistered;
  }

  bool updatingUserProfile = false;
  Future<bool> updateUserProfile({
    required BuildContext context,
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required String imageURL,
  }) async {
    bool updated = false;
    final connected = await connectionChecker();

    if (context.mounted && connected) {
      updatingUserProfile = true;
      notifyListeners();

      final body = {
        "email": email,
        "fullName": fullName,
        "location": location,
        "phone": phone,
        "imageUrl": imageURL
      };

      debugPrint("Update user profile payload::::$body");

      try {
        // RESTful: PATCH /users/me
        (bool, String) request = await ApiClient().patchRequest(
            "users/me",
            context: context,
            body: body,
            printResponseBody: true,
            requestName: "updateUserProfile");
        updatingUserProfile = false;
        notifyListeners();
        if (request.$1) {
          updated = true;
          updatingUserProfile = false;
          _resMessage = "Profile updated successfully";
          notifyListeners();
        } else {
          _resMessage = request.$2;
          updatingUserProfile = false;
          notifyListeners();
        }
      } catch (error) {
        updatingUserProfile = false;
        _resMessage = error.toString();
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      updatingUserProfile = false;
      notifyListeners();
    }
    return updated;
  }

  //Change Password
  bool _changingPassword = false;
  bool get changingPassword => _changingPassword;
  Future<bool> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
  }) async {
    bool passwordChanged = false;
    final connected = await connectionChecker();
    String url = "users/me/password";
    if (context.mounted && connected) {
      _changingPassword = true;
      notifyListeners();
      final body = {
        "old_password": oldPassword,
        "password": newPassword,
        "password_confirmation": newPassword
      };
      // RESTful: PATCH /users/me/password
      (bool, String) changePasswordRequest = await ApiClient().patchRequest(url,
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "Change Password");
      _changingPassword = false;
      if (changePasswordRequest.$1) {
        passwordChanged = true;
        notifyListeners();
      } else {
        _resMessage = changePasswordRequest.$2;
        _changingPassword = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _changingPassword = false;
      notifyListeners();
    }
    return passwordChanged;
  }

  bool changingPIN = false;
  Future<bool> changePIN({
    required BuildContext context,
    required String currentPIN,
    required String newPIN,
  }) async {
    bool pinChanged = false;
    final connected = await connectionChecker();
    String url = "transactions/pin/change";
    if (context.mounted && connected) {
      changingPIN = true;
      notifyListeners();
      final body = {"oldPin": currentPIN, "pin": newPIN};
      (bool, String) changePasswordRequest = await ApiClient().putRequest(url,
          context: context,
          body: body,
          printResponseBody: true,
          requestName: "changePIN");
      changingPIN = false;
      if (changePasswordRequest.$1) {
        ///The user is logged in
        pinChanged = true;
        notifyListeners();
      } else {
        _resMessage = changePasswordRequest.$2;
        changingPIN = false;
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      changingPIN = false;
      notifyListeners();
    }
    return pinChanged;
  }

  bool addingBankAccount = false;

  Future<bool> addBankAccount({
    required BuildContext context,
    required String accountName,
    required String bankName,
    required String accountNumber,
    required String bankCode,
  }) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();

    final body = {
      "accountName": accountName,
      "bankName": bankName,
      "accountNumber": accountNumber,
      "bankCode": bankCode
    };

    debugPrint("addBankAccount Payload $body");
    if (connected) {
      String url = "user/vendor/bank-details";
      notifyListeners();
      try {
        if (context.mounted) {
          onboardingVendor = true;
          (bool, String) requestFetched = await ApiClient().postRequest(url,
              context: context,
              body: body,
              printResponseBody: true,
              requestName: "addBankAccount");
          addingBankAccount = false;
          if (requestFetched.$1) {
            fetched = true;
            if (context.mounted) {
              getProfile(context: context);
            }
            notifyListeners();
          } else {
            addingBankAccount = false;
            _resMessage = requestFetched.$2;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        addingBankAccount = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        addingBankAccount = false;
        debugPrint("addBankAccount Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      addingBankAccount = false;
      notifyListeners();
    }
    return fetched;
  }

  UserProfileModel? _userProfile;
  UserProfileModel? get userProfile => _userProfile;

  bool _fetchingProfile = false;
  bool get fetchingProfile => _fetchingProfile;

  Future<bool> getProfile({required BuildContext context}) async {
    notifyListeners();
    bool profileFetched = false;
    final connected = await connectionChecker();
    if (connected) {
      if (_userProfile == null) {
        _fetchingProfile = true;
        notifyListeners();
      }
      try {
        if (context.mounted) {
          (bool, String) profileRequestFetched = await ApiClient().getRequest(
              getProfileEndpoint,
              context: context,
              printResponseBody: false,
              requestName: "Get Profile");
          if (profileRequestFetched.$1) {
            _userProfile = userProfileModelFromJson(profileRequestFetched.$2);

            profileFetched = true;
            _fetchingProfile = false;
            notifyListeners();
          } else {
            _fetchingProfile = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        _fetchingProfile = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        _fetchingProfile = false;
        debugPrint("Get User Profile Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _fetchingProfile = false;
      notifyListeners();
    }
    return profileFetched;
  }

  CategoryData? selectedCategory;
  void updateSelectedCategory(CategoryData? category) {
    selectedCategory = category;
    notifyListeners();
  }

  bool gettingCategories = false;
  List<CategoryData> categories = [];
  Future<bool> getCategories(
      {required BuildContext context,
      bool isFilter = false,
      String filter = ""}) async {
    notifyListeners();
    bool requestFetched = false;
    if (isFilter) {
      categories = [];
      gettingCategories = true;
      notifyListeners();
    }
    final connected = await connectionChecker();
    if (connected) {
      if (categories.isEmpty) {
        gettingCategories = true;
        notifyListeners();
      }
      try {
        if (context.mounted) {
          (bool, String) profileRequestFetched = await ApiClient().getRequest(
              isFilter
                  ? "user/vendor/categories?search=$filter"
                  : "user/vendor/categories",
              context: context,
              printResponseBody: false,
              requestName: "Categories");
          if (profileRequestFetched.$1) {
            categories = categoryModelFromJson(profileRequestFetched.$2);

            requestFetched = true;
            gettingCategories = false;
            notifyListeners();
          } else {
            gettingCategories = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        gettingCategories = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        gettingCategories = false;
        debugPrint("Get User Profile Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      gettingCategories = false;
      notifyListeners();
    }
    return requestFetched;
  }

  bool _loggingOut = false;
  bool get loggingOut => _loggingOut;
  Future<bool> logOutUser({required BuildContext context}) async {
    notifyListeners();
    bool loggedOut = false;
    final connected = await connectionChecker();
    if (connected) {
      _loggingOut = true;
      notifyListeners();

      try {
        if (context.mounted) {
          (bool, String) logoutRequest = await ApiClient().postRequest(
              "auth/logout",
              context: context,
              printResponseBody: false,
              requestName: "Logout Request",
              body: {});
          if (logoutRequest.$1) {
            // Sign out from social providers
            await _socialAuthService.signOut();
            
            // Clear local data
            await clearHiveData();
            
            loggedOut = true;
            _loggingOut = false;
            notifyListeners();
          } else {
            _loggingOut = false;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        _loggingOut = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        _loggingOut = false;
        debugPrint("Logout User Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      _loggingOut = false;
      notifyListeners();
    }
    return loggedOut;
  }

//   Biometric login
  String? currentSavedEmail;
  String? currentSavedPassword;
  bool hasEnabledBiometric = false;

  void getSavedCredentials() async {
    final sharedPref = await SharedPreferences.getInstance();
    currentSavedEmail = sharedPref.getString(savedEmail) ?? "";
    currentSavedPassword = sharedPref.getString(savedPassword);
    hasEnabledBiometric = sharedPref.getBool(biometricEnabled) ?? false;
  }

  bool onboardingVendor = false;
  Future<bool> onboardVendor(
      {required BuildContext context,
      required String companyName,
      required String businessNumber,
      required String categoryName,
      required String number,
      required String address,
      required List<OpeningHoursModel> openingHours}) async {
    notifyListeners();
    bool fetched = false;
    final connected = await connectionChecker();

    final body = {
      "accountName": "Vendor A",
      // "bankName": "",
      // "accountNumber": "",
      "address": address,
      "businessCategory": categoryName,
      "businessNumber": businessNumber,
      "businessName": companyName,
      "openingHours": [
        {
          "dayOfWeek": "Monday",
          "openTime":
              '${openingHours[0].openingHour} ${openingHours[0].openingTime}',
          "closeTime":
              '${openingHours[0].closingHour} ${openingHours[0].closingTime}'
        },
        {
          "dayOfWeek": "Tuesday",
          "openTime":
              '${openingHours[1].openingHour} ${openingHours[1].openingTime}',
          "closeTime":
              '${openingHours[1].closingHour} ${openingHours[1].closingTime}'
        },
        {
          "dayOfWeek": "Wednesday",
          "openTime":
              '${openingHours[2].openingHour} ${openingHours[2].openingTime}',
          "closeTime":
              '${openingHours[2].closingHour} ${openingHours[2].closingTime}'
        },
        {
          "dayOfWeek": "Thursday",
          "openTime":
              '${openingHours[3].openingHour} ${openingHours[3].openingTime}',
          "closeTime":
              '${openingHours[3].closingHour} ${openingHours[3].closingTime}'
        },
        {
          "dayOfWeek": "Friday",
          "openTime":
              '${openingHours[4].openingHour} ${openingHours[4].openingTime}',
          "closeTime":
              '${openingHours[4].closingHour} ${openingHours[4].closingTime}'
        },
        {
          "dayOfWeek": "Saturday",
          "openTime":
              '${openingHours[5].openingHour} ${openingHours[5].openingTime}',
          "closeTime":
              '${openingHours[5].closingHour} ${openingHours[5].closingTime}'
        },
        {
          "dayOfWeek": "Sunday",
          "openTime":
              '${openingHours[6].openingHour} ${openingHours[6].openingTime}',
          "closeTime":
              '${openingHours[6].closingHour} ${openingHours[6].closingTime}'
        },
      ]
    };

    debugPrint("The payload to onboard Vendor is $body");
    if (connected) {
      String url = "user/vendor/onboard";
      notifyListeners();
      try {
        if (context.mounted) {
          onboardingVendor = true;
          (bool, String) requestFetched = await ApiClient().postRequest(url,
              context: context,
              body: body,
              printResponseBody: true,
              requestName: "onboardVendor");
          onboardingVendor = false;
          if (requestFetched.$1) {
            fetched = true;
            notifyListeners();
          } else {
            onboardingVendor = false;
            _resMessage = requestFetched.$2;
            notifyListeners();
          }
        }
      } on SocketException catch (_) {
        _resMessage = "Internet connection is not available";
        onboardingVendor = false;
        notifyListeners();
      } catch (e) {
        _resMessage = "Please try again";
        onboardingVendor = false;
        debugPrint("OnboardVendor Exception::::::::${e.toString()}");
        notifyListeners();
      }
    } else {
      _resMessage = "Internet connection is not available";
      onboardingVendor = false;
      notifyListeners();
    }
    return fetched;
  }
}

List<String> genderOptionList = [
  "Female",
  "Male",
];

List<String> genderOptionListWithBoth = ["Female", "Male", "Both"];
