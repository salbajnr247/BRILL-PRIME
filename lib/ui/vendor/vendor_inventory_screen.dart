
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

class VendorInventoryScreen extends StatefulWidget {
  const VendorInventoryScreen({super.key});

  @override
  State<VendorInventoryScreen> createState() => _VendorInventoryScreenState();
}

class _VendorInventoryScreenState extends State<VendorInventoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VendorProvider>();
      provider.getVendorCommodities(
        context: context,
        vendorId: "current_vendor_id", // This should come from auth state
      );
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
        title: "Inventory Management",
        showBackArrow: true,
      ),
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          return Column(
            children: [
              // Inventory Summary Cards
              _buildInventorySummary(vendorProvider),
              
              // Filter Tabs
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                  tabs: const [
                    Tab(text: "All Products"),
                    Tab(text: "Low Stock"),
                    Tab(text: "Out of Stock"),
                  ],
                ),
              ),

              // Product List
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProductList(vendorProvider, 'all'),
                    _buildProductList(vendorProvider, 'low_stock'),
                    _buildProductList(vendorProvider, 'out_of_stock'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-commodity'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: Text(
          "Add Product",
          style: TextStyle(
            fontFamily: FontConstants.montserratMedium,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildInventorySummary(VendorProvider provider) {
    final analytics = provider.analyticsData?.inventoryMetrics;
    
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              "Total Products",
              "${analytics?.totalProducts ?? 0}",
              Colors.blue,
              Icons.inventory_2,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildSummaryCard(
              "Low Stock Alerts",
              "${analytics?.lowStockProducts ?? 0}",
              Colors.orange,
              Icons.warning,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildSummaryCard(
              "Out of Stock",
              "${analytics?.outOfStockProducts ?? 0}",
              Colors.red,
              Icons.remove_circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
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
              fontSize: 18.sp,
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

  Widget _buildProductList(VendorProvider provider, String filter) {
    if (provider.gettingVendorCommodities) {
      return const Center(child: LoadingIndicator());
    }

    var filteredProducts = provider.vendorCommodities;
    
    // Apply filters based on stock levels
    if (filter == 'low_stock') {
      filteredProducts = filteredProducts.where((product) => 
        product.quantity <= 10 && product.quantity > 0).toList();
    } else if (filter == 'out_of_stock') {
      filteredProducts = filteredProducts.where((product) => 
        product.quantity <= 0).toList();
    }

    if (filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text(
              filter == 'all' ? "No products found" :
              filter == 'low_stock' ? "No low stock products" :
              "No out of stock products",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 16.sp,
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await provider.getVendorCommodities(
          context: context,
          vendorId: "current_vendor_id",
        );
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return _buildProductCard(product, provider);
        },
      ),
    );
  }

  Widget _buildProductCard(dynamic product, VendorProvider provider) {
    final stockStatus = _getStockStatus(product.quantity);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.grey200,
            ),
            child: product.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: AppColors.grey400,
                          size: 24.sp,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.inventory_2,
                    color: AppColors.grey400,
                    size: 24.sp,
                  ),
          ),
          SizedBox(width: 12.w),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratSemiBold,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "₦${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 12.sp,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: stockStatus['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Stock: ${product.quantity}",
                        style: TextStyle(
                          fontFamily: FontConstants.montserratMedium,
                          fontSize: 10.sp,
                          color: stockStatus['color'],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: stockStatus['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        stockStatus['status'],
                        style: TextStyle(
                          fontFamily: FontConstants.montserratMedium,
                          fontSize: 10.sp,
                          color: stockStatus['color'],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action Buttons
          Column(
            children: [
              GestureDetector(
                onTap: () => _showUpdateStockDialog(product, provider),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AppColors.primary,
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => context.push('/edit-commodity/${product.id}'),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Colors.blue,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStockStatus(int quantity) {
    if (quantity <= 0) {
      return {'status': 'Out of Stock', 'color': Colors.red};
    } else if (quantity <= 10) {
      return {'status': 'Low Stock', 'color': Colors.orange};
    } else {
      return {'status': 'In Stock', 'color': Colors.green};
    }
  }

  void _showUpdateStockDialog(dynamic product, VendorProvider provider) {
    final TextEditingController quantityController = TextEditingController(
      text: product.quantity.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Update Stock",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 16.sp,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 14.sp,
                color: AppColors.grey700,
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                color: AppColors.grey600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newQuantity = int.tryParse(quantityController.text);
              if (newQuantity != null) {
                Navigator.pop(context);
                // Update inventory levels
                await provider.updateInventoryLevels(
                  context: context,
                  inventoryData: {
                    'productId': product.id,
                    'quantity': newQuantity,
                  },
                );
                // Refresh the product list
                await provider.getVendorCommodities(
                  context: context,
                  vendorId: "current_vendor_id",
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(
              "Update",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
