
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:brill_prime/ui/widgets/components.dart';

class VendorAnalyticsScreen extends StatefulWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  State<VendorAnalyticsScreen> createState() => _VendorAnalyticsScreenState();
}

class _VendorAnalyticsScreenState extends State<VendorAnalyticsScreen> {
  String selectedPeriod = '30days';
  final List<String> periods = ['7days', '30days', '90days', '1year'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().getVendorAnalytics(
            context: context,
            period: selectedPeriod,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Analytics",
        showBackArrow: true,
      ),
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          if (vendorProvider.loadingAnalytics) {
            return const Center(child: LoadingIndicator());
          }

          if (vendorProvider.analyticsData == null) {
            return const Center(
              child: Text("No analytics data available"),
            );
          }

          final analytics = vendorProvider.analyticsData!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period selector
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      isExpanded: true,
                      items: periods.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(
                            _getPeriodLabel(period),
                            style: TextStyle(
                              fontFamily: FontConstants.montserratMedium,
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPeriod = value;
                          });
                          vendorProvider.getVendorAnalytics(
                            context: context,
                            period: value,
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Sales metrics cards
                _buildSalesMetricsSection(analytics.salesMetrics),
                SizedBox(height: 20.h),

                // Customer metrics
                _buildCustomerMetricsSection(analytics.customerMetrics),
                SizedBox(height: 20.h),

                // Inventory metrics
                _buildInventoryMetricsSection(analytics.inventoryMetrics),
                SizedBox(height: 20.h),

                // Top products
                _buildTopProductsSection(analytics.topProducts),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalesMetricsSection(salesMetrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sales Overview",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Total Revenue",
                "₦${salesMetrics.totalRevenue.toStringAsFixed(2)}",
                "${salesMetrics.revenueGrowth >= 0 ? '+' : ''}${salesMetrics.revenueGrowth.toStringAsFixed(1)}%",
                salesMetrics.revenueGrowth >= 0,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMetricCard(
                "Total Orders",
                "${salesMetrics.totalOrders}",
                "${salesMetrics.ordersGrowth >= 0 ? '+' : ''}${salesMetrics.ordersGrowth}%",
                salesMetrics.ordersGrowth >= 0,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildMetricCard(
          "Average Order Value",
          "₦${salesMetrics.averageOrderValue.toStringAsFixed(2)}",
          "",
          true,
          isFullWidth: true,
        ),
      ],
    );
  }

  Widget _buildCustomerMetricsSection(customerMetrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer Insights",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Total Customers",
                "${customerMetrics.totalCustomers}",
                "",
                true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMetricCard(
                "New Customers",
                "${customerMetrics.newCustomers}",
                "",
                true,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Returning",
                "${customerMetrics.returningCustomers}",
                "",
                true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMetricCard(
                "Retention Rate",
                "${customerMetrics.customerRetentionRate.toStringAsFixed(1)}%",
                "",
                true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInventoryMetricsSection(inventoryMetrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Inventory Status",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Total Products",
                "${inventoryMetrics.totalProducts}",
                "",
                true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMetricCard(
                "Low Stock",
                "${inventoryMetrics.lowStockProducts}",
                "",
                inventoryMetrics.lowStockProducts == 0,
                alertColor: inventoryMetrics.lowStockProducts > 0 ? Colors.orange : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                "Out of Stock",
                "${inventoryMetrics.outOfStockProducts}",
                "",
                inventoryMetrics.outOfStockProducts == 0,
                alertColor: inventoryMetrics.outOfStockProducts > 0 ? Colors.red : null,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildMetricCard(
                "Turnover Rate",
                "${inventoryMetrics.inventoryTurnover.toStringAsFixed(2)}x",
                "",
                true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopProductsSection(List topProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Performing Products",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topProducts.length,
          itemBuilder: (context, index) {
            final product = topProducts[index];
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
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.grey100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  color: AppColors.grey500,
                                  size: 24.sp,
                                );
                              },
                            )
                          : Icon(
                              Icons.image,
                              color: AppColors.grey500,
                              size: 24.sp,
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: TextStyle(
                            fontFamily: FontConstants.montserratMedium,
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "${product.unitsSold} units sold",
                          style: TextStyle(
                            fontFamily: FontConstants.montserratRegular,
                            fontSize: 12.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "₦${product.revenue.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratSemiBold,
                      fontSize: 14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String growth,
    bool isPositive, {
    bool isFullWidth = false,
    Color? alertColor,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: alertColor ?? AppColors.grey300,
          width: alertColor != null ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: FontConstants.montserratRegular,
              fontSize: 12.sp,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontConstants.montserratSemiBold,
              fontSize: 18.sp,
              color: alertColor ?? AppColors.black,
            ),
          ),
          if (growth.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              growth,
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 12.sp,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getPeriodLabel(String period) {
    switch (period) {
      case '7days':
        return 'Last 7 days';
      case '30days':
        return 'Last 30 days';
      case '90days':
        return 'Last 90 days';
      case '1year':
        return 'Last year';
      default:
        return 'Last 30 days';
    }
  }
}
