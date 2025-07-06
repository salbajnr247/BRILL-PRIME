import 'package:flutter/material.dart';

import 'components.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDone;
  final String doneText;
  const SuccessScreen(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onDone,
      this.doneText = 'Done'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/kyc/approval.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff3f3e3e),
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: MainButton(doneText, onDone),
      ),
    );
  }
}
