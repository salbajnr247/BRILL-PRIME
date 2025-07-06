
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../providers/auth_provider.dart';
import '../../services/biometric_auth_service.dart';
import 'custom_text.dart';
import 'dart:io' as platform;

class BiometricQuickLoginWidget extends StatefulWidget {
  final VoidCallback? onSuccess;

  const BiometricQuickLoginWidget({
    Key? key,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<BiometricQuickLoginWidget> createState() => _BiometricQuickLoginWidgetState();
}

class _BiometricQuickLoginWidgetState extends State<BiometricQuickLoginWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  final BiometricAuthService _biometricService = BiometricAuthService();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometric() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final result = await _biometricService.authenticateForLogin();

      if (result) {
        // Auto-login with biometric
        await authProvider.biometricLogin();
        widget.onSuccess?.call();
      } else {
        _showError("Authentication failed");
      }
    } catch (e) {
      _showError("Authentication error: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (!authProvider.isBiometricEnabled) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Divider with "OR"
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: BodyTextPrimaryWithLineHeight(
                    text: "OR",
                    fontWeight: FontWeight.w500,
                    textColor: Colors.grey[600]!,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Biometric button
            GestureDetector(
              onTap: _authenticateWithBiometric,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isAuthenticating ? 1.0 : _pulseAnimation.value,
                    child: Container(
                      height: 80.w,
                      width: 80.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            mainColor.withOpacity(0.8),
                            mainColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: mainColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _isAuthenticating
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ),
                            )
                          : Center(
                              child: SvgPicture.asset(
                                platform.Platform.isIOS ? faceIdIcon : fingerPrintIcon,
                                height: 32.w,
                                width: 32.w,
                                color: white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Instruction text
            BodyTextPrimaryWithLineHeight(
              text: platform.Platform.isIOS 
                  ? "Tap to sign in with Face ID"
                  : "Tap to sign in with fingerprint",
              fontWeight: FontWeight.w500,
              textColor: Colors.grey[600]!,
              fontSize: 14,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),
          ],
        );
      },
    );
  }
}
