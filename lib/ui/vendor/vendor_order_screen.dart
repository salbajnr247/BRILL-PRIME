import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/vendor_accept_order_screen.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/long_divider.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class VendorOrderScreen extends StatelessWidget {
  const VendorOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Consumer2<VendorProvider, AuthProvider>(
              builder: (ctx, vendorProvider, authProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {});
            return Column(
              children: [
                const CustomAppbar(title: ""),
                const SizedBox(
                  height: 20,
                ),
                const BodyTextPrimaryWithLineHeight(
                  text: "Orders",
                  textColor: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 20,
                  fontWeight: extraBoldFont,
                ),
                const SizedBox(
                  height: 20,
                ),
                vendorProvider.gettingVendorOrders
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
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding.w),
                            child: ListView.builder(
                                itemCount: vendorProvider.vendorOrders.length,
                                itemBuilder: (context, index) {
                                  final order =
                                      vendorProvider.vendorOrders[index];
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: InkWell(
                                        onTap: () {
                                          vendorProvider
                                              .getConsumerSingleOrders(
                                                  context: context,
                                                  orderId: order.id);
                                          navToWithScreenName(
                                              context: context,
                                              screen:
                                                  const VendorAcceptOrderScreen());
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                    const BodyTextPrimaryWithLineHeight(
                                                      text: "Anthony",
                                                      textColor: black,
                                                      fontWeight: semiBoldFont,
                                                      fontSize: 10,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    const BodyTextPrimaryWithLineHeight(
                                                      text: "Ticket",
                                                      textColor: Color.fromRGBO(
                                                          1, 14, 66, 1),
                                                      fontWeight: boldFont,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    CustomContainerButton(
                                                      onTap: () {},
                                                      title: "1 Ticket",
                                                      borderColor: mainColor,
                                                      borderRadius: 5,
                                                      borderWidth: 1,
                                                      verticalPadding: 2,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    BodyTextPrimaryWithLineHeight(
                                                      text:
                                                          returnFormattedAmountWithCurrency(
                                                              amount: order
                                                                  .totalPrice),
                                                      fontSize: 12,
                                                      textColor:
                                                          const Color.fromRGBO(
                                                              11, 26, 81, 1),
                                                      fontWeight: semiBoldFont,
                                                    )
                                                  ],
                                                )),
                                                CustomContainerButton(
                                                  onTap: () {
                                                    vendorProvider
                                                        .getConsumerSingleOrders(
                                                            context: context,
                                                            orderId: order.id);
                                                    navToWithScreenName(
                                                        context: context,
                                                        screen:
                                                            const VendorAcceptOrderScreen());
                                                  },
                                                  title: "View",
                                                  bgColor: const Color.fromRGBO(
                                                      11, 26, 81, 1),
                                                  textColor: white,
                                                  verticalPadding: 2,
                                                  borderRadius: 5,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const LongDivider(),
                                          ],
                                        ),
                                      ));
                                }),
                          ))
                        ],
                      )),
              ],
            );
          })),
    );
  }
}