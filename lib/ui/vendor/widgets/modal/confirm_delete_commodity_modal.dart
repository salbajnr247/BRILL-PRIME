import 'dart:io';

import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../resources/constants/color_constants.dart';
import '../../../../../resources/constants/dimension_constants.dart';
import '../../../../../resources/constants/font_constants.dart';
import '../../../../models/commodities_model.dart';
import '../../../Widgets/custom_text.dart';
import '../../../widgets/components.dart';

Future showConfirmDeleteCommodityModal(BuildContext importedContext,
    {required CommodityData commodity}) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: importedContext,
    isDismissible: false,
    backgroundColor: white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(modalRadius.r),
          topRight: Radius.circular(modalRadius.r)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(modalRadius.r),
                  topRight: Radius.circular(modalRadius.r)),
            ),
            child:
                Consumer2<VendorProvider, AuthProvider>(builder: (ctx, vendorProvider, authProvider, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 40),
                        const BodyTextPrimaryWithLineHeight(
                          text: "Are you sure?",
                          fontWeight: extraBoldFont,
                          fontSize: 20,
                          textColor: Color.fromRGBO(1, 14, 66, 1),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const BodyTextPrimaryWithLineHeight(
                          text:
                              "This action will delete the commodity permanently",
                          textColor: black,
                          fontSize: 15,
                          alignCenter: true,
                        ),
                        const SizedBox(
                          height: 28,
                        ),

                        if(!vendorProvider.deletingCommodity)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: MainButton("No, Cancel", fontSize: 14,
                                    () async {
                                  Navigator.pop(context);
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Expanded(
                                  child: vendorProvider.deletingCommodity ? const CupertinoActivityIndicator() :  OutlineBtn(
                                "Yes, Delete",
                                () async{
                                  bool deleted = await vendorProvider.deleteCommodity(context: importedContext, commodityId: commodity.id);
                                  if(deleted){
                                    vendorProvider.getVendorCommodities(context: importedContext, vendorId: authProvider
                                        .userProfile?.data.id ??
                                        "");
                                  }
                                  Navigator.pop(context);
                                },
                                textColor: black,
                              )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Platform.isAndroid ? topPadding.h : 0,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            })),
      );
    },
  );
}
