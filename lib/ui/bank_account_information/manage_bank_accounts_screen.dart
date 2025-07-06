import 'dart:io';
import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/consumer_home.dart';
import 'package:brill_prime/ui/widgets/box_shadow_widget.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_snack_back.dart';
import 'add_bank_account_screen.dart';

class ManageBankAccountsScreen extends StatelessWidget {
  const ManageBankAccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (authProvider.resMessage != '') {
            customSnackBar(context, authProvider.resMessage,
                isError: authProvider.isError);

            ///Clear the response message to avoid duplicate
            authProvider.clear();
          }
        });
        return Column(
          children: [
            const CustomAppbar(title: ""),
            const SizedBox(
              height: 20,
            ),
            const BodyTextPrimaryWithLineHeight(
              text: "Bank Account Information",
              textColor: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 20,
              fontWeight: extraBoldFont,
            ),
            const SizedBox(
              height: 20,
            ),
            if (authProvider.userProfile?.data.vendor?.accountNumber != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
                child: Container(
                  height: 128,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: white,
                    boxShadow: const [containerBoxShadow],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                              child: BodyTextPrimaryWithLineHeight(
                            text: "Bank Account",
                            textColor: Color.fromRGBO(19, 19, 19, 1),
                            fontSize: 16,
                            fontWeight: boldFont,
                          ))),
                      Positioned(
                          top: 40,
                          left: 10,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BodyTextPrimaryWithLineHeight(
                                  text: authProvider.userProfile?.data.vendor
                                          ?.accountName ??
                                      "NA"),
                              const SizedBox(
                                height: 5,
                              ),
                              BodyTextPrimaryWithLineHeight(
                                text: authProvider.userProfile?.data.vendor
                                        ?.accountNumber ??
                                    "NA",
                                textColor: const Color.fromRGBO(19, 19, 19, 1),
                                fontWeight: boldFont,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              BodyTextPrimaryWithLineHeight(
                                text: authProvider
                                        .userProfile?.data.vendor?.bankName ??
                                    "NA",
                                fontSize: 12,
                                textColor: const Color.fromRGBO(19, 19, 19, 1),
                              ),
                            ],
                          )),
                      Positioned(
                          right: 70,
                          bottom: -10,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  navToWithScreenName(
                                      context: context,
                                      screen: AddBankAccountScreen(
                                        accountNumber: authProvider.userProfile
                                            ?.data.vendor?.accountNumber,
                                      ));
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
                          bottom: -10,
                          child: Row(
                            children: [
                              Container(
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
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: ActionButton(
                      icon: addIcon,
                      title: "Add New",
                      bgColor: deepBlueColor,
                      onTap: () {
                        navToWithScreenName(
                            context: context,
                            screen: const AddBankAccountScreen());
                      }),
                )
              ],
            ),
            SizedBox(
              height: Platform.isAndroid ? 40 : 0,
            ),
          ],
        );
      })),
    );
  }
}
