
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../services/biometric_auth_service.dart';
import 'custom_text.dart';
import 'dart:io' as platform;

class BiometricPromptWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSuccess;
  final VoidCallback? onCancel;
  final String? customReason;

  const BiometricPromptWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onSuccess,
    this.onCancel,
    this.customReason,
  }) : super(key: key);

  @override
  State<BiometricPromptWidget> createState() => _BiometricPromptWidgetState();
}

class _BiometricPromptWidgetState extends State<BiometricPromptWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isAuthenticating = false;
  final BiometricAuthService _biometricService = BiometricAuthService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final result = await _biometricService.authenticate(
        customReason: widget.customReason,
      );

      if (result) {
        widget.onSuccess();
      } else {
        _showErrorFeedback();
      }
    } catch (e) {
      _showErrorFeedback();
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _showErrorFeedback() {
    // Add haptic feedback or visual feedback for failed authentication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Authentication failed. Please try again.'),
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
    return Container(
      padding: EdgeInsets.all(24.w),
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
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Biometric icon with pulse animation
                  Container(
                    height: 100.w,
                    width: 100.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          mainColor.withOpacity(0.2),
                          mainColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse effect
                        if (_isAuthenticating)
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.8, end: 1.2),
                            duration: const Duration(milliseconds: 1000),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: mainColor.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onEnd: () {
                              if (_isAuthenticating) {
                                setState(() {}); // Trigger rebuild for continuous animation
                              }
                            },
                          ),
                        // Biometric icon
                        SvgPicture.asset(
                          platform.Platform.isIOS ? faceIdIcon : fingerPrintIcon,
                          height: 50.w,
                          width: 50.w,
                          color: _isAuthenticating ? mainColor : mainColor.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Title
                  BodyTextPrimaryWithLineHeight(
                    text: widget.title,
                    fontWeight: FontWeight.bold,
                    textColor: blackTextColor,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 8.h),

                  // Subtitle
                  BodyTextPrimaryWithLineHeight(
                    text: widget.subtitle,
                    fontWeight: FontWeight.normal,
                    textColor: Colors.grey[600]!,
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32.h),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isAuthenticating ? null : _authenticate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isAuthenticating
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(white),
                              ),
                            )
                          : Text(
                              platform.Platform.isIOS ? "Use Face ID" : "Use Fingerprint",
                              style: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  if (widget.onCancel != null) ...[
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: widget.onCancel,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
