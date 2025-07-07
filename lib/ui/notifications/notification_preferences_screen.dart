
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/loading_indicator.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  late NotificationPreferences _preferences;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    _preferences = provider.preferences;
  }

  void _updatePreference(String key, bool value) {
    setState(() {
      _hasChanges = true;
      switch (key) {
        case 'orderUpdates':
          _preferences = _preferences.copyWith(orderUpdates: value);
          break;
        case 'promotions':
          _preferences = _preferences.copyWith(promotions: value);
          break;
        case 'newProducts':
          _preferences = _preferences.copyWith(newProducts: value);
          break;
        case 'priceAlerts':
          _preferences = _preferences.copyWith(priceAlerts: value);
          break;
        case 'vendorUpdates':
          _preferences = _preferences.copyWith(vendorUpdates: value);
          break;
        case 'reviewResponses':
          _preferences = _preferences.copyWith(reviewResponses: value);
          break;
        case 'systemUpdates':
          _preferences = _preferences.copyWith(systemUpdates: value);
          break;
      }
    });
  }

  void _updateTypePreference(NotificationType type, bool value) {
    setState(() {
      _hasChanges = true;
      final newTypePrefs = Map<NotificationType, bool>.from(_preferences.typePreferences);
      newTypePrefs[type] = value;
      _preferences = _preferences.copyWith(typePreferences: newTypePrefs);
    });
  }

  Future<void> _savePreferences() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    final success = await provider.updatePreferences(
      context: context,
      newPreferences: _preferences,
    );

    if (success) {
      setState(() {
        _hasChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Notification Preferences",
        showBackArrow: true,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _savePreferences,
              child: Text(
                "Save",
                style: TextStyle(
                  fontFamily: FontConstants.montserratSemiBold,
                  fontSize: 16.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.loading) {
            return const Center(child: LoadingIndicator());
          }

          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // Notification Types Section
              _buildSectionHeader("Notification Types"),
              SizedBox(height: 8.h),
              _buildTypePreferenceCard("Push Notifications", NotificationType.push, Icons.notifications),
              _buildTypePreferenceCard("In-App Notifications", NotificationType.inApp, Icons.app_blocking),
              _buildTypePreferenceCard("Email Notifications", NotificationType.email, Icons.email),
              
              SizedBox(height: 24.h),
              
              // Content Preferences Section
              _buildSectionHeader("Content Preferences"),
              SizedBox(height: 8.h),
              _buildPreferenceCard(
                "Order Updates",
                "Notifications about your orders",
                Icons.shopping_bag,
                _preferences.orderUpdates,
                (value) => _updatePreference('orderUpdates', value),
              ),
              _buildPreferenceCard(
                "Promotions & Offers",
                "Special deals and discounts",
                Icons.local_offer,
                _preferences.promotions,
                (value) => _updatePreference('promotions', value),
              ),
              _buildPreferenceCard(
                "New Products",
                "When new products are available",
                Icons.new_releases,
                _preferences.newProducts,
                (value) => _updatePreference('newProducts', value),
              ),
              _buildPreferenceCard(
                "Price Alerts",
                "When prices change on watched items",
                Icons.trending_down,
                _preferences.priceAlerts,
                (value) => _updatePreference('priceAlerts', value),
              ),
              _buildPreferenceCard(
                "Vendor Updates",
                "Updates from your favorite vendors",
                Icons.store,
                _preferences.vendorUpdates,
                (value) => _updatePreference('vendorUpdates', value),
              ),
              _buildPreferenceCard(
                "Review Responses",
                "When vendors respond to your reviews",
                Icons.rate_review,
                _preferences.reviewResponses,
                (value) => _updatePreference('reviewResponses', value),
              ),
              _buildPreferenceCard(
                "System Updates",
                "App updates and important announcements",
                Icons.system_update,
                _preferences.systemUpdates,
                (value) => _updatePreference('systemUpdates', value),
              ),

              SizedBox(height: 24.h),

              // Test Notifications Section
              _buildSectionHeader("Test Notifications"),
              SizedBox(height: 8.h),
              _buildTestNotificationCards(provider),

              SizedBox(height: 32.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: FontConstants.montserratSemiBold,
        fontSize: 18.sp,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildTypePreferenceCard(String title, NotificationType type, IconData icon) {
    final isEnabled = _preferences.typePreferences[type] ?? true;
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isEnabled ? AppColors.primary.withOpacity(0.1) : AppColors.grey200,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: isEnabled ? AppColors.primary : AppColors.grey500,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 16.sp,
                color: AppColors.black,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => _updateTypePreference(type, value),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceCard(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: value ? AppColors.primary.withOpacity(0.1) : AppColors.grey200,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: value ? AppColors.primary : AppColors.grey500,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratRegular,
                    fontSize: 12.sp,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTestNotificationCards(NotificationProvider provider) {
    return Column(
      children: [
        _buildTestCard(
          "Test Push Notification",
          "Send a test push notification",
          Icons.notifications,
          () => provider.sendTestNotification(context: context, type: NotificationType.push),
        ),
        _buildTestCard(
          "Test Email Notification",
          "Send a test email notification",
          Icons.email,
          () => provider.sendTestNotification(context: context, type: NotificationType.email),
        ),
      ],
    );
  }

  Widget _buildTestCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: AppColors.grey300),
        ),
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.blue, size: 24.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: FontConstants.montserratMedium,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: FontConstants.montserratRegular,
            fontSize: 12.sp,
            color: AppColors.grey600,
          ),
        ),
        trailing: Icon(Icons.send, color: AppColors.blue),
        onTap: onTap,
      ),
    );
  }
}
