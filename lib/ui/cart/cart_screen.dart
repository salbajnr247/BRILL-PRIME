import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/components.dart';
import '../../widgets/cached_network_image_widget.dart';

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

          if (cartProvider.items.isEmpty && cartProvider.savedItems.isEmpty) {
            return _buildEmptyCart();
          }

          return _buildCartContent(cartProvider);
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.w,
            color: AppColors.greyColor,
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          CustomText(
            text: 'Your cart is empty',
            fontSize: AppFontSize.s18,
            fontWeight: FontWeight.w600,
            color: AppColors.greyColor,
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          CustomText(
            text: 'Add items to get started',
            fontSize: AppFontSize.s14,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartProvider cartProvider) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: 'Cart (${cartProvider.items.length})',
              ),
              Tab(
                text: 'Saved (${cartProvider.savedItems.length})',
              ),
            ],
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.greyColor,
            indicatorColor: AppColors.primaryColor,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildCartTab(cartProvider),
                _buildSavedTab(cartProvider),
              ],
            ),
          ),
          if (cartProvider.items.isNotEmpty) _buildCartSummary(cartProvider),
        ],
      ),
    );
  }

  Widget _buildCartTab(CartProvider cartProvider) {
    if (cartProvider.items.isEmpty) {
      return _buildEmptyCartTab();
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: cartProvider.items.length,
      itemBuilder: (context, index) {
        final item = cartProvider.items[index];
        return _buildCartItem(item, cartProvider);
      },
    );
  }

  Widget _buildSavedTab(CartProvider cartProvider) {
    if (cartProvider.savedItems.isEmpty) {
      return _buildEmptySavedTab();
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      itemCount: cartProvider.savedItems.length,
      itemBuilder: (context, index) {
        final item = cartProvider.savedItems[index];
        return _buildSavedItem(item, cartProvider);
      },
    );
  }

  Widget _buildEmptyCartTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.w,
            color: AppColors.greyColor,
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          CustomText(
            text: 'Your cart is empty',
            fontSize: AppFontSize.s18,
            fontWeight: FontWeight.w600,
            color: AppColors.greyColor,
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          CustomText(
            text: 'Add items to get started',
            fontSize: AppFontSize.s14,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySavedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 80.w,
            color: AppColors.greyColor,
          ),
          SizedBox(height: AppDimensions.paddingMedium),
          CustomText(
            text: 'No saved items',
            fontSize: AppFontSize.s18,
            fontWeight: FontWeight.w600,
            color: AppColors.greyColor,
          ),
          SizedBox(height: AppDimensions.paddingSmall),
          CustomText(
            text: 'Items you save for later will appear here',
            fontSize: AppFontSize.s14,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImageWidget(
                    imageUrl: item.image,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: item.name,
                        fontSize: AppFontSize.s16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: AppDimensions.paddingSmall),
                      CustomText(
                        text: 'Vendor: ${item.vendorName}',
                        fontSize: AppFontSize.s14,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(height: AppDimensions.paddingSmall),
                      CustomText(
                        text: '₦${item.price.toStringAsFixed(2)}',
                        fontSize: AppFontSize.s16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => cartProvider.decreaseQuantity(item.commodityId),
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.greyColor),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 20.w,
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimensions.paddingSmall),
                        CustomText(
                          text: '${item.quantity}',
                          fontSize: AppFontSize.s16,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(width: AppDimensions.paddingSmall),
                        GestureDetector(
                          onTap: () => cartProvider.increaseQuantity(item.commodityId),
                          child: Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Total: ₦${item.totalPrice.toStringAsFixed(2)}',
                  fontSize: AppFontSize.s16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => cartProvider.saveForLater(item.commodityId),
                      icon: Icon(Icons.bookmark_outline, size: 16.w),
                      label: Text('Save for later'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        textStyle: TextStyle(fontSize: AppFontSize.s12),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => cartProvider.removeItem(item.commodityId),
                      icon: Icon(Icons.delete_outline, size: 16.w),
                      label: Text('Remove'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        textStyle: TextStyle(fontSize: AppFontSize.s12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedItem(CartItem item, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImageWidget(
                    imageUrl: item.image,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: item.name,
                        fontSize: AppFontSize.s16,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: AppDimensions.paddingSmall),
                      CustomText(
                        text: 'Vendor: ${item.vendorName}',
                        fontSize: AppFontSize.s14,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(height: AppDimensions.paddingSmall),
                      CustomText(
                        text: '₦${item.price.toStringAsFixed(2)}',
                        fontSize: AppFontSize.s16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.bookmark,
                  color: AppColors.primaryColor,
                  size: 24.w,
                ),
              ],
            ),
            SizedBox(height: AppDimensions.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Saved ${item.quantity} item(s)',
                  fontSize: AppFontSize.s14,
                  color: AppColors.greyColor,
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => cartProvider.moveToCart(item.commodityId),
                      icon: Icon(Icons.shopping_cart_outlined, size: 16.w),
                      label: Text('Move to Cart'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryColor,
                        textStyle: TextStyle(fontSize: AppFontSize.s12),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => cartProvider.removeSavedItem(item.commodityId),
                      icon: Icon(Icons.delete_outline, size: 16.w),
                      label: Text('Remove'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        textStyle: TextStyle(fontSize: AppFontSize.s12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartProvider cartProvider) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.greyColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'Total (${cartProvider.itemCount} items)',
                fontSize: AppFontSize.s16,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: '₦${cartProvider.totalAmount.toStringAsFixed(2)}',
                fontSize: AppFontSize.s18,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          if (cartProvider.vendorCount > 1) ...[
            SizedBox(height: AppDimensions.paddingSmall),
            CustomText(
              text: 'Items from ${cartProvider.vendorCount} vendors',
              fontSize: AppFontSize.s12,
              color: AppColors.greyColor,
            ),
          ],
          SizedBox(height: AppDimensions.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _handleCheckout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: CustomText(
                text: 'Proceed to Checkout',
                fontSize: AppFontSize.s16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.isLoggedIn) {
      // User is logged in, proceed to checkout
      Navigator.pushNamed(context, '/checkout');
    } else {
      // Show guest checkout dialog
      showDialog(
        context: context,
        builder: (context) => const GuestCheckoutDialog(),
      );
    }
  }
}

class GuestCheckoutDialog extends StatelessWidget {
  const GuestCheckoutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Guest Checkout'),
      content: const Text('Continue as a guest?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/checkout');
          },
          child: const Text('Continue as Guest'),
        ),
      ],
    );
  }
}