import 'dart:io';

import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/sign_up_option/sign_up_option_screen.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/image_constant.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final PageController _controller = PageController(initialPage: 0);

  List<OnboardingModel> onBoardingItems = [
    OnboardingModel(
        title: welcomeToBrillPrime,
        img: onBoarding1,
        subText: getStartedWithBrillPrime),
    OnboardingModel(
        title: unlockThePowerOf, img: onBoarding2, subText: tapPayAndGo),
    OnboardingModel(
        title: yourEasyPayment,
        img: onBoarding3,
        subText: startYourFinancialJourney),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBgColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = _controller.page?.round() ?? 0;
                      debugPrint("The current index is::::::$currentIndex");
                    });
                  },
                  children: onBoardingItems
                      .map((item) => OnBoardingItem(item: item))
                      .toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        DotedIcon(isActive: currentIndex == 0),
                        const SizedBox(
                          width: 5,
                        ),
                        DotedIcon(isActive: currentIndex == 1),
                        const SizedBox(
                          width: 5,
                        ),
                        DotedIcon(isActive: currentIndex == 2),
                      ],
                    ),
                    currentIndex < onBoardingItems.length - 1
                        ? InkWell(
                            onTap: () {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut, // Use a specific curve
                              );
                            },
                            child: Container(
                              height: 67,
                              width: 67,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(100)),
                              child: SvgPicture.asset(arrowForwardWhite),
                            ),
                          )
                        : SizedBox(
                            width: 150,
                            child: MainButton(getStarted, () {
                              navToWithScreenName(
                                  context: context,
                                  screen: const SignUpOptionScreen(),
                                  isReplacement: true);
                            }))
                  ],
                ),
              ),
              SizedBox(
                height: Platform.isAndroid ? 10 : 0,
              ),
            ],
          ),
        ));
  }
}

class OnBoardingItem extends StatelessWidget {
  final OnboardingModel item;
  const OnBoardingItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: Image.asset(item.img),
          ),
          const SizedBox(
            height: 50,
          ),
          BodyTextPrimaryWithLineHeight(
            text: item.title,
            alignCenter: true,
            fontSize: 20,
            fontWeight: extraBoldFont,
            textColor: const Color.fromRGBO(1, 14, 66, 1),
          ),
          const SizedBox(
            height: 30,
          ),
          BodyTextPrimaryWithLineHeight(
            text: item.subText,
            alignCenter: true,
            textColor: const Color.fromRGBO(0, 0, 0, 1),
            fontWeight: thinFont,
          )
        ],
      ),
    );
  }
}

class OnboardingModel {
  final String img;
  final String title;
  final String subText;

  OnboardingModel({
    required this.title,
    required this.img,
    required this.subText,
  });
}

class DotedIcon extends StatelessWidget {
  final bool isActive;
  const DotedIcon({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(101, 117, 255, 1)
              : const Color.fromRGBO(217, 217, 217, 1),
          shape: BoxShape.circle),
    );
  }
}
