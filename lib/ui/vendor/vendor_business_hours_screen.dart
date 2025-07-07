
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/components.dart';

class VendorBusinessHoursScreen extends StatefulWidget {
  const VendorBusinessHoursScreen({super.key});

  @override
  State<VendorBusinessHoursScreen> createState() => _VendorBusinessHoursScreenState();
}

class _VendorBusinessHoursScreenState extends State<VendorBusinessHoursScreen> {
  Map<String, Map<String, dynamic>> businessHours = {
    'Monday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '18:00'},
    'Tuesday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '18:00'},
    'Wednesday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '18:00'},
    'Thursday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '18:00'},
    'Friday': {'isOpen': true, 'openTime': '09:00', 'closeTime': '18:00'},
    'Saturday': {'isOpen': true, 'openTime': '10:00', 'closeTime': '16:00'},
    'Sunday': {'isOpen': false, 'openTime': '09:00', 'closeTime': '18:00'},
  };

  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Business Hours",
        showBackArrow: true,
      ),
      body: Column(
        children: [
          // Current Status
          _buildCurrentStatus(),
          
          // Business Hours List
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                Text(
                  "Set Your Business Hours",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratSemiBold,
                    fontSize: 18.sp,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 16.h),
                ...businessHours.entries.map((entry) => 
                  _buildDayCard(entry.key, entry.value)),
                SizedBox(height: 24.h),
                _buildQuickSetButtons(),
              ],
            ),
          ),
          
          // Save Button
          if (_hasChanges) _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildCurrentStatus() {
    final today = DateTime.now().weekday;
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final todayName = dayNames[today - 1];
    final todayHours = businessHours[todayName]!;
    final isOpen = _isCurrentlyOpen(todayHours);

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOpen 
            ? [Colors.green, Colors.green.withOpacity(0.8)]
            : [Colors.red, Colors.red.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            isOpen ? Icons.store : Icons.store_mall_directory_outlined,
            color: AppColors.white,
            size: 32.sp,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOpen ? "Open Now" : "Closed",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratBold,
                    fontSize: 20.sp,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  todayHours['isOpen'] 
                    ? "Today: ${todayHours['openTime']} - ${todayHours['closeTime']}"
                    : "Closed today",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 14.sp,
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(String day, Map<String, dynamic> hours) {
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
          // Day name
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: TextStyle(
                fontFamily: FontConstants.montserratSemiBold,
                fontSize: 16.sp,
                color: AppColors.black,
              ),
            ),
          ),
          
          // Open/Closed toggle
          Expanded(
            flex: 2,
            child: Switch(
              value: hours['isOpen'],
              onChanged: (value) {
                setState(() {
                  hours['isOpen'] = value;
                  _hasChanges = true;
                });
              },
              activeColor: AppColors.primary,
            ),
          ),
          
          // Time pickers
          if (hours['isOpen']) ...[
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _selectTime(day, 'openTime'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    hours['openTime'],
                    style: TextStyle(
                      fontFamily: FontConstants.montserratMedium,
                      fontSize: 14.sp,
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
                onTap: () => _selectTime(day, 'closeTime'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    hours['closeTime'],
                    style: TextStyle(
                      fontFamily: FontConstants.montserratMedium,
                      fontSize: 14.sp,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ] else
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  "Closed",
                  style: TextStyle(
                    fontFamily: FontConstants.montserratMedium,
                    fontSize: 14.sp,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickSetButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Setup",
          style: TextStyle(
            fontFamily: FontConstants.montserratSemiBold,
            fontSize: 16.sp,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickSetButton(
                "Standard Hours",
                "9 AM - 6 PM",
                () => _setStandardHours(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildQuickSetButton(
                "24/7 Open",
                "Always Open",
                () => _set24Hours(),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickSetButton(
                "Weekdays Only",
                "Mon - Fri",
                () => _setWeekdaysOnly(),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildQuickSetButton(
                "Weekend Closed",
                "Close Sat & Sun",
                () => _setWeekendClosed(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickSetButton(String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: FontConstants.montserratSemiBold,
                fontSize: 12.sp,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: FontConstants.montserratRegular,
                fontSize: 10.sp,
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          return CustomButton(
            title: "Save Business Hours",
            onTap: () => _saveBusinessHours(vendorProvider),
            loading: vendorProvider.updatingBusinessHours,
          );
        },
      ),
    );
  }

  void _selectTime(String day, String timeType) async {
    final currentTime = businessHours[day]![timeType];
    final timeParts = currentTime.split(':');
    final currentTimeOfDay = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTimeOfDay,
    );

    if (picked != null) {
      setState(() {
        businessHours[day]![timeType] = 
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        _hasChanges = true;
      });
    }
  }

  void _setStandardHours() {
    setState(() {
      for (String day in businessHours.keys) {
        businessHours[day]!['isOpen'] = true;
        businessHours[day]!['openTime'] = '09:00';
        businessHours[day]!['closeTime'] = '18:00';
      }
      _hasChanges = true;
    });
  }

  void _set24Hours() {
    setState(() {
      for (String day in businessHours.keys) {
        businessHours[day]!['isOpen'] = true;
        businessHours[day]!['openTime'] = '00:00';
        businessHours[day]!['closeTime'] = '23:59';
      }
      _hasChanges = true;
    });
  }

  void _setWeekdaysOnly() {
    setState(() {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
      for (String day in businessHours.keys) {
        businessHours[day]!['isOpen'] = weekdays.contains(day);
        if (weekdays.contains(day)) {
          businessHours[day]!['openTime'] = '09:00';
          businessHours[day]!['closeTime'] = '18:00';
        }
      }
      _hasChanges = true;
    });
  }

  void _setWeekendClosed() {
    setState(() {
      businessHours['Saturday']!['isOpen'] = false;
      businessHours['Sunday']!['isOpen'] = false;
      _hasChanges = true;
    });
  }

  bool _isCurrentlyOpen(Map<String, dynamic> todayHours) {
    if (!todayHours['isOpen']) return false;
    
    final now = TimeOfDay.now();
    final openParts = todayHours['openTime'].split(':');
    final closeParts = todayHours['closeTime'].split(':');
    
    final openTime = TimeOfDay(
      hour: int.parse(openParts[0]),
      minute: int.parse(openParts[1]),
    );
    final closeTime = TimeOfDay(
      hour: int.parse(closeParts[0]),
      minute: int.parse(closeParts[1]),
    );
    
    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;
    
    return nowMinutes >= openMinutes && nowMinutes <= closeMinutes;
  }

  void _saveBusinessHours(VendorProvider provider) async {
    final success = await provider.updateBusinessHours(
      context: context,
      hoursData: businessHours,
    );
    
    if (success) {
      setState(() {
        _hasChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Business hours updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
