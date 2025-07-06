// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:tryba/API/auth.dart';
// import 'package:tryba/Utils/constants.dart';
//
// import '../API/kyc.dart';
// import '../Screens/Auth/AccountOpening/Business/acct_opening_biz.dart';
// import '../Screens/Auth/AccountOpening/acct_opening_personal.dart';
// import '../Screens/KYC/business/kyc_biz.dart';
// import '../Screens/KYC/kyc_status.dart';
// import '../Screens/KYC/personal/kyc_personal.dart';
// import 'components.dart';
//
// class UnverifiedCard extends StatelessWidget {
//   const UnverifiedCard({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         bottom: 20,
//       ),
//       child: ListTile(
//         dense: true,
//         // onTap: () => Auth().isPersonal
//         //     ? Get.to(AcctOpeningScreen())
//         //     : Get.to(AcctOpeningBusiness()),
//         onTap: () => Get.to(AcctOpeningScreen()),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         tileColor: Color(0x21ffc106),
//         leading: Container(
//           height: 41,
//           width: 41,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             color: Color(0xffffc106).withOpacity(.3),
//           ),
//           child: Icon(Iconsax.verify, color: Color(0xffffc106)),
//         ),
//         title: Text(
//           'Account Unverified',
//           style: Get.textTheme.headline4,
//         ),
//         subtitle: Text(
//           'Click to verify your account',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class VerifCard extends StatelessWidget {
//   const VerifCard({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.amber, width: 1.5),
//         color: Colors.white,
//       ),
//       margin: const EdgeInsets.only(
//         bottom: 20,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'We need more information about you',
//             style: Get.textTheme.headline5,
//           ),
//           SizedBox(height: 5),
//           Text(
//             'We need more information about you to fully open your account.',
//             style: TextStyle(fontSize: 12),
//           ),
//           SizedBox(height: 10),
//           SizedBox(
//             width: Get.width * .5,
//             child: MainButton('Verify', () async {
//               // Get.to(KYCScreens());
//
//               KYCService().startSDK();
//             }),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class ResubmitCard extends StatelessWidget {
//   const ResubmitCard({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Get.to(KycStatus()),
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: mainColor,
//         ),
//         margin: const EdgeInsets.only(
//           bottom: 20,
//         ),
//         child: Text(
//           "Resubmit document",
//           style: TextStyle(
//             color: white,
//             fontSize: 11,
//           ),
//         ),
//       ),
//     );
//
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.amber, width: 1.5),
//         color: Colors.white,
//       ),
//       margin: const EdgeInsets.only(
//         bottom: 20,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Resubmit your document',
//             style: Get.textTheme.headline5,
//           ),
//           SizedBox(height: 5),
//           Text(
//             'We need to recheck your document(s), please click on resubmit button below.',
//             style: TextStyle(fontSize: 12),
//           ),
//           SizedBox(height: 10),
//           SizedBox(
//             width: Get.width * .5,
//             child: MainButton(
//               'Resubmit',
//               () async {
//                 Get.to(KycStatus());
//               },
//               color: Colors.amber,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class VerifProcessing extends StatelessWidget {
//   const VerifProcessing({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Get.to(KycStatus()),
//       child: Container(
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Color(0x14ffcc00),
//         ),
//         margin: const EdgeInsets.only(
//           bottom: 20,
//         ),
//         child: Text(
//           "Verification in progress",
//           style: TextStyle(
//             color: Color(0xffb87f03),
//             fontSize: 11,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class VerifDeclined extends StatelessWidget {
//   const VerifDeclined({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.red[400],
//       ),
//       margin: const EdgeInsets.only(
//         bottom: 20,
//       ),
//       child: Text(
//         'Unfortunately, we can not offer you an account.',
//         style: Get.textTheme.headline6.copyWith(color: Colors.white),
//       ),
//     );
//   }
// }
