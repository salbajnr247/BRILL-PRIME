import 'dart:io';

import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../resources/constants/color_constants.dart';
import '../../../../../resources/constants/dimension_constants.dart';
import '../../../../../resources/constants/font_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../Widgets/custom_text.dart';
import '../../consumer/consumer_home.dart';
import '../components.dart';

Future pinLocationModal(BuildContext importedContext) {
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
            child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.2,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset(globeImg),
                            ),
                            const SizedBox(height: 20),
                            const BodyTextPrimaryWithLineHeight(
                              text: "Where are you?",
                              fontWeight: extraBoldFont,
                              fontSize: 20,
                              textColor: Color.fromRGBO(1, 14, 66, 1),
                            ),
                            const BodyTextPrimaryWithLineHeight(
                              text:
                                  "Set your location so you can see merchants\n available around you",
                              textColor: black,
                              fontSize: 15,
                              alignCenter: true,
                            ),
                            const SizedBox(
                              height: 28,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: MainButton("Set automatically",
                                        fontSize: 14, () async {
                                      await authProvider
                                          .updateUserCurrentLocation(
                                              getPlaceNameAfter: true);
                                      final sharedPrefs =
                                          await SharedPreferences.getInstance();
                                      sharedPrefs.setBool(
                                          hashShownPinLocationModal, true);
                                      Navigator.pop(context);
                                      navToWithScreenName(
                                          context: context,
                                          screen: ConsumerHomePage(
                                            currentLocation: authProvider
                                                .userCurrentLocation!,
                                          ));
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: OutlineBtn(
                                    "Set later",
                                    () {
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
                        )),
                  ],
                ),
              );
            })),
      );
    },
  );
}
