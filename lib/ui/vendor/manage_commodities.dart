import 'dart:io';

import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/consumer_home.dart';
import 'package:brill_prime/ui/widgets/commodity_card.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/custom_selection_button_widget.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'add_new_commodity.dart';

class ManageCommoditiesScreen extends StatelessWidget {
  const ManageCommoditiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
          Consumer3<TollGateProvider, AuthProvider, VendorProvider>(builder:
              (ctx, tollGateProvider, authProvider, vendorProvider, child) {
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
                                height: 32,
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
                                            isActive:
                                                authProvider.selectedCategory ==
                                                    null,
                                            onTap: () {
                                              authProvider
                                                  .updateSelectedCategory(null);
                                            },
                                          ),
                                        );
                                      }
                                      final subCategory =
                                          authProvider.categories[index - 1];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: CustomSelectionButtonWidget(
                                          title: subCategory.name,
                                          isActive:
                                              authProvider.selectedCategory ==
                                                  subCategory,
                                          onTap: () {
                                            authProvider.updateSelectedCategory(
                                                subCategory);
                                          },
                                        ),
                                      );
                                    }),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          );
                        }),
                      ),
                      Consumer<VendorProvider>(
                          builder: (ctx, vendorProvider, child) {
                        return Expanded(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding.w),
                          child: vendorProvider.vendorCommodities.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
                                  child: const BodyTextPrimaryWithLineHeight(
                                    text: "No Commodity yet",
                                    textColor: black,
                                    fontWeight: semiBoldFont,
                                    fontSize: 20,
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      vendorProvider.vendorCommodities.length,
                                  itemBuilder: (context, index) {
                                    final commodity =
                                        vendorProvider.vendorCommodities[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: VendorCommodityCard(
                                        commodityData: commodity,
                                      ),
                                    );
                                  }),
                        ));
                      }),
                    ],
                  )),
            if (!authProvider.gettingCategories &&
                !vendorProvider.gettingVendorCommodities)
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: ActionButton(
                        icon: addIcon,
                        title: "Add New Commodities",
                        bgColor: deepBlueColor,
                        onTap: () {
                          navToWithScreenName(
                              context: context,
                              screen: const AddNewCommodityScreen());
                        }),
                  ))
                ],
              ),
            SizedBox(
              height: Platform.isAndroid ? 10 : 0,
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
