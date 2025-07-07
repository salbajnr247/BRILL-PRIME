import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import '../../providers/real_time_provider.dart';
import '../../widgets/real_time_status_widget.dart';

class EnhancedVendorAnalyticsScreen extends StatefulWidget {
  const EnhancedVendorAnalyticsScreen({super.key});

  @override
  State<EnhancedVendorAnalyticsScreen> createState() => _EnhancedVendorAnalyticsScreenState();
}

class _EnhancedVendorAnalyticsScreenState extends State<EnhancedVendorAnalyticsScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '30days';

  final List<String> _periods = ['7days', '30days', '90days', '365days'];
  final Map<String, String> _periodLabels = {
    '7days': 'Last 7 Days',
    '30days': 'Last 30 Days',
    '90days': 'Last 3 Months',
    '365days': 'Last Year',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
      final realTimeProvider = Provider.of<RealTimeProvider>(context, listen: false);

      vendorProvider.getVendorAnalytics(context: context, period: _selectedPeriod);

      // Connect to real-time analytics updates
      realTimeProvider.connect();
      realTimeProvider.subscribeToAnalytics("vendor_id"); // Replace with actual vendor ID
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Analytics Dashboard",
        showBackArrow: true,
      ),
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          if (vendorProvider.loadingAnalytics) {
            return const Center(child: LoadingIndicator());
          }

          return Column(
            children: [
              // Period Selector
              _buildPeriodSelector(vendorProvider),

              // Key Metrics Overview
              _buildKeyMetrics(vendorProvider),

              // Tab Navigation
              _buildTabNavigation(),

              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSalesAnalytics(vendorProvider),
                    _buildProductAnalytics(vendorProvider),
                    _buildCustomerAnalytics(vendorProvider),
                    _buildInventoryAnalytics(vendorProvider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector(VendorProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Text(
            "Period:",
            style: TextStyle(
              fontFamily: FontConstants.montserratSemiBold,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPeriod,
                  isExpanded: true,
                  items: _periods.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(
                        _periodLabels[period]!,
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
                        _selectedPeriod = value;
                      });
                      provider.getVendorAnalytics(
                        context: context,
                        period: value,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(VendorProvider provider) {
    final analytics = provider.analyticsData;
    if (analytics == null) return const SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              "Total Revenue",
              "₦${analytics.salesMetrics.totalRevenue.toStringAsFixed(2)}",
              "${analytics.salesMetrics.revenueGrowth >= 0 ? '+' : ''}${analytics.salesMetrics.revenueGrowth.toStringAsFixed(1)}%",
              analytics.salesMetrics.revenueGrowth >= 0 ? Colors.green : Colors.red,
              Icons.trending_up,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildMetricCard(
              "Orders",
              "${analytics.salesMetrics.totalOrders}",
              "${analytics.salesMetrics.ordersGrowth >= 0 ? '+' : ''}${analytics.salesMetrics.ordersGrowth}%",
              analytics.salesMetrics.ordersGrowth >= 0 ? Colors.green : Colors.red,
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String change, Color changeColor, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.primary, size: 24.sp),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 10.sp,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontConstants.montserratBold,
              fontSize: 20.sp,
              color: AppColors.black,
            ),
          ),
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
    );
  }

  Widget _buildTabNavigation() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        labelColor: AppColors.white,
        unselectedLabelColor: AppColors.grey600,
        labelStyle: TextStyle(
          fontFamily: FontConstants.montserratMedium,
          fontSize: 12.sp,
        ),
        tabs: const [
          Tab(text: "Sales"),
          Tab(text: "Products"),
          Tab(text: "Customers"),
          Tab(text: "Inventory"),
        ],
      ),
    );
  }

  Widget _buildSalesAnalytics(VendorProvider provider) {
    final analytics = provider.analyticsData;
    if (analytics == null) return const SizedBox();

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSalesMetricsCard(analytics.salesMetrics),
        SizedBox(height: 16.h),
        _buildRevenueChart(analytics.revenueHistory),
        SizedBox(height: 16.h),
        _buildTopProductsCard(analytics.topProducts),
      ],
    );
  }

  Widget _buildSalesMetricsCard(dynamic salesMetrics) {
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
          Text(
            "Sales Performance",
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
                child: _buildSalesMetricItem(
                  "Average Order Value",
                  "₦${salesMetrics.averageOrderValue.toStringAsFixed(2)}",
                  Icons.receipt,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildSalesMetricItem(
                  "Revenue Growth",
                  "${salesMetrics.revenueGrowth.toStringAsFixed(1)}%",
                  Icons.trending_up,
                  salesMetrics.revenueGrowth >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesMetricItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontConstants.montserratBold,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: FontConstants.montserratMedium,
              fontSize: 10.sp,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(List<dynamic> revenueHistory) {
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
                "Revenue Trend",
                style: TextStyle(
                  fontFamily: FontConstants.montserratSemiBold,
                  fontSize: 16.sp,
                  color: AppColors.black,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "Last ${revenueHistory.length} days",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 10.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            height: 150.h,
            child: revenueHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart,
                          size: 48.sp,
                          color: AppColors.grey400,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "No revenue data",
                          style: TextStyle(
                            fontFamily: FontConstants.montserratMedium,
                            fontSize: 14.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildSimpleLineChart(revenueHistory),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartLegendItem("Revenue", AppColors.primary),
              _buildChartLegendItem("Target", AppColors.orange),
              _buildChartLegendItem("Trend", AppColors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleLineChart(List<dynamic> data) {
    final maxValue = data.isEmpty ? 0.0 : data.map((e) => e['value'] ?? 0.0).reduce((a, b) => a > b ? a : b);
    
    return Container(
      padding: EdgeInsets.all(8.w),
      child: CustomPaint(
        size: Size(double.infinity, 134.h),
        painter: SimpleLineChartPainter(
          data: data.map((e) => (e['value'] ?? 0.0).toDouble()).toList(),
          maxValue: maxValue,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildChartLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontFamily: FontConstants.montserratRegular,
            fontSize: 10.sp,
            color: AppColors.grey600,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsCard(List<dynamic> topProducts) {
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
          Text(
            "Top Performing Products",
            style: TextStyle(
              fontFamily: FontConstants.montserratSemiBold,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          ...topProducts.take(5).map((product) => _buildProductItem(product)),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic product) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: product.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.inventory_2,
                          color: AppColors.primary,
                          size: 20.sp,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.inventory_2,
                    color: AppColors.primary,
                    size: 20.sp,
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
                    fontFamily: FontConstants.montserratSemiBold,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                ),
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
              fontFamily: FontConstants.montserratBold,
              fontSize: 14.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductAnalytics(VendorProvider provider) {
    return Center(
      child: Text(
        "Product Analytics Coming Soon",
        style: TextStyle(
          fontFamily: FontConstants.montserratMedium,
          fontSize: 16.sp,
          color: AppColors.grey600,
        ),
      ),
    );
  }

  Widget _buildCustomerAnalytics(VendorProvider provider) {
    final analytics = provider.analyticsData;
    if (analytics == null) return const SizedBox();

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildCustomerMetricsCard(analytics.customerMetrics),
      ],
    );
  }

  Widget _buildCustomerMetricsCard(dynamic customerMetrics) {
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
          Text(
            "Customer Insights",
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
                child: _buildCustomerMetricItem(
                  "Total Customers",
                  "${customerMetrics.totalCustomers}",
                  Icons.people,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildCustomerMetricItem(
                  "New Customers",
                  "${customerMetrics.newCustomers}",
                  Icons.person_add,
                  Colors.green,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildCustomerMetricItem(
                  "Returning",
                  "${customerMetrics.returningCustomers}",
                  Icons.repeat,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildCustomerMetricItem(
                  "Retention Rate",
                  "${customerMetrics.customerRetentionRate.toStringAsFixed(1)}%",
                  Icons.favorite,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerMetricItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontConstants.montserratBold,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: FontConstants.montserratMedium,
              fontSize: 10.sp,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryAnalytics(VendorProvider provider) {
    final analytics = provider.analyticsData;
    if (analytics == null) return const SizedBox();

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildInventoryMetricsCard(analytics.inventoryMetrics),
      ],
    );
  }

  Widget _buildInventoryMetricsCard(dynamic inventoryMetrics) {
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
          Text(
            "Inventory Health",
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
                child: _buildInventoryMetricItem(
                  "Total Products",
                  "${inventoryMetrics.totalProducts}",
                  Icons.inventory_2,
                  Colors.blue,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildInventoryMetricItem(
                  "Low Stock",
                  "${inventoryMetrics.lowStockProducts}",
                  Icons.warning,
                  Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildInventoryMetricItem(
                  "Out of Stock",
                  "${inventoryMetrics.outOfStockProducts}",
                  Icons.remove_circle,
                  Colors.red,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildInventoryMetricItem(
                  "Turnover Rate",
                  "${inventoryMetrics.inventoryTurnover.toStringAsFixed(1)}x",
                  Icons.autorenew,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryMetricItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: FontConstants.montserratBold,
              fontSize: 16.sp,
              color: AppColors.black,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: FontConstants.montserratMedium,
              fontSize: 10.sp,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}