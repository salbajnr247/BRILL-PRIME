import 'dart:io' as platform;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../../resources/constants/image_constant.dart';
import '../../providers/auth_provider.dart';
import '../custom_text.dart';
import '../components.dart';
import '../../../services/biometric_auth_service.dart';
import 'package:local_auth/local_auth.dart';

Future showEnableBiometricLoginModal(BuildContext importedContext) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: importedContext,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      const BodyTextPrimaryWithLineHeight(
                        text: "Secure Login",
                        fontWeight: boldFont,
                        textColor: blackTextColor,
                        fontSize: 18,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Animated biometric icon with gradient background
                  Container(
                    height: 100.w,
                    width: 100.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor.withOpacity(0.1),
                          mainColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        platform.Platform.isIOS ? faceIdIcon : fingerPrintIcon,
                        height: 50.w,
                        width: 50.w,
                        color: mainColor,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Title and description
                  const BodyTextPrimaryWithLineHeight(
                    text: "Enable Biometric Authentication",
                    fontWeight: boldFont,
                    textColor: blackTextColor,
                    fontSize: 20,
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  BodyTextPrimaryWithLineHeight(
                    text: platform.Platform.isIOS 
                        ? "Use Face ID to securely and quickly access your account"
                        : "Use your fingerprint to securely and quickly access your account",
                    fontWeight: regularFont,
                    textColor: Colors.grey[600]!,
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Benefits list
                  _buildBenefitItem(Icons.security, "Enhanced Security"),
                  SizedBox(height: 12.h),
                  _buildBenefitItem(Icons.flash_on, "Quick Access"),
                  SizedBox(height: 12.h),
                  _buildBenefitItem(Icons.verified_user, "Personal Protection"),
                  
                  SizedBox(height: 32.h),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text(
                            "Not Now",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _enableBiometric(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Enable",
                            style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildBenefitItem(IconData icon, String text) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: mainColor,
          size: 20.w,
        ),
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: BodyTextPrimaryWithLineHeight(
          text: text,
          fontWeight: mediumFont,
          textColor: blackTextColor,
          fontSize: 14,
        ),
      ),
    ],
  );
}

Future<void> _enableBiometric(BuildContext context) async {
  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final biometricService = BiometricAuthService();
    
    // Check if biometric is available
    final isAvailable = await biometricService.isBiometricAvailable();
    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Biometric authentication is not available on this device"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Get available biometric types
    final availableBiometrics = await biometricService.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No biometric methods are set up on this device"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Authenticate
    final isAuthenticated = await biometricService.authenticate();
    if (isAuthenticated) {
      // Enable biometric in provider
      await authProvider.enableBiometric();
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8.w),
              const Text("Biometric authentication enabled successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Biometric authentication failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
