
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:brill_prime/ui/widgets/components.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VendorProvider>();
      provider.getVendorDashboard(context: context);
      provider.getVendorAnalytics(context: context);
      provider.getVendorSubscription(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Vendor Dashboard",
        showBackArrow: false,
      ),
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          if (vendorProvider.loadingDashboard) {
            return const Center(child: LoadingIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                vendorProvider.getVendorDashboard(context: context),
                vendorProvider.getVendorAnalytics(context: context),
                vendorProvider.getVendorSubscription(context: context),
              ]);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats overview
                  _buildQuickStatsSection(vendorProvider),
                  SizedBox(height: 24.h),

                  // Analytics summary
                  _buildAnalyticsSummary(vendorProvider),
                  SizedBox(height: 24.h),

                  // Subscription status
                  _buildSubscriptionStatus(vendorProvider),
                  SizedBox(height: 24.h),

                  // Quick actions
                  _buildQuickActions(),
                  SizedBox(height: 24.h),

                  // Recent orders
                  _buildRecentOrders(vendorProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStatsSection(VendorProvider provider) {
    final analytics = provider.analyticsData;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Overview",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Revenue",
                analytics?.salesMetrics.totalRevenue.toStringAsFixed(2) ?? "0.00",
                "₦",
                Colors.green,
                Icons.trending_up,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                "Orders",
                "${analytics?.salesMetrics.totalOrders ?? 0}",
                "",
                Colors.blue,
                Icons.shopping_bag,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                "Products",
                "${analytics?.inventoryMetrics.totalProducts ?? 0}",
                "",
                Colors.purple,
                Icons.inventory_2,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                "Customers",
                "${analytics?.customerMetrics.totalCustomers ?? 0}",
                "",
                Colors.orange,
                Icons.people,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String prefix, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.sp),
              Text(
                title,
                style: TextStyle(
                  fontFamily: FontConstants.montserratMedium,
                  fontSize: 12.sp,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: prefix,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratSemiBold,
                    fontSize: 14.sp,
                    color: color,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratBold,
                    fontSize: 20.sp,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSummary(VendorProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Analytics",
                style: TextStyle(
                  fontFamily: FontConstants.montserratSemiBold,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/vendor-analytics'),
                child: Text(
                  "View Details",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (provider.analyticsData != null) ...[
            _buildAnalyticsRow("Revenue Growth", "${provider.analyticsData!.salesMetrics.revenueGrowth.toStringAsFixed(1)}%"),
            _buildAnalyticsRow("Order Growth", "${provider.analyticsData!.salesMetrics.ordersGrowth}%"),
            _buildAnalyticsRow("Customer Retention", "${provider.analyticsData!.customerMetrics.customerRetentionRate.toStringAsFixed(1)}%"),
          ] else
            Text(
              "No analytics data available",
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
                color: AppColors.grey600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontConstants.montserratRegular,
              fontSize: 14.sp,
              color: AppColors.grey700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontConstants.montserratSemiBold,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStatus(VendorProvider provider) {
    final subscription = provider.subscriptionData;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subscription",
                style: TextStyle(
                  fontFamily: FontConstants.montserratSemiBold,
                  fontSize: 16.sp,
                  color: AppColors.white,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/vendor-subscription'),
                child: Text(
                  "Manage",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 12.sp,
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (subscription?.currentPlan != null) ...[
            Text(
              subscription!.currentPlan.name,
              style: TextStyle(
                fontFamily: FontConstants.montserratBold,
                fontSize: 18.sp,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "₦${subscription.currentPlan.price.toStringAsFixed(2)}/${subscription.currentPlan.billingCycle}",
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
                color: AppColors.white.withOpacity(0.9),
              ),
            ),
            if (subscription.nextBillingDate != null) ...[
              SizedBox(height: 8.h),
              Text(
                "Next billing: ${subscription.nextBillingDate!.toString().split(' ')[0]}",
                style: TextStyle(
                  fontFamily: FontConstants.montserratRegular,
                  fontSize: 12.sp,
                  color: AppColors.white.withOpacity(0.8),
                ),
              ),
            ],
          ] else
            Text(
              "No active subscription",
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
                color: AppColors.white.withOpacity(0.9),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                "Add Product",
                Icons.add_box,
                () => context.push('/add-commodity'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                "View Orders",
                Icons.receipt_long,
                () => context.push('/vendor-orders'),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                "Analytics",
                Icons.analytics,
                () => context.push('/vendor-analytics'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                "Profile",
                Icons.person,
                () => context.push('/vendor-profile'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 12.sp,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(VendorProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Orders",
              style: TextStyle(
                fontFamily: FontConstants.montserratSemiBold,
                fontSize: 16.sp,
                color: AppColors.black,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/vendor-orders'),
              child: Text(
                "View All",
                style: TextStyle(
                  fontFamily: FontConstants.montserratMedium,
                  fontSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (provider.vendorOrders.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.vendorOrders.take(3).length,
            itemBuilder: (context, index) {
              final order = provider.vendorOrders[index];
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.grey300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order #${order.id}",
                            style: TextStyle(
                              fontFamily: FontConstants.montserratSemiBold,
                              fontSize: 14.sp,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "₦${order.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontFamily: FontConstants.montserratMedium,
                              fontSize: 12.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        order.status,
                        style: TextStyle(
                          fontFamily: FontConstants.montserratMedium,
                          fontSize: 10.sp,
                          color: _getStatusColor(order.status),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        else
          Center(
            child: Text(
              "No recent orders",
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
                color: AppColors.grey600,
              ),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.grey600;
    }
  }
}
