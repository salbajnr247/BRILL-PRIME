
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:brill_prime/ui/widgets/components.dart';

class VendorSubscriptionScreen extends StatefulWidget {
  const VendorSubscriptionScreen({super.key});

  @override
  State<VendorSubscriptionScreen> createState() => _VendorSubscriptionScreenState();
}

class _VendorSubscriptionScreenState extends State<VendorSubscriptionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().getVendorSubscription(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Subscription Plans",
        showBackArrow: true,
      ),
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          if (vendorProvider.loadingSubscription) {
            return const Center(child: LoadingIndicator());
          }

          if (vendorProvider.subscriptionData == null) {
            return const Center(
              child: Text("No subscription data available"),
            );
          }

          final subscription = vendorProvider.subscriptionData!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current plan section
                _buildCurrentPlanSection(subscription.currentPlan),
                SizedBox(height: 24.h),

                // Available plans section
                Text(
                  "Available Plans",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratSemiBold,
                    fontSize: 18.sp,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 16.h),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subscription.availablePlans.length,
                  itemBuilder: (context, index) {
                    final plan = subscription.availablePlans[index];
                    return _buildPlanCard(plan, vendorProvider);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPlanSection(currentPlan) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified,
                color: AppColors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                "Current Plan",
                style: TextStyle(
                  fontFamily: FontConstants.montserratMedium,
                  fontSize: 14.sp,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            currentPlan.name,
            style: TextStyle(
              fontFamily: FontConstants.montserratBold,
              fontSize: 24.sp,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            currentPlan.description,
            style: TextStyle(
              fontFamily: FontConstants.montserratRegular,
              fontSize: 14.sp,
              color: AppColors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                "₦${currentPlan.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: FontConstants.montserratBold,
                  fontSize: 20.sp,
                  color: AppColors.white,
                ),
              ),
              Text(
                "/${currentPlan.billingCycle}",
                style: TextStyle(
                  fontFamily: FontConstants.montserratRegular,
                  fontSize: 14.sp,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(plan, VendorProvider vendorProvider) {
    final isCurrentPlan = plan.isActive;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrentPlan ? AppColors.primary.withOpacity(0.05) : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCurrentPlan ? AppColors.primary : AppColors.grey300,
          width: isCurrentPlan ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.name,
                style: TextStyle(
                  fontFamily: FontConstants.montserratSemiBold,
                  fontSize: 18.sp,
                  color: AppColors.black,
                ),
              ),
              if (isCurrentPlan)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Active",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratMedium,
                      fontSize: 10.sp,
                      color: AppColors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            plan.description,
            style: TextStyle(
              fontFamily: FontConstants.montserratRegular,
              fontSize: 14.sp,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text(
                "₦${plan.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: FontConstants.montserratBold,
                  fontSize: 20.sp,
                  color: AppColors.black,
                ),
              ),
              Text(
                "/${plan.billingCycle}",
                style: TextStyle(
                  fontFamily: FontConstants.montserratRegular,
                  fontSize: 14.sp,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Features list
          ...plan.features.map<Widget>((feature) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontFamily: FontConstants.montserratRegular,
                        fontSize: 12.sp,
                        color: AppColors.grey800,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          
          SizedBox(height: 16.h),
          
          // Plan limits
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                _buildPlanLimit("Max Products", "${plan.maxProducts}"),
                SizedBox(height: 4.h),
                _buildPlanLimit("Max Orders/Month", "${plan.maxOrders}"),
                SizedBox(height: 4.h),
                _buildPlanLimit("Analytics", plan.hasAnalytics ? "Included" : "Not included"),
                SizedBox(height: 4.h),
                _buildPlanLimit("Priority Support", plan.hasPrioritySupport ? "Included" : "Not included"),
              ],
            ),
          ),
          
          if (!isCurrentPlan) ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: GeneralButton(
                onPressed: vendorProvider.subscribingToPlan
                    ? null
                    : () => _subscribeToPlan(plan.id, vendorProvider),
                child: vendorProvider.subscribingToPlan
                    ? const LoadingIndicator()
                    : Text(
                        "Subscribe",
                        style: TextStyle(
                          fontFamily: FontConstants.montserratSemiBold,
                          fontSize: 14.sp,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlanLimit(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FontConstants.montserratRegular,
            fontSize: 12.sp,
            color: AppColors.grey600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: FontConstants.montserratMedium,
            fontSize: 12.sp,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  void _subscribeToPlan(String planId, VendorProvider vendorProvider) async {
    final success = await vendorProvider.subscribeToPlan(
      context: context,
      planId: planId,
    );

    if (success) {
      // Refresh subscription data
      vendorProvider.getVendorSubscription(context: context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vendorProvider.resMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vendorProvider.resMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
