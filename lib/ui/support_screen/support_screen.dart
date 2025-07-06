import 'dart:io';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/vendor_profile_screen.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../resources/constants/color_constants.dart';
import '../../../resources/constants/font_constants.dart';
import '../../providers/auth_provider.dart';
import '../../resources/constants/dimension_constants.dart';
import '../widgets/components.dart';
import '../widgets/custom_snack_back.dart';
import '../widgets/textfields.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final accountNumberController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
    super.initState();
  }

  File? commodityPicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
          bottom: false,
          child: Consumer2<AuthProvider, VendorProvider>(
              builder: (ctx, authProvider, vendorProvider, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (vendorProvider.resMessage != '') {
                customSnackBar(context, vendorProvider.resMessage);

                ///Clear the response message to avoid duplicate
                vendorProvider.clear();
              }
            });
            return Column(
              children: [
                const CustomAppbar(title: ""),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                    child: BodyTextPrimaryWithLineHeight(
                  text: "Support",
                  fontWeight: extraBoldFont,
                  textColor: Color.fromRGBO(11, 26, 81, 1),
                  fontSize: 20,
                )),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(title: "Name"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                  "Email", accountNumberController,
                                  isCapitalizeSentence: false,
                                  type: TextInputType.emailAddress),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        const Label(title: "Email"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                  "Email", accountNumberController,
                                  isCapitalizeSentence: false,
                                  type: TextInputType.emailAddress),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Label(title: "Subject"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                  "Subject", accountNumberController,
                                  isCapitalizeSentence: false,
                                  type: TextInputType.emailAddress),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Label(title: "Message"),
                        Row(
                          children: [
                            Expanded(
                              child: CustomField(
                                  "Message", accountNumberController,
                                  maxLines: 10,
                                  isCapitalizeSentence: false,
                                  type: TextInputType.emailAddress),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                authProvider.onboardingVendor
                    ? const Center(child: CupertinoActivityIndicator())
                    : Center(
                        child: SizedBox(
                          width: 200,
                          child: vendorProvider.addingCommodity
                              ? const Center(
                                  child: CupertinoActivityIndicator())
                              : MainButton(
                                  "Submit",
                                  fontWeight: mediumFont,
                                  () async {},
                                  color: mainColor,
                                ),
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
