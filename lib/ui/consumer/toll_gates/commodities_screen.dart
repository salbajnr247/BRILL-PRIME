import 'dart:io';

import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/consumer_home.dart';
import 'package:brill_prime/ui/consumer/toll_gates/toll_carts_screen.dart';
import 'package:brill_prime/ui/widgets/commodity_card.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/custom_selection_button_widget.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_snack_back.dart';

class CommoditiesScreen extends StatelessWidget {
  const CommoditiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer2<TollGateProvider, AuthProvider>(
          builder: (ctx, tollGateProvider, authProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (tollGateProvider.resMessage != '') {
            customSnackBar(context, tollGateProvider.resMessage,
                isError: tollGateProvider.isError);

            ///Clear the response message to avoid duplicate
            tollGateProvider.clear();
          }
        });
        return Column(
          children: [
            const CustomAppbar(title: ""),
            const SizedBox(
              height: 20,
            ),
            const BodyTextPrimaryWithLineHeight(
              text: commodities,
              textColor: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            authProvider.gettingCategories
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.35),
                      child: const CupertinoActivityIndicator(),
                    ),
                  )
                : Expanded(
                    child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding.w),
                        child: Consumer<TollGateProvider>(
                            builder: (ctx, tollGateProvider, child) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 30,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        authProvider.categories.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: CustomSelectionButtonWidget(
                                            title: all,
                                            isActive: tollGateProvider
                                                    .selectedSubCategory ==
                                                null,
                                            onTap: () {
                                              tollGateProvider
                                                  .updateSelectedSubCategory(
                                                      null);
                                            },
                                          ),
                                        );
                                      } else {
                                        final category =
                                            authProvider.categories[index - 1];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: CustomSelectionButtonWidget(
                                            title: category.name,
                                            isActive: tollGateProvider
                                                    .selectedSubCategory ==
                                                category,
                                            onTap: () {
                                              tollGateProvider
                                                  .updateSelectedSubCategory(
                                                      category);
                                            },
                                          ),
                                        );
                                      }
                                    }),
                              ),
                              // Row(
                              //   children: [
                              //     ,
                              //     const SizedBox(
                              //       width: 10,
                              //     ),
                              //     CustomSelectionButtonWidget(
                              //       title: toll,
                              //       isActive: tollGateProvider.selectedCommodity == toll,
                              //       onTap: () {
                              //         tollGateProvider.updateSelectedCommodity(toll);
                              //       },
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        }),
                      ),
                      Consumer<TollGateProvider>(
                          builder: (ctx, tollGateProvider, child) {
                        return Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding.w),
                          child: ListView.builder(
                              itemCount: tollGateProvider.commodities.length,
                              itemBuilder: (context, index) {
                                final commodity =
                                    tollGateProvider.commodities[index];
                                debugPrint(
                                    "Selected vendor ID:::: ${tollGateProvider.selectedVendor?.userId} Vendor ID ${commodity.vendorId}");
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: commodity.vendorId !=
                                          tollGateProvider
                                              .selectedVendor?.userId
                                      ? Container()
                                      : CommodityCard(
                                          commodity: commodity,
                                        ),
                                );
                              }),
                        ));
                      }),
                    ],
                  )),
            if (!authProvider.gettingCategories &&
                authProvider.categories.isNotEmpty)
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: ActionButton(
                        icon: viewCartIcon,
                        title: viewCarts,
                        isNetworkImage: false,
                        bgColor: deepBlueColor,
                        onTap: () {
                          tollGateProvider.getCartDetails(context: context);
                          navToWithScreenName(
                              context: context,
                              screen: const TollGateCartsScreen());
                        }),
                  ))
                ],
              ),
            SizedBox(
              height: Platform.isAndroid ? 40 : 0,
            ),
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
