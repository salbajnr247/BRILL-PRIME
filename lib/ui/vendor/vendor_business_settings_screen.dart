
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/loading_indicator.dart';
import 'package:brill_prime/ui/widgets/components.dart';

class VendorBusinessSettingsScreen extends StatefulWidget {
  const VendorBusinessSettingsScreen({super.key});

  @override
  State<VendorBusinessSettingsScreen> createState() => _VendorBusinessSettingsScreenState();
}

class _VendorBusinessSettingsScreenState extends State<VendorBusinessSettingsScreen> {
  final Map<String, Map<String, String>> _businessHours = {
    'Monday': {'open': '09:00', 'close': '18:00', 'isOpen': 'true'},
    'Tuesday': {'open': '09:00', 'close': '18:00', 'isOpen': 'true'},
    'Wednesday': {'open': '09:00', 'close': '18:00', 'isOpen': 'true'},
    'Thursday': {'open': '09:00', 'close': '18:00', 'isOpen': 'true'},
    'Friday': {'open': '09:00', 'close': '18:00', 'isOpen': 'true'},
    'Saturday': {'open': '10:00', 'close': '16:00', 'isOpen': 'true'},
    'Sunday': {'open': '10:00', 'close': '16:00', 'isOpen': 'false'},
  };

  bool _autoAcceptOrders = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  
  final TextEditingController _businessDescriptionController = TextEditingController();
  final TextEditingController _deliveryRadiusController = TextEditingController();
  final TextEditingController _minimumOrderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBusinessSettings();
  }

  void _loadBusinessSettings() {
    // Load existing business settings from provider or API
    final provider = context.read<VendorProvider>();
    if (provider.businessHours != null) {
      // Load saved business hours
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Business Settings",
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Hours Section
            _buildBusinessHoursSection(),
            SizedBox(height: 24.h),

            // Business Information Section
            _buildBusinessInfoSection(),
            SizedBox(height: 24.h),

            // Order Settings Section
            _buildOrderSettingsSection(),
            SizedBox(height: 24.h),

            // Notification Settings Section
            _buildNotificationSettingsSection(),
            SizedBox(height: 24.h),

            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Business Hours",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            children: _businessHours.entries.map((entry) {
              return _buildBusinessHourRow(entry.key, entry.value);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBusinessHourRow(String day, Map<String, String> hours) {
    final isOpen = hours['isOpen'] == 'true';
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Switch(
              value: isOpen,
              onChanged: (value) {
                setState(() {
                  _businessHours[day]!['isOpen'] = value.toString();
                });
              },
              activeColor: AppColors.primary,
            ),
          ),
          if (isOpen) ...[
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _selectTime(day, 'open'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    hours['open']!,
                    style: TextStyle(
                      fontFamily: FontConstants.montserratRegular,
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "to",
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 12.sp,
                color: AppColors.grey600,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _selectTime(day, 'close'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    hours['close']!,
                    style: TextStyle(
                      fontFamily: FontConstants.montserratRegular,
                      fontSize: 12.sp,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ] else
            Expanded(
              flex: 5,
              child: Text(
                "Closed",
                style: TextStyle(
                  fontFamily: FontConstants.montserratRegular,
                  fontSize: 12.sp,
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Business Information",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Business Description
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Business Description",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _businessDescriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Describe your business...",
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
          ],
        ),
        SizedBox(height: 16.h),
        
        // Delivery Radius
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery Radius (km)",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _deliveryRadiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter delivery radius",
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
          ],
        ),
        SizedBox(height: 16.h),
        
        // Minimum Order Amount
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Minimum Order Amount (₦)",
              style: TextStyle(
                fontFamily: FontConstants.montserratMedium,
                fontSize: 14.sp,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _minimumOrderController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter minimum order amount",
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
          ],
        ),
      ],
    );
  }

  Widget _buildOrderSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Settings",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            children: [
              _buildSettingToggle(
                "Auto-accept Orders",
                "Automatically accept incoming orders",
                _autoAcceptOrders,
                (value) => setState(() => _autoAcceptOrders = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notifications",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 18.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey300),
          ),
          child: Column(
            children: [
              _buildSettingToggle(
                "Email Notifications",
                "Receive notifications via email",
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
              ),
              _buildSettingToggle(
                "Push Notifications",
                "Receive push notifications on your device",
                _pushNotifications,
                (value) => setState(() => _pushNotifications = value),
              ),
              _buildSettingToggle(
                "SMS Notifications",
                "Receive notifications via SMS",
                _smsNotifications,
                (value) => setState(() => _smsNotifications = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingToggle(String title, String description, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
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

  Widget _buildSaveButton() {
    return Consumer<VendorProvider>(
      builder: (context, vendorProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: GeneralButton(
            onPressed: vendorProvider.updatingBusinessHours
                ? null
                : _saveBusinessSettings,
            child: vendorProvider.updatingBusinessHours
                ? const LoadingIndicator()
                : Text(
                    "Save Settings",
                    style: TextStyle(
                      fontFamily: FontConstants.montserratSemiBold,
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _selectTime(String day, String timeType) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (pickedTime != null) {
      setState(() {
        _businessHours[day]![timeType] = 
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _saveBusinessSettings() async {
    final provider = context.read<VendorProvider>();
    
    final businessData = {
      'businessHours': _businessHours,
      'businessDescription': _businessDescriptionController.text,
      'deliveryRadius': _deliveryRadiusController.text,
      'minimumOrder': _minimumOrderController.text,
      'autoAcceptOrders': _autoAcceptOrders,
      'notifications': {
        'email': _emailNotifications,
        'push': _pushNotifications,
        'sms': _smsNotifications,
      },
    };

    final success = await provider.updateBusinessHours(
      context: context,
      hoursData: businessData,
    );

    if (success) {
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
}
