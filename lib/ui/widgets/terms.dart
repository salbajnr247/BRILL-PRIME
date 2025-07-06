import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/constants/color_constants.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            color: black.withOpacity(.7),
            fontWeight: FontWeight.w500,
            fontSize: 10,
            height: 2,
          ),
          text:
              'I have read and agreed to receive electronic communication about my account and service in accordance with',
          children: [
            TextSpan(
              text: 'Tryba\'s T&Cs',
              recognizer: TapGestureRecognizer()
                ..onTap = () => launchUrl(
                    Uri.parse("https://tryba.io/terms-and-conditions")),
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: mainColor,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: "Modulr T&Cs",
              recognizer: TapGestureRecognizer()
                ..onTap =
                    () => launchUrl(Uri.parse("https://tryba.io/modulr-terms")),
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: mainColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
