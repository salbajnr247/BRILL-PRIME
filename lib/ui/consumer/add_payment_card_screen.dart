import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/consumer/consumer_home.dart';
import 'package:brill_prime/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../utils/navigation_util.dart';
import '../Widgets/custom_text.dart';
import '../vendor/complete_vendor_profile_screen.dart';
import '../vendor/vendor_home_screen.dart';
import '../widgets/components.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class AddPaymentCardScreen extends StatefulWidget {
  const AddPaymentCardScreen({super.key});

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  final cardNumberController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
            return Column(
              children: [
                const CustomAppbar(title: ""),
                SizedBox(
                  height: 20.h,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding.w),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              BodyTextPrimaryWithLineHeight(
                                text: "Add New Payment Method",
                                textColor: black,
                                fontWeight: extraBoldFont,
                                alignCenter: true,
                                fontSize: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(
                          title: "Card Number",
                          fontSize: 15,
                          fontWeight: semiBoldFont,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Email or phone number",
                                cardNumberController,
                                isCapitalizeSentence: false,
                                formatters: numbersOnlyFormat,
                                type: const TextInputType.numberWithOptions(
                                    signed: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Label(
                          title: "Card Holder Name",
                          fontSize: 15,
                          fontWeight: semiBoldFont,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                "Email or phone number",
                                cardHolderNameController,
                                isCapitalizeSentence: false,
                                type: TextInputType.name,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Label(
                                    title: "Card Expiry Date",
                                    fontSize: 15,
                                    fontWeight: semiBoldFont,
                                  ),
                                  CustomField(
                                    "Email or phone number",
                                    cardNumberController,
                                    isCapitalizeSentence: false,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Label(
                                    title: "CVC",
                                    fontSize: 15,
                                    fontWeight: semiBoldFont,
                                  ),
                                  CustomField(
                                    "Email or phone number",
                                    cardNumberController,
                                    isCapitalizeSentence: false,
                                    type: TextInputType.emailAddress,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 19.h,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                authProvider.isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.3),
                        child: MainButton(
                          "Sign In",
                          fontWeight: mediumFont,
                          () async {
                            if (cardNumberController.text.length < 4) {
                              customSnackBar(
                                context,
                                "Please enter a valid email",
                              );
                            } else if (cardHolderNameController.text
                                    .trim()
                                    .length <
                                8) {
                              customSnackBar(context,
                                  "Password must be at least 8 characters");
                            } else {
                              final isLoggedIn = await authProvider.loginUser(
                                  context: context,
                                  password: cardHolderNameController.text,
                                  email: cardNumberController.text);
                              if (isLoggedIn && context.mounted) {
                                if (authProvider.userProfile?.data.role ==
                                    consumer.toUpperCase()) {
                                  navToWithScreenName(
                                      context: context,
                                      screen: ConsumerHomePage(
                                        currentLocation:
                                            authProvider.userCurrentLocation!,
                                      ));
                                } else if (authProvider
                                        .userProfile?.data.role ==
                                    vendor.toUpperCase()) {
                                  if (authProvider.userProfile?.data.vendor ==
                                      null) {
                                    navToWithScreenName(
                                        context: context,
                                        screen: const CompleteVendorScreen());
                                  } else {
                                    navToWithScreenName(
                                        context: context,
                                        screen: const VendorHomeScreen());
                                  }
                                } else {}
                              }
                            }
                          },
                          color: const Color.fromRGBO(1, 14, 66, 1),
                        ),
                      ),
                SizedBox(
                  height: bottomPadding.h,
                )
              ],
            );
          })),
    );
  }
}
