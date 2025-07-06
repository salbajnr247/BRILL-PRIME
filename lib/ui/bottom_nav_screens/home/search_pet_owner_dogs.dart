import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_appbar.dart';

class SearchedPerOwnerDogsScreen extends StatefulWidget {
  const SearchedPerOwnerDogsScreen({super.key});

  @override
  State<SearchedPerOwnerDogsScreen> createState() =>
      _SearchedPerOwnerDogsScreenState();
}

class _SearchedPerOwnerDogsScreenState
    extends State<SearchedPerOwnerDogsScreen> {
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopPadding(),
                const CustomAppbar(title: "NA"),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
        ],
      )),
    );
  }
}
