import 'dart:developer';
import 'package:brill_prime/providers/toll_gate_provider.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/consumer/toll_gates/consumer_orders_screen.dart';
import 'package:brill_prime/ui/support_screen/support_screen.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/functions.dart';
import '../vendor/vendor_profile_screen.dart';
import 'components.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final tollGateProvider = context.watch<TollGateProvider>();
    return Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.zero, bottomRight: Radius.zero),
        ),
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
              return Column(children: [
                GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(userAvata))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BodyTextPrimaryWithLineHeight(
                                text:
                                    "Hi, ${getFirstWordInSentence(authProvider.userProfile?.data.fullName ?? '')}",
                                fontWeight: extraBoldFont,
                                fontSize: 20,
                                textColor: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
                const SizedBox(height: 10),
                Expanded(
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: const Text(
                          "Account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          ListTile(
                            title: const Text("Profile"),
                            onTap: () {
                              Navigator.pop(context);
                              navToWithScreenName(
                                  context: context,
                                  screen: const VendorProfileScreen());
                            },
                          ),
                          ListTile(
                            title: const Text("Update Password"),
                            onTap: () {
                              // Navigate to Update Password Page
                            },
                          ),
                          ListTile(
                            title: const Text("Payment Method"),
                            onTap: () {
                              // Navigate to Payment Method Page
                            },
                          ),
                          SwitchListTile(
                            title: const Text("Notification"),
                            value:
                                true, // Replace with a variable for notification state
                            onChanged: (value) {
                              // Handle toggle action
                            },
                          ),
                        ],
                      ),
                      ListTile(
                          title: const Text(
                            "Transaction History",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              //color: pBlack,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            tollGateProvider.getConsumerOrders(
                                context: context);
                            Navigator.pop(context);
                            navToWithScreenName(
                                context: context,
                                screen: const ConsumerOrderScreen());
                          }),
                      ListTile(
                        title: const Text(
                          "Support",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            //color: pBlack,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context);
                          navToWithScreenName(
                              context: context, screen: const SupportScreen());
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "About",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            //color: pBlack,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          log("list item taapped");
                        },
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
                OutlineBtn(
                  "Switch to Account",
                  () {
                    Navigator.pop(context);
                    logoutAndClearHive(context: context);
                  },
                  borderColor: const Color.fromRGBO(70, 130, 180, 1),
                  textColor: const Color.fromRGBO(70, 130, 180, 1),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlineBtn(
                  "Sign out",
                  () {
                    Navigator.pop(context);
                    logoutAndClearHive(context: context);
                  },
                  borderColor: const Color.fromRGBO(255, 94, 94, 1),
                  textColor: const Color.fromRGBO(255, 94, 94, 1),
                ),
              ]);
            })));
  }
}
