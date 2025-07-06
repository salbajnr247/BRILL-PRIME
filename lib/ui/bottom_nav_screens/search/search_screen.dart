import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/dimension_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../../resources/constants/image_constant.dart';
import '../../Widgets/title_widget.dart';
import '../../widgets/components.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/textfields.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  final ScrollController canineScrollController = ScrollController();
  final ScrollController clinicScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    setState(() {});
  }

  @override
  void dispose() {
    canineScrollController.dispose();
    clinicScrollController.dispose();
    super.dispose();
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
                const TitleWidget(
                  title: "Search",
                  fontSize: 18,
                  fontWeight: mediumFont,
                  textColor: blackTextColor,
                ),
                SizedBox(
                  height: 16.h,
                ),
                CustomContainerButton(
                  onTap: () {},
                  title: "",
                  borderRadius: 18,
                  horizontalPadding: 16,
                  verticalPadding: 8,
                  bgColor: const Color(0xFFF9F9F9),
                  widget: Row(
                    children: [
                      SvgPicture.asset(searchIconSvg),
                      Expanded(
                          child: CustomField(
                        "Search ",
                        searchController,
                        hasBorder: false,
                        fillColor: const Color(0xFFF9F9F9),
                        bgColor: const Color(0xFFF9F9F9),
                        onChange: (value) {},
                      )),
                      InkWell(
                        onTap: () {},
                        child: SvgPicture.asset(filterIcon),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    CustomContainerButton(
                      onTap: () {},
                      title: "",
                      horizontalPadding: 12,
                      borderRadius: 100,
                      fontSize: 13,
                      textColor: blackTextColor,
                      fontWeight: semiBoldFont,
                      bgColor: white,
                      verticalPadding: 8,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    CustomContainerButton(
                      onTap: () {},
                      title: "",
                      horizontalPadding: 12,
                      borderRadius: 100,
                      fontSize: 13,
                      textColor: blackTextColor,
                      fontWeight: semiBoldFont,
                      bgColor: white,
                      verticalPadding: 8,
                    ),
                  ],
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
