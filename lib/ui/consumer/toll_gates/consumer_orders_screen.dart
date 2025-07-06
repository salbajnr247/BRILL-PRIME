import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/toll_gates/consumer_order_detail.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/long_divider.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_snack_back.dart';

class ConsumerOrderScreen extends StatelessWidget {
  const ConsumerOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Consumer2<TollGateProvider, AuthProvider>(
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
                  text: "Transaction History",
                  textColor: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 20,
                  fontWeight: extraBoldFont,
                ),
                const SizedBox(
                  height: 20,
                ),
                tollGateProvider.gettingConsumerOrders
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
                          Consumer<TollGateProvider>(
                              builder: (ctx, tollGateProvider, child) {
                            return Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding.w),
                              child: ListView.builder(
                                  itemCount:
                                      tollGateProvider.consumerOrders.length,
                                  itemBuilder: (context, index) {
                                    final order =
                                        tollGateProvider.consumerOrders[index];
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: InkWell(
                                          onTap: () {
                                            tollGateProvider
                                                .getConsumerSingleOrders(
                                                    context: context,
                                                    orderId: order.id);
                                            navToWithScreenName(
                                                context: context,
                                                screen:
                                                    const ConsumerOrderDetailScreen());
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const BodyTextPrimaryWithLineHeight(
                                                    text: "Purchase",
                                                    textColor: Color.fromRGBO(
                                                        19, 19, 19, 1),
                                                    fontWeight: mediumFont,
                                                    fontSize: 13,
                                                  ),
                                                  BodyTextPrimaryWithLineHeight(
                                                    text:
                                                        returnFormattedAmountWithCurrency(
                                                            amount: order
                                                                .totalPrice),
                                                    textColor:
                                                        const Color.fromRGBO(
                                                            255, 180, 180, 1),
                                                    fontSize: 13,
                                                    fontWeight: mediumFont,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  BodyTextPrimaryWithLineHeight(
                                                    text: "${order.status}"
                                                        .capitalize(),
                                                    textColor: order.status ==
                                                            "PAID"
                                                        ? const Color.fromRGBO(
                                                            101, 117, 255, 1)
                                                        : const Color.fromRGBO(
                                                            255, 149, 0, 1),
                                                    fontSize: 8,
                                                    fontWeight: mediumFont,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              const LongDivider(),
                                            ],
                                          ),
                                        ));
                                  }),
                            ));
                          }),
                        ],
                      )),
              ],
            );
          })),
    );
  }
}
