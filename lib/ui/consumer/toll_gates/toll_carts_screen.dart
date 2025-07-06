import 'dart:io';

import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/toll_gates/payment_screen.dart';
import 'package:brill_prime/ui/consumer/toll_gates/widgets/dialogs/ticket_ordered_dialog.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/long_divider.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/image_constant.dart';

class TollGateCartsScreen extends StatelessWidget {
  const TollGateCartsScreen({super.key});

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
              text: "Cart",
              textColor: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            tollGateProvider.gettingCartDetails
                ? Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.4),
                    child: const CupertinoActivityIndicator(),
                  )
                : tollGateProvider.cartItems.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: const BodyTextPrimaryWithLineHeight(
                          text: "No Items in cart",
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
                            return Column(
                              children: [
                                CustomContainerButton(
                                  title: "",
                                  borderColor:
                                      const Color.fromRGBO(70, 130, 180, 1),
                                  borderRadius: 15,
                                  onTap: () {},
                                  widget: ListView.builder(
                                      itemCount:
                                          tollGateProvider.cartItems.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final cart =
                                            tollGateProvider.cartItems[index];
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 57,
                                                  width: 57,
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: const Color
                                                              .fromRGBO(217,
                                                              217, 217, 1))),
                                                  child: Image.network(
                                                      cart.imageUrl),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    BodyTextPrimaryWithLineHeight(
                                                      text: cart.commodityName,
                                                      textColor: mainColor,
                                                      fontSize: 15,
                                                      fontWeight: boldFont,
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              if (!tollGateProvider
                                                                  .updatingQuantity) {
                                                                tollGateProvider
                                                                    .updateCommodityQuantityInCart(
                                                                        context:
                                                                            context,
                                                                        isCartScreen:
                                                                            true,
                                                                        cart:
                                                                            cart);
                                                              }
                                                            },
                                                            child: tollGateProvider
                                                                        .updatingQuantity &&
                                                                    tollGateProvider
                                                                            .currentCommodityId ==
                                                                        cart
                                                                            .id &&
                                                                    tollGateProvider
                                                                        .isAddQuantity
                                                                ? const CupertinoActivityIndicator()
                                                                : SvgPicture
                                                                    .asset(
                                                                    plusIcon,
                                                                    height: 12,
                                                                    width: 12,
                                                                  )),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        CustomContainerButton(
                                                          onTap: () {},
                                                          title:
                                                              "${cart.quantity ?? '1'}",
                                                          bgColor: mainColor,
                                                          borderRadius: 5,
                                                          verticalPadding: 3,
                                                          horizontalPadding: 8,
                                                          textColor: white,
                                                          fontSize: 12,
                                                          fontWeight: boldFont,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              if (!tollGateProvider
                                                                  .updatingQuantity) {
                                                                tollGateProvider.updateCommodityQuantityInCart(
                                                                    context:
                                                                        context,
                                                                    cart: cart,
                                                                    isIncrease:
                                                                        false,
                                                                    isCartScreen:
                                                                        true);
                                                              }
                                                            },
                                                            child: tollGateProvider
                                                                        .updatingQuantity &&
                                                                    tollGateProvider
                                                                            .currentCommodityId ==
                                                                        cart
                                                                            .id &&
                                                                    !tollGateProvider
                                                                        .isAddQuantity
                                                                ? const CupertinoActivityIndicator()
                                                                : SvgPicture.asset(
                                                                    minusIcon)),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                                BodyTextPrimaryWithLineHeight(
                                                  text:
                                                      "$nairaSign${returnFormattedAmountWithCurrency(amount: "${double.parse(cart.commmodityPrice.toString()) * double.parse(cart.quantity.toString())}")}",
                                                  fontSize: 13,
                                                  fontWeight: semiBoldFont,
                                                  textColor:
                                                      const Color.fromRGBO(
                                                          11, 26, 81, 1),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await tollGateProvider
                                                        .removeItemFromCart(
                                                            context:
                                                                context,
                                                            cart: cart);
                                                  },
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child: tollGateProvider
                                                                .deletingItemFromCart &&
                                                            tollGateProvider
                                                                    .currentCommodityId ==
                                                                cart.id
                                                        ? const CupertinoActivityIndicator()
                                                        : Image.asset(
                                                            deleteIcon),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const LongDivider(),
                                            const SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        );
                                      }),
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
                                        textColor: white,
                                        fontWeight: boldFont,
                                        fontSize: 16,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const BodyTextPrimaryWithLineHeight(
                                            text: "Total",
                                            textColor: white,
                                            fontSize: 15,
                                          ),
                                          BodyTextPrimaryWithLineHeight(
                                            text:
                                                returnFormattedAmountWithCurrency(
                                                    amount: tollGateProvider
                                                        .totalAmount),
                                            textColor: white,
                                            fontWeight: semiBoldFont,
                                            fontSize: 15,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // CustomContainerButton(
                                //   onTap: () {
                                //     navToWithScreenName(
                                //         context: context,
                                //         screen:
                                //             const SelectPaymentMethodScreen());
                                //   },
                                //   title: "Select  a Payment Method....",
                                //   borderColor:
                                //       const Color.fromRGBO(70, 130, 180, 1),
                                //   textColor:
                                //       const Color.fromRGBO(217, 217, 217, 1),
                                //   fontSize: 16,
                                //   borderWidth: 1,
                                //   verticalPadding: 30,
                                //   fontWeight: mediumFont,
                                //   borderRadius: 15,
                                // ),
                              ],
                            );
                          }),
                        ),
                      ),
            if (!tollGateProvider.gettingCartDetails &&
                tollGateProvider.cartItems.isNotEmpty)
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: tollGateProvider.placingOrder
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : MainButton(
                            "Make Payment",
                            () async {
                              bool orderPlaced = await tollGateProvider
                                  .placeOrder(context: context);
                              if (orderPlaced && context.mounted) {
                                (dynamic, dynamic) paymentMade =
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PaymentScreen()));
                                debugPrint(
                                    "After Payment:::: ${paymentMade.$1} ${paymentMade.$2}");
                                if (paymentMade.$1 != null &&
                                    paymentMade.$1.toString().isNotEmpty &&
                                    context.mounted) {
                                  bool paymentVerified =
                                      await tollGateProvider.verifyPayment(
                                          context: context,
                                          txRef: paymentMade.$1,
                                          transactionId: paymentMade.$2);
                                  if (paymentVerified && context.mounted) {
                                    showTicketOrderedDialog(context);
                                  }
                                }
                              }
                            },
                            color: const Color.fromRGBO(11, 26, 81, 1),
                          ),
                  ))
                ],
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
