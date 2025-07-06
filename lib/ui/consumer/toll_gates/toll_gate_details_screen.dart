import 'dart:io';

import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/consumer_home.dart';
import 'package:brill_prime/ui/consumer/toll_gates/commodities_screen.dart';
import 'package:brill_prime/ui/consumer/toll_gates/toll_carts_screen.dart';
import 'package:brill_prime/ui/vendor/vendor_home_screen.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/rating_widget.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../providers/toll_gate_provider.dart';

class TollGateDetailScreen extends StatelessWidget {
  const TollGateDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer2<TollGateProvider, AuthProvider>(
          builder: (ctx, tollGateProvider, authProvider, child) {
        return Column(
          children: [
            const CustomAppbar(title: ""),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Image.asset(coatOfArmImg),
            ),
            BodyTextPrimaryWithLineHeight(
              text: "${tollGateProvider.selectedVendor?.businessName}",
              textColor: const Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            BodyTextPrimaryWithLineHeight(
              text: "${tollGateProvider.selectedVendor?.businessCategory}",
              fontSize: 12,
              fontWeight: thinFont,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const RatingWidget(
                    rating: 4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                      text: "Seamlessly Make Toll Payment"),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Address",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: BodyTextPrimaryWithLineHeight(
                      text: "${tollGateProvider.selectedVendor?.address}",
                      alignCenter: true,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Email",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                      text: "info@tollgate.com"),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Number",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BodyTextPrimaryWithLineHeight(
                      text:
                          "${tollGateProvider.selectedVendor?.businessNumber}"),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Opening Hours",
                    fontWeight: boldFont,
                    textColor: black,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const BodyTextPrimaryWithLineHeight(text: "Always Open"),
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ActionButton(
                              icon: viewCommoditiesIcon,
                              title: viewCommodities,
                              isNetworkImage: false,
                              bgColor: mainColor,
                              onTap: () {
                                tollGateProvider.getCartDetails(
                                    context: context);
                                tollGateProvider.getCommodities(
                                    context: context,
                                    category: tollGateCategory);
                                authProvider.getCategories(
                                    context: context,
                                    isFilter: true,
                                    filter: tollGateCategory);

                                navToWithScreenName(
                                    context: context,
                                    screen: const CommoditiesScreen());
                              })),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWithCounter(
                    onTap: () {
                      tollGateProvider.getCartDetails(context: context);
                      navToWithScreenName(
                          context: context,
                          screen: const TollGateCartsScreen());
                    },
                    title: viewCarts,
                    counter: tollGateProvider.cartItems.length.toDouble(),
                    iconName: viewCartIcon,
                    bgColor: deepBlueColor,
                  ),
                  SizedBox(
                    height: Platform.isAndroid ? 10 : 0,
                  )
                ],
              ),
            )
          ],
        );
      })),
    );
  }
}

class TollGateData {
  final String name;
  final String location;
  TollGateData({required this.name, required this.location});
}
