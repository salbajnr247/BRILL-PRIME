import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/scan_qr_code_screen.dart';
import 'package:brill_prime/ui/vendor/widgets/dialogs/transaction_completed_dialog.dart';
import 'package:brill_prime/ui/vendor/widgets/dialogs/transaction_confirmation_failed_dialog.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/long_divider.dart';
import 'package:brill_prime/ui/widgets/user_profile_picture_widget.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../providers/vendor_provider.dart';
import '../widgets/custom_snack_back.dart';

class VendorAcceptOrderScreen extends StatelessWidget {
  const VendorAcceptOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
          Consumer<VendorProvider>(builder: (ctx, vendorProvider, child) {
        return Column(
          children: [
            const CustomAppbar(title: ""),
            const SizedBox(
              height: 20,
            ),
            const BodyTextPrimaryWithLineHeight(
              text: "Order Details",
              textColor: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            vendorProvider.gettingSingleOrder
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4),
                    child: const CupertinoActivityIndicator(),
                  )
                : vendorProvider.selectedOrder == null
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
                          child: Consumer<VendorProvider>(
                              builder: (ctx, vendorProvider, child) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (vendorProvider.resMessage != '') {
                                customSnackBar(
                                    context, 
                                    vendorProvider.resMessage,
                                    isError: vendorProvider.resMessage.toLowerCase().contains('error')
                                );
                                vendorProvider.clear();
                              }
                            });

                            final selectedOrder = vendorProvider.selectedOrder;
                            return Column(
                              children: [
                                 UserProfilePictureWidget(
                                  dimension: 80,
                                  onTap: (){},
                                ),
                                BodyTextPrimaryWithLineHeight(
                                  text:
                                      "${selectedOrder?.consumerName ?? 'NA'}",
                                  textColor: black,
                                  fontSize: 16,
                                  fontWeight: boldFont,
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
                                      ListView.builder(
                                          itemCount:
                                              selectedOrder!.items.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final item =
                                                selectedOrder.items[index];
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Container(
                                                          height: 57,
                                                          width: 54,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      item.imageUrl))),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            BodyTextPrimaryWithLineHeight(
                                                              text: item
                                                                  .commodityName,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  boldFont,
                                                              textColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      1,
                                                                      14,
                                                                      66,
                                                                      1),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            CustomContainerButton(
                                                              onTap: () {},
                                                              title:
                                                                  "${item.quantity} ${item.unit} ",
                                                              borderRadius: 5,
                                                              borderColor:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      70,
                                                                      130,
                                                                      180,
                                                                      1),
                                                              borderWidth: 1,
                                                              verticalPadding:
                                                                  2,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                    BodyTextPrimaryWithLineHeight(
                                                      text: returnFormattedAmountWithCurrency(
                                                          amount: item
                                                              .commodityPrice),
                                                      fontWeight: semiBoldFont,
                                                      textColor: const Color.fromRGBO(
                                                          11, 26, 81, 1),
                                                      fontSize: 13,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const LongDivider(),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ),
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
                                      const BodyTextPrimaryWithLineHeight(
                                        text: "Purchase Summary",
                                        fontWeight: boldFont,
                                        fontSize: 16,
                                        textColor: white,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TxInfoItem(
                                        label: "Total",
                                        mainText:
                                            returnFormattedAmountWithCurrency(
                                                amount:
                                                    selectedOrder.totalPrice),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
            if (!vendorProvider.gettingSingleOrder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: vendorProvider.confirmingOrder
                          ? const Center(
                              child: CupertinoActivityIndicator(),
                            )
                          : MainButton(
                              "",
                              () async {
                                try {
                                  final scannedInfo = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ScanOrderScreen()));

                                  if (scannedInfo == null) {
                                    customSnackBar(context, 'Scanning cancelled');
                                    return;
                                  }

                                  if (scannedInfo.$2.toString().isNotEmpty &&
                                      scannedInfo.$1.toString().isNotEmpty) {
                                    bool confirmed =
                                        await vendorProvider.confirmOrder(
                                            context: context,
                                            txRef: scannedInfo.$1,
                                            transactionId: scannedInfo.$2);

                                    if (confirmed) {
                                      await vendorProvider.getVendorOrders(
                                          context: context);
                                      if (context.mounted) {
                                        showTransactionCompletedDialog(context);
                                      }
                                    } else if (context.mounted) {
                                      showTransactionConfirmationFailedDialog(
                                          context);
                                    }
                                  } else {
                                    customSnackBar(context, 'Invalid QR code data');
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    customSnackBar(context, 'Error processing order: ${e.toString()}');
                                  }
                                }
                              },
                              widget: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BodyTextPrimaryWithLineHeight(
                                    text: "Accept",
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
              height: bottomPadding.h,
            ),
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
          text: mainText,
          textColor: textColor,
          fontSize: 15,
          fontWeight: semiBoldFont,
        ),
      ],
    );
  }
}
