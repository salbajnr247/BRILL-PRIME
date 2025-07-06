// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tryba/API/auth.dart';
//
// import '../API/plans.dart';
// import 'components.dart';
//
// void upgradeAcctAlert(Map planDetails, {required List personalPlans, required List bizPlans}) {
//   log(planDetails.toString());
//
//   String above_balance_hold = planDetails['plan']['plan']['above_balance_hold'];
//
//   String transaction = NumberFormat.currency(symbol: '£').format(
//       double.parse(planDetails['aboveTransferInTransaction']['transaction']['amount']));
//
//   String payment_ref = planDetails['aboveTransferInTransaction']['transaction_ref_id'];
//
//   int selValue;
//   Get.dialog(
//     StatefulBuilder(
//       builder: (context, refresh) {
//         return Dialog(
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Accept or Upgrade',
//                   style: Get.textTheme.headline5,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                     'There is an incoming transaction $transaction that is pending, sadly you have surpassed the balance of your account. You can upgrade to the next plan or continue for £$above_balance_hold'),
//                 SizedBox(height: 10),
//                 Text(
//                   'Select subscription plan you want to upgrade to',
//                   style: TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 SizedBox(height: 10),
//                 ListView.separated(
//                   itemCount: Auth().isPersonal ? personalPlans.length : bizPlans.length,
//                   shrinkWrap: true,
//                   separatorBuilder: (_, __) => SizedBox(height: 4),
//                   itemBuilder: (_, int index) {
//                     Map plan = Auth().isPersonal ? personalPlans[index] : bizPlans[index];
//
//                     return RadioListTile(
//                       value: plan['id'],
//                       groupValue: selValue,
//                       onChanged: (val) {
//                         refresh(() {
//                           selValue = val;
//                         });
//                       },
//                       contentPadding: EdgeInsets.zero,
//                       dense: true,
//                       title: Text(
//                         plan['name'] +
//                             ' - (£' +
//                             plan['amount'] +
//                             '/${plan['durationType']})',
//                       ),
//                     );
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 MainButton('Upgrade', () async {
//                   if (selValue != null) {
//                     showLoading('Processing', context);
//                     String result = await PlanService().upgradePlan(
//                       selValue.toString(),
//                     );
//
//                     Get.back();
//                     if (result == 'Success') {
//                       Get.back();
//                       // setState(() {});
//                       showToast('Plan Upgraded Successful');
//                     } else {
//                       showErrorToast(result);
//                     }
//                   } else {
//                     showErrorToast(
//                       'Please select a plan',
//                     );
//                   }
//                 }),
//                 SizedBox(height: 5),
//                 Text('or'),
//                 SizedBox(height: 5),
//                 MainButton(
//                   'Continue for £$above_balance_hold',
//                   () async {
//                     // showLoading('Processing', ctx)
//                     PlanService().aboveBalanceCharge(payment_ref);
//                   },
//                   color: Colors.red,
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
