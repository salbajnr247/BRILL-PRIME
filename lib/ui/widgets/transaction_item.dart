// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
// import 'package:tryba/Screens/Transactions/user_trx.dart';
// import 'package:tryba/Utils/constants.dart';
// import 'package:tryba/Utils/styles.dart';
//
// import '../Utils/functions.dart';
// import 'components.dart';
//
// class TransactionItem extends StatelessWidget {
//   final Map data;
//   const TransactionItem(this.data, {Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     String amount = formatCurrency(
//       double.parse(data['amount'].toString()),
//       currency: data['currency'],
//     );
//     String ref = data['reference'] ?? '';
//
//     String type = data['type'];
//     bool isPayin = type == 'PAYIN';
//     String recipient_name = data['recipient_name'];
//     String payer_name = data['payer_name'];
//
//     String title;
//     if (data['reference'] == 'Transaction fee' ||
//         data['reference'] == 'Card Tnx fee' ||
//         data['reference'] == 'Virtual fee') {
//       title = data['reference'];
//     } else {
//       title = isPayin ? payer_name : recipient_name;
//     }
//
//     bool isCard = data['model_name'] == 'card';
//
//     return ListTile(
//       onTap: () {
//         // if (!isCard) {
//         if (true) {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             backgroundColor: Colors.transparent,
//             builder: (ctx) {
//               return TransactionSheet(
//                 data: data,
//                 amount: amount,
//                 ref: ref,
//                 isPayin: isPayin,
//               );
//             },
//           );
//         } else {
//           Get.to(UserTransactions(
//             data: data,
//             amount: amount,
//             title: title,
//           ));
//         }
//       },
//       leading: isCard
//           ? Container(
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: mainColor,
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(Iconsax.card, color: white),
//             )
//           : firstLetter(title),
//       minLeadingWidth: 20,
//       title: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           Text(
//             formatDate(data['updated_at']),
//             style: TextStyle(
//               color: Color(0x7f000000),
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//       subtitle: isCard
//           ? Text(
//               'You paid ' + amount,
//               style: TextStyle(
//                 color: Color(0x7f000000),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             )
//           : Row(
//               children: [
//                 Image.asset(
//                   'assets/icons/money.png',
//                   height: 15,
//                 ),
//                 SizedBox(width: 5),
//                 Text(
//                   (isPayin ? 'You received ' : 'You sent ') + amount,
//                   style: TextStyle(
//                     color: Color(0x7f000000),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//       dense: true,
//       // tileColor:
//       //     isPayin ? Colors.green.withOpacity(.08) : Colors.red.withOpacity(.08),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//     );
//   }
// }
//
// class TransactionSheet extends StatelessWidget {
//   const TransactionSheet({
//     Key key,
//     @required this.data,
//     @required this.amount,
//     @required this.ref,
//     @required this.isPayin,
//   }) : super(key: key);
//
//   final Map data;
//   final String amount;
//   final String ref;
//   final bool isPayin;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isGBP = data['currency'] == 'GBP';
//     log(data.toString());
//     double fee = double.parse(data['fee'].toString());
//
//     bool showFee = fee > 0;
//
//     return Container(
//       height: Get.height * .85,
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(
//         vertical: 5,
//         horizontal: 20,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Align(
//             alignment: Alignment.centerRight,
//             child: IconButton(
//               onPressed: () => Get.back(),
//               icon: Icon(Iconsax.close_circle),
//               constraints: BoxConstraints(
//                 maxHeight: 30,
//                 maxWidth: 30,
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     (isPayin ? "+" : "-") + amount,
//                     style: TextStyle(
//                       color: Color(0xff181818),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   if (showFee)
//                     Text(
//                       "Transfer Fee: -" + formatCurrency(fee),
//                       style: TextStyle(
//                         color: Color(0x54000000),
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   Text(
//                     isPayin ? data['payer_name'] : data['recipient_name'],
//                     style: Get.textTheme.headline6.copyWith(color: mainColor),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     formatDate(data['updated_at']),
//                     style: TextStyle(fontSize: 10),
//                   ),
//                 ],
//               ),
//               Spacer(),
//               firstLetter(
//                   isPayin ? data['payer_name'] : data['recipient_name']),
//             ],
//           ),
//           SizedBox(height: 10),
//           // if (isPayin)
//           //   SizedBox(
//           //     width: Get.width * 0.5,
//           //     child: MainButton('Send again', () {}),
//           //   ),
//           SizedBox(height: 15),
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: Text(
//           //         "Status",
//           //         style: Get.textTheme.headline6,
//           //       ),
//           //     ),
//           //     Text(
//           //       data['payment_status'].toString().capitalizeFirst,
//           //       style: TextStyle(
//           //         fontWeight: FontWeight.bold,
//           //         color:
//           //             data['payment_status'] == 'FAILED' ? Colors.red : Colors.green,
//           //       ),
//           //     ),
//           //   ],
//           // ),
//           // SizedBox(height: 15),
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: Text(
//           //         "Amount",
//           //         style: Get.textTheme.headline6,
//           //       ),
//           //     ),
//           //     Text(amount),
//           //   ],
//           // ),
//           Container(
//             decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             width: double.infinity,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Reference',
//                   style: TxtStyles.title12().copyWith(color: Colors.grey),
//                 ),
//                 SizedBox(height: 5),
//                 Text(
//                   ref,
//                   style: Get.textTheme.headline6.copyWith(fontSize: 14),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 15),
//           Container(
//             decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             width: double.infinity,
//             padding: EdgeInsets.all(10),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 data['recipient_name'] == 'TRYBA'
//                     ? SizedBox()
//                     : Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   isGBP ? "Account Number" : "IBAN",
//                                   style: TxtStyles.title12()
//                                       .copyWith(color: Colors.grey),
//                                 ),
//                               ),
//                               Text(
//                                 isPayin
//                                     ? data['payer_account_number'] ?? ''
//                                     : data['recipient_account_number'] ?? '',
//                                 style: Get.textTheme.headline6,
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   isGBP ? "Sort Code" : 'BIC',
//                                   style: TxtStyles.title12()
//                                       .copyWith(color: Colors.grey),
//                                 ),
//                               ),
//                               Text(
//                                 isPayin
//                                     ? data['payer_sort_code'] ?? ''
//                                     : data['recipient_sort_code'] ?? '',
//                                 style: Get.textTheme.headline6,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//               ],
//             ),
//           ),
//           SizedBox(height: 15),
//           Container(
//             decoration: BoxDecoration(
//               color: white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: ListTile(
//               onTap: () {},
//               tileColor: white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               title: Text(
//                 'Confirmation',
//                 style: TxtStyles.title12().copyWith(color: Colors.grey),
//               ),
//               dense: true,
//               trailing: FittedBox(
//                 child: Row(
//                   children: [
//                     Icon(
//                       Iconsax.document_download,
//                       color: mainColor,
//                       size: 20,
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       "Download",
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: mainColor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 15),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0x1eff784b),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: ListTile(
//               onTap: () {},
//               tileColor: Color(0x1eff784b),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               title: Text(
//                 'Report an issue',
//                 style: TextStyle(
//                   color: Color(0xffff784b),
//                 ),
//               ),
//               dense: true,
//               trailing: Icon(
//                 Icons.arrow_forward_ios,
//                 size: 15,
//                 color: Color(0xffff784b),
//               ),
//             ),
//           )
//         ],
//       ),
//       // ),
//     );
//   }
// }
//
// class TransactionItemNew extends StatelessWidget {
//   final Map data;
//   const TransactionItemNew(this.data, {Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     String amount = formatCurrency(
//       double.parse(data['amount'].toString()),
//       currency: data['currency'],
//     );
//
//     String ref = data['reference'] ?? '';
//
//     String type = data['type'];
//     bool isPayin = type == 'PAYIN';
//     String recipient_name = data['recipient_name'];
//     String payer_name = data['payer_name'];
//
//     String title;
//     if (data['reference'] == 'Transaction fee' ||
//         data['reference'] == 'Card Tnx fee' ||
//         data['reference'] == 'Virtual fee') {
//       title = data['reference'];
//     } else {
//       title = "Money ${isPayin ? 'from $payer_name' : 'to $recipient_name'}";
//     }
//
//     bool isCard = data['model_name'] == 'card';
//
//     return ListTile(
//       onTap: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder: (ctx) {
//             return TransactionSheet(
//               data: data,
//               amount: amount,
//               ref: ref,
//               isPayin: isPayin,
//             );
//           },
//         );
//       },
//       leading: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8,
//         ),
//         child: Icon(
//           isCard
//               ? Iconsax.card
//               : isPayin
//                   ? Icons.arrow_downward_rounded
//                   : Icons.arrow_upward_rounded,
//           color: isPayin ? Colors.green : Colors.red,
//           size: 25,
//         ),
//       ),
//       minLeadingWidth: 25,
//       contentPadding: EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 0,
//       ),
//       title: Text(
//         title,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//         ),
//       ),
//       subtitle: Row(
//         children: [
//           Text(
//             formatDate(data['updated_at']),
//             style: TextStyle(
//               color: Color(0xff718096),
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Spacer(),
//         ],
//       ),
//       trailing: Text(
//         (isPayin ? '+' : '-') + amount,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//           color: isPayin ? Colors.green : Colors.red,
//         ),
//       ),
//       dense: true,
//     );
//   }
// }
