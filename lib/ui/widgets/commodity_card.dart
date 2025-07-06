import 'package:brill_prime/models/commodities_model.dart';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/edit_commodity_screen.dart';
import 'package:brill_prime/ui/vendor/widgets/modal/confirm_delete_commodity_modal.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/toll_gate_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../consumer/select_payment_method_screen.dart';
import 'box_shadow_widget.dart';

class CommodityCard extends StatelessWidget {
  final CommodityData commodity;
  const CommodityCard({super.key, required this.commodity});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [containerBoxShadow],
          color: white),
      child:
          Consumer<TollGateProvider>(builder: (ctx, tollGateProvider, child) {
        return Column(
          children: [
            Row(
              children: [
                CustomContainerButton(
                  onTap: () {},
                  title: commodity.name,
                  bgColor: mainColor,
                  borderRadius: 10,
                  horizontalPadding: 20,
                  textColor: white,
                  fontSize: 12,
                  fontWeight: boldFont,
                  verticalPadding: 10,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomContainerButton(
                    onTap: () {},
                    title: "",
                    bgColor: mainColor,
                    borderRadius: 10,
                    horizontalPadding: 20,
                    textColor: white,
                    fontSize: 12,
                    fontWeight: boldFont,
                    verticalPadding: 10,
                    widget: Row(
                      children: [
                        Expanded(
                          child: BodyTextPrimaryWithLineHeight(
                            text: commodity.description,
                            textColor: white,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromRGBO(217, 217, 217, 1))),
                  child: Image.network(commodity.imageUrl),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BodyTextPrimaryWithLineHeight(
                      text: "Unit",
                      textColor: mainColor,
                      fontSize: 15,
                      fontWeight: boldFont,
                    ),
                    // SizedBox(height: 10,),
                    BodyTextPrimaryWithLineHeight(
                      text: "${commodity.unit}",
                      textColor: const Color.fromRGBO(11, 26, 81, 1),
                      fontSize: 12,
                    ),
                    const BodyTextPrimaryWithLineHeight(
                      text: "Price",
                      textColor: mainColor,
                      fontSize: 15,
                      fontWeight: boldFont,
                    ),
                    BodyTextPrimaryWithLineHeight(
                      text: returnFormattedAmountWithCurrency(
                          amount: commodity.price),
                      textColor: const Color.fromRGBO(11, 26, 81, 1),
                      fontSize: 13,
                    ),
                  ],
                )),
                tollGateProvider
                            .returnCartItem(commodityId: commodity.id)
                            ?.id ==
                        null
                    ? Row(
                        children: [
                          tollGateProvider.addingCart &&
                                  tollGateProvider.currentCommodityId ==
                                      commodity.id
                              ? const CupertinoActivityIndicator()
                              : CustomContainerButton(
                                  onTap: () {
                                    debugPrint(
                                        "User ID::::::  ${authProvider.userProfile?.data.id}");
                                    if (tollGateProvider.addingCart) {
                                      //   Do nothing
                                    } else {
                                      tollGateProvider.addCommodityToCart(
                                          context: context,
                                          commodityId: commodity.id ?? "");
                                    }
                                  },
                                  title: "Add",
                                  bgColor: mainColor,
                                  borderRadius: 10,
                                  horizontalPadding: 20,
                                  textColor: white,
                                  fontSize: 12,
                                  fontWeight: boldFont,
                                  verticalPadding: 10,
                                ),
                        ],
                      )
                    : Row(
                        children: [
                          InkWell(
                              onTap: () {
                                if (!tollGateProvider.updatingQuantity) {
                                  tollGateProvider
                                      .updateCommodityQuantityInCart(
                                          context: context,
                                          cart: tollGateProvider.returnCartItem(
                                              commodityId: commodity.id)!);
                                }
                              },
                              child: tollGateProvider.updatingQuantity &&
                                      tollGateProvider.currentCommodityId ==
                                          commodity.id &&
                                      tollGateProvider.isAddQuantity
                                  ? const CupertinoActivityIndicator()
                                  : SvgPicture.asset(plusIcon)),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomContainerButton(
                            onTap: () {},
                            title:
                                "${tollGateProvider.returnCartItem(commodityId: commodity.id)?.quantity ?? '1'}",
                            bgColor: mainColor,
                            borderRadius: 5,
                            verticalPadding: 5,
                            textColor: white,
                            fontSize: 16,
                            fontWeight: boldFont,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                              onTap: () {
                                if (!tollGateProvider.updatingQuantity) {
                                  tollGateProvider
                                      .updateCommodityQuantityInCart(
                                          context: context,
                                          cart: tollGateProvider.returnCartItem(
                                              commodityId: commodity.id)!,
                                          isIncrease: false);
                                }
                              },
                              child: tollGateProvider.updatingQuantity &&
                                      tollGateProvider.currentCommodityId ==
                                          commodity.id &&
                                      !tollGateProvider.isAddQuantity
                                  ? const CupertinoActivityIndicator()
                                  : SvgPicture.asset(minusIcon)),
                        ],
                      )
              ],
            )
          ],
        );
      }),
    );
  }
}

class VendorCommodityCard extends StatelessWidget {
  final CommodityData commodityData;
  const VendorCommodityCard({super.key, required this.commodityData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [containerBoxShadow],
          color: white),
      height: 185,
      child: Consumer<VendorProvider>(builder: (ctx, vendorProvider, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              child: Container(
                constraints: BoxConstraints(
                    minWidth: 50,
                    maxWidth: MediaQuery.of(context).size.width * 0.35),
                child: CustomContainerButton(
                  onTap: () {},
                  title: commodityData.name,
                  bgColor: mainColor,
                  borderRadius: 10,
                  horizontalPadding: 15,
                  textColor: white,
                  fontSize: 12,
                  fontWeight: boldFont,
                  verticalPadding: 5,
                  widget: Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            minWidth: 50,
                            maxWidth: MediaQuery.of(context).size.width * 0.3),
                        child: BodyTextPrimaryWithLineHeight(
                          text: commodityData.name,
                          textColor: white,
                          fontSize: 20,
                          fontWeight: boldFont,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: Container(
                constraints: BoxConstraints(
                    minWidth: 100,
                    maxWidth: MediaQuery.of(context).size.width * 0.5),
                child: CustomContainerButton(
                  onTap: () {},
                  title: "",
                  bgColor: mainColor,
                  borderRadius: 10,
                  horizontalPadding: 20,
                  textColor: white,
                  fontSize: 12,
                  fontWeight: boldFont,
                  verticalPadding: 10,
                  widget: Row(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            minWidth: 100,
                            maxWidth: MediaQuery.of(context).size.width * 0.38),
                        child: BodyTextPrimaryWithLineHeight(
                          text: commodityData.description,
                          textColor: white,
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: const Color.fromRGBO(217, 217, 217, 1))),
                    child: Image.network(commodityData.imageUrl),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BodyTextPrimaryWithLineHeight(
                        text: "Unit",
                        textColor: mainColor,
                        fontSize: 15,
                        fontWeight: boldFont,
                      ),
                      // SizedBox(height: 10,),
                      const BodyTextPrimaryWithLineHeight(
                        text: "   -",
                        textColor: Color.fromRGBO(11, 26, 81, 1),
                        fontSize: 12,
                      ),
                      const BodyTextPrimaryWithLineHeight(
                        text: "Price",
                        textColor: mainColor,
                        fontSize: 15,
                        fontWeight: boldFont,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BodyTextPrimaryWithLineHeight(
                        text: returnFormattedAmountWithCurrency(
                            amount: commodityData.price),
                        textColor: const Color.fromRGBO(11, 26, 81, 1),
                        fontSize: 13,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                right: 70,
                bottom: -20,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        vendorProvider.updateSelectedCommodity(commodityData);
                        navToWithScreenName(
                            context: context,
                            screen: const EditCommodityScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Image.asset(
                          editIconWhite,
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ),
                  ],
                )),
            Positioned(
                right: 20,
                bottom: -20,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        showConfirmDeleteCommodityModal(context,
                            commodity: commodityData);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Image.asset(
                          deleteIconWhite,
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        );
      }),
    );
  }
}

class PaymentCardWidget extends StatelessWidget {
  final PaymentCard card;
  const PaymentCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [containerBoxShadow],
          color: white),
      child:
          Consumer<TollGateProvider>(builder: (ctx, tollGateProvider, child) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 51,
                  child: Image.asset(card.cardLogo),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyTextPrimaryWithLineHeight(
                      text: "**** **** **** ${card.last4Digits}",
                      fontWeight: mediumFont,
                      textColor: const Color.fromRGBO(19, 19, 19, 1),
                      fontSize: 15,
                    ),
                    BodyTextPrimaryWithLineHeight(
                      text: card.expiryDate,
                      fontWeight: mediumFont,
                      textColor: const Color.fromRGBO(19, 19, 19, 1),
                      fontSize: 13,
                    ),
                  ],
                )
              ],
            )
          ],
        );
      }),
    );
  }
}
