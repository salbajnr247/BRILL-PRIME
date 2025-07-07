
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../custom_text.dart';
import '../components.dart';

class GuestCheckoutDialog extends StatelessWidget {
  const GuestCheckoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 48.w,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            CustomText(
              text: 'Checkout Options',
              fontSize: AppFontSize.s20,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.paddingMedium),
            CustomText(
              text: 'Choose how you\'d like to proceed with your order',
              fontSize: AppFontSize.s14,
              color: AppColors.greyColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.paddingLarge),
            
            // Sign In Option
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
                icon: Icon(Icons.login),
                label: Text('Sign In to Continue'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: AppDimensions.paddingMedium),
            
            // Guest Checkout Option
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<CartProvider>().enableGuestCheckout();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/guest-checkout');
                },
                icon: Icon(Icons.person_outline),
                label: Text('Continue as Guest'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: BorderSide(color: AppColors.primaryColor),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: AppDimensions.paddingMedium),
            
            // Create Account Option
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sign-up');
              },
              child: CustomText(
                text: 'Create an Account',
                fontSize: AppFontSize.s14,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            SizedBox(height: AppDimensions.paddingSmall),
            
            // Benefits of having an account
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Benefits of having an account:',
                    fontSize: AppFontSize.s14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: AppDimensions.paddingSmall),
                  _buildBenefitItem('Track your orders'),
                  _buildBenefitItem('Save items for later'),
                  _buildBenefitItem('Faster checkout'),
                  _buildBenefitItem('Order history'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16.w,
            color: AppColors.primaryColor,
          ),
          SizedBox(width: 8.w),
          CustomText(
            text: text,
            fontSize: AppFontSize.s12,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }
}
