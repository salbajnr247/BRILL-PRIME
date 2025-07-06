import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../resources/constants/color_constants.dart';
import '../../../../resources/constants/dimension_constants.dart';
import '../../../../resources/constants/font_constants.dart';
import '../../../Widgets/custom_text.dart';
import '../../../widgets/components.dart';
import '../../../widgets/custom_snack_back.dart';

Future showOpeningHourTimeModal(BuildContext importedContext) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: importedContext,
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
                  Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (authProvider.resMessage != '') {
                    customSnackBar(context, authProvider.resMessage,
                        isError: authProvider.isErrorMessage);

                    ///Clear the response message to avoid duplicate
                    authProvider.clear();
                  }
                });
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BodyTextLightWithLineHeight(
                            text: "Select Vaccine Type",
                            textColor: blackTextColor,
                            fontSize: 23,
                            fontWeight: semiBoldFont,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(closeIconSvg)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                      child: ListView.builder(
                          itemCount: openingHoursTimeList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final time = openingHoursTimeList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CustomContainerButton(
                                onTap: () {
                                  Navigator.pop(context, time);
                                },
                                title: "",
                                bgColor: white,
                                borderColor: const Color(0xFFE6E6E6),
                                borderRadius: 11,
                                widget: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BodyTextPrimaryWithLineHeight(
                                      text: time,
                                      textColor: const Color(0xFF0C0C0C),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: bottomPadding.h,
                    ),
                  ],
                );
              })));
    },
  );
}

List<String> openingHoursTimeList = ["am", "pm"];
