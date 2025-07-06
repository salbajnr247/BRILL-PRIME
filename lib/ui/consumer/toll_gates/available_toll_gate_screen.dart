import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/toll_gates/toll_gate_details_screen.dart';
import 'package:brill_prime/ui/widgets/custom_appbar.dart';
import 'package:brill_prime/ui/widgets/long_divider.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AvailableTollGateScreen extends StatelessWidget {
  const AvailableTollGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const CustomAppbar(title: ""),
          const SizedBox(
            height: 20,
          ),
          const BodyTextPrimaryWithLineHeight(
            text: "Available Toll Gates",
            textColor: Color.fromRGBO(0, 0, 0, 1),
            fontSize: 20,
            fontWeight: extraBoldFont,
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<TollGateProvider>(builder: (ctx, tollGateProvider, child) {
            return Expanded(
                child: tollGateProvider.gettingVendors
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : tollGateProvider.vendors.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.3),
                            child: const BodyTextPrimaryWithLineHeight(
                              text: "No Available Toll Gates",
                              textColor: black,
                              fontWeight: semiBoldFont,
                              fontSize: 20,
                            ),
                          )
                        : ListView.builder(
                            itemCount: tollGateProvider.vendors.length,
                            itemBuilder: (context, index) {
                              final tollGate = tollGateProvider.vendors[index];
                              debugPrint("Vendor ID ${tollGate.userId}");
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: horizontalPadding.w,
                                    right: horizontalPadding.w,
                                    bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    tollGateProvider.getCartDetails(
                                        context: context);
                                    tollGateProvider.updateSelectedTollGate(
                                        vendor: tollGate);
                                    navToWithScreenName(
                                        context: context,
                                        screen: const TollGateDetailScreen());
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                              height: 26,
                                              width: 26,
                                              child: Image.asset(
                                                  availableTollIcon)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              BodyTextPrimaryWithLineHeight(
                                                text: tollGate.businessName,
                                                textColor: black,
                                                fontSize: 16,
                                                fontWeight: mediumFont,
                                              ),
                                              BodyTextPrimaryWithLineHeight(
                                                text: tollGate.address,
                                                fontSize: 12,
                                                textColor: black,
                                                fontWeight: lightFont,
                                              )
                                            ],
                                          )),
                                          SizedBox(
                                            height: 22,
                                            width: 22,
                                            child: Image.asset(
                                                availableTollArrowIcon),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const LongDivider(),
                                    ],
                                  ),
                                ),
                              );
                            }));
          })
        ],
      )),
    );
  }
}

class TollGateData {
  final String name;
  final String location;
  TollGateData({required this.name, required this.location});
}
