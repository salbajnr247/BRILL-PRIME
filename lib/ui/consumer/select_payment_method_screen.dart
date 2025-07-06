import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/widgets/commodity_card.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../utils/navigation_util.dart';
import '../widgets/components.dart';
import 'add_payment_card_screen.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer2<TollGateProvider, AuthProvider>(
          builder: (ctx, tollGateProvider, authProvider, child) {
        return Column(
          children: [
            const CustomAppbar(title: ""),
            const SizedBox(
              height: 20,
            ),
            const BodyTextPrimaryWithLineHeight(
              text: commodities,
              textColor: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            authProvider.gettingCategories
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
                              itemCount: cardList.length,
                              itemBuilder: (context, index) {
                                final card = cardList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: PaymentCardWidget(
                                    card: card,
                                  ),
                                );
                              }),
                        ));
                      }),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding.w),
                        child: CustomContainerButton(
                          onTap: () {
                            navToWithScreenName(
                                context: context,
                                screen: const AddPaymentCardScreen());
                          },
                          title: " Add Payment Method....",
                          borderColor: const Color.fromRGBO(70, 130, 180, 1),
                          textColor: const Color.fromRGBO(217, 217, 217, 1),
                          fontSize: 16,
                          borderWidth: 1,
                          verticalPadding: 30,
                          fontWeight: mediumFont,
                          borderRadius: 15,
                        ),
                      ),
                    ],
                  )),
          ],
        );
      })),
    );
  }
}

class PaymentCard {
  final String cardLogo;
  final String last4Digits;
  final String expiryDate;
  PaymentCard(
      {required this.cardLogo,
      required this.expiryDate,
      required this.last4Digits});
}

final List<PaymentCard> cardList = [
  PaymentCard(
      cardLogo: masterCardLogo, expiryDate: "02/26", last4Digits: "1234"),
  PaymentCard(cardLogo: visaCardLogo, expiryDate: "02/27", last4Digits: "1234"),
  PaymentCard(cardLogo: applePayLogo, expiryDate: "02/28", last4Digits: "1234"),
];
