import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_appbar.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
          child: Column(
        children: [
          const TopPadding(),
          const CustomAppbar(
            title: "Requests",
            showArrowBack: false,
          ),
          SizedBox(
            height: 24.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
            child: Row(
              children: [
                SizedBox(
                  width: 8.w,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 28.h,
          ),
        ],
      )),
    );
  }
}
