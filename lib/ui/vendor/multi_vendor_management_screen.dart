
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:brill_prime/ui/widgets/components.dart';

class MultiVendorManagementScreen extends StatefulWidget {
  const MultiVendorManagementScreen({super.key});

  @override
  State<MultiVendorManagementScreen> createState() => _MultiVendorManagementScreenState();
}

class _MultiVendorManagementScreenState extends State<MultiVendorManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorProvider>().getConnectedVendors(context: context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Multi-Vendor Management",
        showBackArrow: true,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search vendors...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.grey300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          
          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey600,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: "Connected Vendors"),
              Tab(text: "Discover Vendors"),
            ],
          ),
          
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildConnectedVendorsTab(),
                _buildDiscoverVendorsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedVendorsTab() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, child) {
        if (vendorProvider.loadingConnectedVendors) {
          return const Center(child: LoadingIndicator());
        }

        if (vendorProvider.connectedVendors.isEmpty) {
          return _buildEmptyState(
            "No Connected Vendors",
            "You haven't connected with any vendors yet. Browse available vendors to start collaborating.",
            Icons.store,
          );
        }

        return RefreshIndicator(
          onRefresh: () => vendorProvider.getConnectedVendors(context: context),
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: vendorProvider.connectedVendors.length,
            itemBuilder: (context, index) {
              final vendor = vendorProvider.connectedVendors[index];
              return _buildVendorCard(vendor, isConnected: true);
            },
          ),
        );
      },
    );
  }

  Widget _buildDiscoverVendorsTab() {
    // Mock data for demonstration - in real app, this would come from API
    final availableVendors = [
      {
        'id': '1',
        'name': 'Fresh Farm Produce',
        'category': 'Agriculture',
        'rating': 4.8,
        'location': 'Lagos, Nigeria',
        'products': 120,
        'imageUrl': '',
      },
      {
        'id': '2',
        'name': 'Tech Solutions Hub',
        'category': 'Technology',
        'rating': 4.6,
        'location': 'Abuja, Nigeria',
        'products': 85,
        'imageUrl': '',
      },
      {
        'id': '3',
        'name': 'Fashion World',
        'category': 'Fashion',
        'rating': 4.9,
        'location': 'Port Harcourt, Nigeria',
        'products': 200,
        'imageUrl': '',
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: availableVendors.length,
      itemBuilder: (context, index) {
        final vendor = availableVendors[index];
        return _buildVendorCard(vendor, isConnected: false);
      },
    );
  }

  Widget _buildVendorCard(Map<String, dynamic> vendor, {required bool isConnected}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Vendor logo/avatar
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: vendor['imageUrl'] != null && vendor['imageUrl'].isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          vendor['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.store,
                              color: AppColors.grey500,
                              size: 30.sp,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.store,
                        color: AppColors.grey500,
                        size: 30.sp,
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vendor['name'],
                      style: TextStyle(
                        fontFamily: FontConstants.montserratSemiBold,
                        fontSize: 16.sp,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vendor['category'],
                      style: TextStyle(
                        fontFamily: FontConstants.montserratMedium,
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.grey500,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          vendor['location'],
                          style: TextStyle(
                            fontFamily: FontConstants.montserratRegular,
                            fontSize: 12.sp,
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isConnected)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Connected",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratMedium,
                      fontSize: 10.sp,
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Vendor stats
          Row(
            children: [
              Expanded(
                child: _buildVendorStat("Rating", "${vendor['rating']}", Icons.star, Colors.amber),
              ),
              Expanded(
                child: _buildVendorStat("Products", "${vendor['products']}", Icons.inventory_2, Colors.blue),
              ),
              if (!isConnected)
                Expanded(
                  child: Consumer<VendorProvider>(
                    builder: (context, vendorProvider, child) {
                      return GeneralButton(
                        onPressed: vendorProvider.connectingWithVendor
                            ? null
                            : () => _connectWithVendor(vendor['id'], vendorProvider),
                        child: vendorProvider.connectingWithVendor
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "Connect",
                                style: TextStyle(
                                  fontFamily: FontConstants.montserratSemiBold,
                                  fontSize: 12.sp,
                                  color: AppColors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
            ],
          ),
          
          if (isConnected) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewVendorProducts(vendor['id']),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "View Products",
                      style: TextStyle(
                        fontFamily: FontConstants.montserratMedium,
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _sendMessage(vendor['id']),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.grey400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Message",
                      style: TextStyle(
                        fontFamily: FontConstants.montserratMedium,
                        fontSize: 12.sp,
                        color: AppColors.grey700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVendorStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(width: 4.w),
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
        SizedBox(height: 2.h),
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

  Widget _buildEmptyState(String title, String description, IconData icon) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80.sp,
              color: AppColors.grey400,
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontFamily: FontConstants.montserratSemiBold,
                fontSize: 18.sp,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 14.sp,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _connectWithVendor(String vendorId, VendorProvider provider) async {
    final success = await provider.connectWithVendor(
      context: context,
      vendorId: vendorId,
    );

    if (success) {
      // Refresh connected vendors list
      provider.getConnectedVendors(context: context);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.resMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.resMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewVendorProducts(String vendorId) {
    // Navigate to vendor products screen
    // context.push('/vendor-products/$vendorId');
  }

  void _sendMessage(String vendorId) {
    // Navigate to chat/messaging screen
    // context.push('/chat/$vendorId');
  }
}
