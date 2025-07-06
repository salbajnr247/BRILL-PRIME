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
import '../../providers/vendor_provider.dart';

class VendorOrderDetailScreen extends StatelessWidget {
  const VendorOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color.fromRGBO(11, 26, 81, 1),
      ),
      body: SafeArea(child:
          Consumer<VendorProvider>(builder: (ctx, vendorProvider, child) {
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
                            final selectedOrder = vendorProvider.selectedOrder;
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
                                      TxInfoItem(
                                          label: "Customer Name",
                                          mainText:
                                              selectedOrder?.consumerName ??
                                                  "NA"),
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
            if (!vendorProvider.gettingSingleOrder)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: MainButton(
                        "",
                        () async {
                          if (vendorProvider.selectedOrder?.status == "PAID") {
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

class VendorOrderDetailScreen extends StatelessWidget {
  const VendorOrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: const Color.fromRGBO(11, 26, 81, 1),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.order == null)
                  const Center(
                    child: Text('Error: Order details not available'),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Transaction ID:', widget.order?.transactionId ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildDetailRow('Date/Time:', _formatDateTime(widget.order?.createdAt)),
                      const SizedBox(height: 8),
                      _buildDetailRow('Customer:', widget.order?.user?.fullName ?? 'N/A'),
                      const SizedBox(height: 16),
                      const Text(
                        'Items:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (widget.order?.orderItems?.isEmpty ?? true)
                        const Center(child: Text('No items found'))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.order?.orderItems?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = widget.order?.orderItems?[index];
                            if (item == null) return const SizedBox.shrink();
                            
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.commodity?.name ?? 'N/A',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text('Quantity: ${item.quantity}'),
                                          Text('Price: ₦${_formatPrice(item.price)}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Total Amount:',
                        '₦${_formatPrice(widget.order?.totalPrice ?? 0)}',
                        isTotal: true,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime.toLocal());
  }

  String _formatPrice(num price) {
    return NumberFormat('#,##0.00').format(price);
  }
}
