import 'dart:developer';
import 'package:brill_prime/providers/bank_provider.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/ui/Widgets/custom_text.dart';
import 'package:brill_prime/ui/vendor/vendor_profile_screen.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/user_profile_picture_widget.dart';
import 'package:brill_prime/utils/functions.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../bank_account_information/manage_bank_accounts_screen.dart';
import '../support_screen/support_screen.dart';

class VendorDrawerWidget extends StatelessWidget {
  const VendorDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bankProvider = context.watch<BankProvider>();
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
                           UserProfilePictureWidget(
                             onTap: (){},
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
                            title: const Text("Bank Account Information"),
                            onTap: () {
                              bankProvider.getBanks(context: context);
                              Navigator.pop(context);
                              navToWithScreenName(
                                  context: context,
                                  screen: const ManageBankAccountsScreen());
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
                          log("list item taapped");
                        },
                      ),
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
                  "Switch to Consumer",
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
