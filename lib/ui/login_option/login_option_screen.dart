import 'dart:io';

import 'package:brill_prime/resources/constants/dimension_constants.dart';
import 'package:brill_prime/resources/constants/font_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:brill_prime/resources/constants/string_constants.dart';
import 'package:brill_prime/ui/widgets/components.dart';
import 'package:brill_prime/ui/widgets/custom_text.dart';
import 'package:brill_prime/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../login_screen/login_screen.dart';

class LoginOptionScreen extends StatelessWidget {
  const LoginOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                height: 133,
                width: 136,
                child: Image.asset(signUpLogoImg),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Consumer2<AuthProvider, DashboardProvider>(
                builder: (ctx, authProvider, dashboardProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MainButton(
                    consumer,
                    () {
                      authProvider.updateAccountType(consumer);
                      navToWithScreenName(
                          context: context, screen: const LoginScreen());
                    },
                    fontWeight: mediumFont,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MainButton(
                    vendor,
                    () {
                      authProvider.updateAccountType(vendor);
                      navToWithScreenName(
                          context: context, screen: const LoginScreen());
                    },
                    fontWeight: mediumFont,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MainButton(
                    driver,
                    () {},
                    fontWeight: mediumFont,
                    color: const Color.fromRGBO(11, 26, 81, 1),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const BodyTextPrimaryWithLineHeight(
                    text: "Make a selection to get started",
                    fontWeight: lightFont,
                    textColor: Color.fromRGBO(19, 19, 19, 1),
                  )
                ],
              );
            }),
          ),
          SizedBox(
            height: Platform.isAndroid ? bottomPadding.h : 0,
          )
        ],
      )),
    );
  }
}
