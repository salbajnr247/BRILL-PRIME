
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../providers/cart_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_text.dart';
import '../widgets/cached_network_image_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Shopping Cart',
        showBackButton: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartProvider.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(DimensionConstants.d16.w),
                  itemCount: cartProvider.itemsByVendor.length,
                  itemBuilder: (context, index) {
                    final vendorId = cartProvider.itemsByVendor.keys.elementAt(index);
                    final vendorItems = cartProvider.itemsByVendor[vendorId]!;
                    
                    return _buildVendorSection(
                      context,
                      vendorItems.first.vendorName,
                      vendorItems,
                      cartProvider,
                    );
                  },
                ),
              ),
              _buildBottomSection(context, cartProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.w,
            color: Colors.grey[400],
          ),
          SizedBox(height: DimensionConstants.d16.h),
          CustomText(
            'Your cart is empty',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: DimensionConstants.d8.h),
          CustomText(
            'Add items to get started',
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          SizedBox(height: DimensionConstants.d24.h),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: DimensionConstants.d32.w,
                vertical: DimensionConstants.d12.h,
              ),
            ),
            child: CustomText(
              'Continue Shopping',
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorSection(
    BuildContext context,
    String vendorName,
    List<dynamic> items,
    CartProvider cartProvider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: DimensionConstants.d16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DimensionConstants.d12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(DimensionConstants.d16.w),
            child: Row(
              children: [
                Icon(
                  Icons.store,
                  size: 20.w,
                  color: ColorConstants.primaryColor,
                ),
                SizedBox(width: DimensionConstants.d8.w),
                Expanded(
                  child: CustomText(
                    vendorName,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () => cartProvider.clearVendorItems(items.first.vendorId),
                  child: CustomText(
                    'Clear All',
                    color: Colors.red,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => _buildCartItem(context, item, cartProvider)).toList(),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, dynamic item, CartProvider cartProvider) {
    return Padding(
      padding: EdgeInsets.all(DimensionConstants.d16.w),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
            child: CachedNetworkImageWidget(
              imageUrl: item.image,
              height: 60.h,
              width: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: DimensionConstants.d12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  item.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  maxLines: 2,
                ),
                SizedBox(height: DimensionConstants.d4.h),
                CustomText(
                  '₦${item.price.toStringAsFixed(2)}',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorConstants.primaryColor,
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => cartProvider.decreaseQuantity(item.commodityId),
                    icon: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(Icons.remove, size: 16.w),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: DimensionConstants.d12.w),
                    child: CustomText(
                      '${item.quantity}',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => cartProvider.increaseQuantity(item.commodityId),
                    icon: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: ColorConstants.primaryColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(Icons.add, size: 16.w, color: Colors.white),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => cartProvider.saveForLater(item.commodityId),
                child: CustomText(
                  'Save for later',
                  fontSize: 12.sp,
                  color: ColorConstants.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(DimensionConstants.d16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'Total (${cartProvider.itemCount} items)',
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
              CustomText(
                '₦${cartProvider.totalAmount.toStringAsFixed(2)}',
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: ColorConstants.primaryColor,
              ),
            ],
          ),
          SizedBox(height: DimensionConstants.d16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to checkout
                // Navigator.pushNamed(context, '/checkout');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.primaryColor,
                padding: EdgeInsets.symmetric(vertical: DimensionConstants.d16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DimensionConstants.d8.r),
                ),
              ),
              child: CustomText(
                'Proceed to Checkout',
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
