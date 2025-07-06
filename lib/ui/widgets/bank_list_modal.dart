import 'package:brill_prime/providers/bank_provider.dart';
import 'package:brill_prime/ui/widgets/pull_down_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../../resources/constants/color_constants.dart';
import '../../../../../resources/constants/dimension_constants.dart';
import '../../../../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import '../../resources/constants/styles_manager.dart';
import '../Widgets/custom_text.dart';
import 'components.dart';

Future showBankListModal(BuildContext importedContext, {bool isTarget = true}) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: importedContext,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(modalRadius.r),
          topRight: Radius.circular(modalRadius.r)),
    ),
    builder: (BuildContext context) {
      final searchController = TextEditingController();
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Consumer<BankProvider>(builder: (ctx, bankProvider, child) {
            return Container(
                margin: EdgeInsets.only(bottom: bottomPadding.h, top: 14.h),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(modalRadius.r),
                      topRight: Radius.circular(modalRadius.r)),
                ),
                child: Wrap(
                  children: <Widget>[
                    SizedBox(height: 14.h),
                    const Center(child: PullDownIndicator()),
                    SizedBox(
                      height: 19.h,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const BodyTextLightWithLineHeight(
                            text: "Select Bank",
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
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.87,
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(50.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(3, 31, 76, 0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 16.w,
                              ),
                              SvgPicture.asset(searchIconSvg),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: searchController,
                                autofocus: false,
                                autocorrect: false,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    bankProvider.searchForBank(value);
                                  } else {
                                    bankProvider.resetBankList();
                                  }
                                },
                                cursorColor: mainColor,
                                textInputAction: TextInputAction.search,
                                decoration: const InputDecoration(
                                  hintText: "Search",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: textInputStyle(),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 48.h,
                    ),
                    bankProvider.gettingBanks
                        ? Center(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: 100.h, bottom: 100.h),
                              child: const CupertinoActivityIndicator(),
                            ),
                          )
                        : bankProvider.allBanksToDisplay.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 100.h, bottom: 100.h),
                                  child: const CustomTextWithLineHeight(
                                    text: "No Banks",
                                    textColor: Color(0xFF181C26),
                                    fontWeight: boldFont,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : Container(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.7,
                                    minHeight:
                                        MediaQuery.of(context).size.height *
                                            0.2),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          bankProvider.allBanksToDisplay.length,
                                      // physics: const NeverScrollableScrollPhysics(),
                                      // shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final bank = bankProvider
                                            .allBanksToDisplay[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 5),
                                          child: CustomContainerButton(
                                            onTap: () {
                                              bankProvider
                                                  .updateSelectedBank(bank);
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                Navigator.pop(context);
                                              });
                                            },
                                            title: "",
                                            borderRadius: 11,
                                            widget: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                BodyTextPrimaryWithLineHeight(
                                                  text: bank.name ?? "NA",
                                                  textColor:
                                                      const Color(0xFF0C0C0C),
                                                ),
                                                SvgPicture.asset(
                                                    bankProvider.selectedBank ==
                                                            bank
                                                        ? checkedIconSvg
                                                        : uncheckedIconSvg)
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                  ],
                ));
          }));
    },
  );
}
