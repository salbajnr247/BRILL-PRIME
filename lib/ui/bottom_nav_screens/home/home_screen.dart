import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../../resources/constants/image_constant.dart';
import '../../Widgets/custom_text.dart';
import '../../widgets/components.dart';
import '../../widgets/constant_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: #2 implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer2<AuthProvider, DashboardProvider>(
          builder: (ctx, authProvider, dashboardProvider, child) {
        return Column(
          children: [
            const TopPadding(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: Row(
                children: [
                  Expanded(
                    child: CustomDropdownButton(
                      title: "",
                      onTap: () {},
                      bgColor: const Color(0xFFF9F9F9),
                      borderRadius: 32,
                      borderColor: const Color(0xFFF9F9F9),
                      customWidget: Row(
                        children: [
                          SvgPicture.asset(dashboardLocationIcon),
                          SizedBox(
                            width: 8.w,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: BodyTextPrimaryWithLineHeight(
                              text: dashboardProvider.searchFilter,
                              textColor: const Color(0xFF0C0C0C),
                              fontSize: 13,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
          ],
        );
      })),
    );
  }
}

class CanineInfoItem extends StatelessWidget {
  final String icon;
  final String value;
  const CanineInfoItem({super.key, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(icon),
        BodyTextPrimaryWithLineHeight(
          text: value,
          textColor: white,
          fontSize: 10,
        ),
      ],
    );
  }
}
