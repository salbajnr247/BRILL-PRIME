import 'dart:io';

import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/toll_gates/widgets/dialogs/qr_code_display_dialog.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/image_constant.dart';

class ConsumerOrderDetailScreen extends StatelessWidget {
  const ConsumerOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
          Consumer<TollGateProvider>(builder: (ctx, tollGateProvider, child) {
        return Column(
          children: [
            const CustomAppbar(title: ""),
            const SizedBox(
              height: 20,
            ),
            const BodyTextPrimaryWithLineHeight(
              text: "Transaction Details",
              textColor: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            tollGateProvider.gettingSingleOrder
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4),
                    child: const CupertinoActivityIndicator(),
                  )
                : tollGateProvider.selectedOrder == null
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: const BodyTextPrimaryWithLineHeight(
                          text: "Error getting order detail",
                          fontSize: 16,
                          fontWeight: semiBoldFont,
                          textColor: black,
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding.w),
                          child: Consumer<TollGateProvider>(
                              builder: (ctx, tollGateProvider, child) {
                            final selectedOrder =
                                tollGateProvider.selectedOrder;
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomContainerButton(
                                  onTap: () {},
                                  title: "",
                                  bgColor:
                                      const Color.fromRGBO(70, 130, 180, 1),
                                  verticalPadding: 20,
                                  borderRadius: 15,
                                  widget: Column(
                                    children: [
                                      TxInfoItem(
                                          label: "Transaction ID",
                                          mainText:
                                              '${selectedOrder?.transactionId ?? "NA"}'),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TxInfoItem(
                                          label: "Date & Time",
                                          mainText: returnFormattedDateAndTime(
                                              selectedOrder?.createdAt == null
                                                  ? DateTime.now().toString()
                                                  : selectedOrder!.createdAt
                                                      .toString())),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const TxInfoItem(
                                          label: "Transaction Type",
                                          mainText: 'Purchase'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomContainerButton(
                                  onTap: () {},
                                  title: "",
                                  borderWidth: 1,
                                  borderColor:
                                      const Color.fromRGBO(70, 130, 180, 1),
                                  borderRadius: 15,
                                  widget: Column(
                                    children: [
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          BodyTextPrimaryWithLineHeight(
                                            text: "Merchant",
                                            fontWeight: boldFont,
                                            textColor:
                                                Color.fromRGBO(1, 14, 66, 1),
                                            fontSize: 10,
                                          ),
                                          BodyTextPrimaryWithLineHeight(
                                            text: "Merchant",
                                            textColor:
                                                Color.fromRGBO(1, 14, 66, 1),
                                            fontSize: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BodyTextPrimaryWithLineHeight(
                                                text: "S/N",
                                                fontWeight: boldFont,
                                                textColor: Color.fromRGBO(
                                                    1, 14, 66, 1),
                                                fontSize: 10,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              BodyTextPrimaryWithLineHeight(
                                                text: "Item",
                                                textColor: Color.fromRGBO(
                                                    1, 14, 66, 1),
                                                fontSize: 10,
                                                fontWeight: boldFont,
                                              ),
                                            ],
                                          ),
                                          // Spacer(),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                BodyTextPrimaryWithLineHeight(
                                                  text: "Qty",
                                                  fontWeight: boldFont,
                                                  textColor: Color.fromRGBO(
                                                      1, 14, 66, 1),
                                                  fontSize: 10,
                                                ),
                                                BodyTextPrimaryWithLineHeight(
                                                  text: "Price",
                                                  textColor: Color.fromRGBO(
                                                      1, 14, 66, 1),
                                                  fontSize: 10,
                                                  fontWeight: boldFont,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ListView.builder(
                                          itemCount:
                                              selectedOrder!.items.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final item =
                                                selectedOrder.items[index];
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      BodyTextPrimaryWithLineHeight(
                                                        text: "${index + 1}.",
                                                        fontWeight: boldFont,
                                                        textColor: const Color
                                                            .fromRGBO(
                                                            1, 14, 66, 1),
                                                        fontSize: 10,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      BodyTextPrimaryWithLineHeight(
                                                        text:
                                                            "${item.commodityName}",
                                                        textColor: const Color
                                                            .fromRGBO(
                                                            1, 14, 66, 1),
                                                        fontSize: 10,
                                                        fontWeight: boldFont,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // const Spacer(),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 50),
                                                        child:
                                                            BodyTextPrimaryWithLineHeight(
                                                          text:
                                                              "${item.quantity} ${item.unit}",
                                                          fontWeight: boldFont,
                                                          textColor: const Color
                                                              .fromRGBO(
                                                              1, 14, 66, 1),
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      BodyTextPrimaryWithLineHeight(
                                                        text: returnFormattedAmountWithCurrency(
                                                            amount: item
                                                                .commodityPrice),
                                                        textColor: const Color
                                                            .fromRGBO(
                                                            1, 14, 66, 1),
                                                        fontSize: 10,
                                                        fontWeight: boldFont,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                      ),
                                      TxInfoItem(
                                        label: "Total",
                                        mainText:
                                            returnFormattedAmountWithCurrency(
                                                amount:
                                                    selectedOrder.totalPrice),
                                        textColor:
                                            const Color.fromRGBO(1, 14, 66, 1),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const TxInfoItem(
                                        label: "Payment Method",
                                        mainText: "NA",
                                        textColor: Color.fromRGBO(1, 14, 66, 1),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                    width: 150,
                                    child: OutlineBtn(
                                      selectedOrder.status
                                          .toString()
                                          .capitalize(),
                                      () {},
                                      borderColor: selectedOrder.status ==
                                              "PENDING"
                                          ? const Color.fromRGBO(255, 149, 0, 1)
                                          : const Color.fromRGBO(
                                              49, 212, 93, 1),
                                      textColor: selectedOrder.status ==
                                              "PENDING"
                                          ? const Color.fromRGBO(255, 149, 0, 1)
                                          : const Color.fromRGBO(
                                              49, 212, 93, 1),
                                    ))
                              ],
                            );
                          }),
                        ),
                      ),
            if (!tollGateProvider.gettingSingleOrder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: MainButton(
                        "",
                        () async {
                          if (tollGateProvider.selectedOrder?.status ==
                              "PAID") {
                            showQRCodeDisplayDialog(context);
                          }
                        },
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 27,
                              width: 27,
                              child: Image.asset(scanQRCodeWhiteIcon),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const BodyTextPrimaryWithLineHeight(
                              text: "Generate QR",
                              fontSize: 16,
                              textColor: white,
                            )
                          ],
                        ),
                        color: const Color.fromRGBO(11, 26, 81, 1),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: Platform.isAndroid ? 10 : 0,
            )
          ],
        );
      })),
    );
  }
}

class TxInfoItem extends StatelessWidget {
  final String label;
  final String mainText;
  final Color textColor;
  const TxInfoItem(
      {super.key,
      required this.label,
      required this.mainText,
      this.textColor = white});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BodyTextPrimaryWithLineHeight(
          text: label,
          textColor: textColor,
          fontSize: 10,
          fontWeight: boldFont,
        ),
        BodyTextPrimaryWithLineHeight(
            text: mainText, textColor: textColor, fontSize: 10),
      ],
    );
  }
}
