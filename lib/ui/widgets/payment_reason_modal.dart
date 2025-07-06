// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:provider/provider.dart';
// import '../model/payment_reason_model.dart';
// import '../providers/wallet_provider.dart';
// import '../resources/constants/color_constants.dart';
// import '../resources/constants/font_constants.dart';
// import '../resources/constants/string_constants.dart';
// import 'components.dart';
// import 'custom_text.dart';
//
// Future showPaymentReasonModal(
//   BuildContext context,
// ) {
//   return showMaterialModalBottomSheet(
//     backgroundColor: Colors.transparent,
//     context: context,
//     builder: (context) => StatefulBuilder(builder: (context, setStateSB) {
//       return Container(
//         constraints: BoxConstraints(minHeight: 400.h, maxHeight: 656.h),
//         decoration: BoxDecoration(
//           color: white,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
//         ),
//         child: Consumer<WalletProvider>(builder: (ctx, walletProvider, child) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 18.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     SemiBold16px(text: selectAnOption),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 39.h,
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 6.w,
//                     ),
//                     const BodyTextPrimaryWithLineHeight(
//                       text: whatsYourPaymentFor,
//                       textColor: black,
//                       fontWeight: boldFont,
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: 14.h,
//                 ),
//                 const CustomTextNoOverFlow(
//                   text: lettingUsKnowYourPaymentReason,
//                   textColor: Color.fromRGBO(64, 63, 63, 0.49),
//                 ),
//                 SizedBox(
//                   height: 34.h,
//                 ),
//                 SizedBox(
//                   // height: 200.h,
//                   child: ListView.builder(
//                       padding: const EdgeInsets.all(0),
//                       itemCount: paymntReasons.length,
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         final paymentReason = paymntReasons[index];
//                         return Padding(
//                           padding: EdgeInsets.only(top: 11.h),
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 15.h, horizontal: 11.w),
//                             decoration: BoxDecoration(
//                                 color: walletProvider
//                                             .selectedPaymentReason?.title ==
//                                         paymentReason.title
//                                     ? lightBlueTextColor
//                                     : white,
//                                 borderRadius: BorderRadius.circular(9.r)),
//                             child: InkWell(
//                               onTap: () {
//                                 walletProvider
//                                     .changeSelectedPaymentReason(paymentReason);
//                               },
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           BodyTextPrimaryWithLineHeight(
//                                             text: paymentReason.title,
//                                             textColor: walletProvider
//                                                         .selectedPaymentReason
//                                                         ?.title ==
//                                                     paymentReason.title
//                                                 ? white
//                                                 : black,
//                                             fontSize: 13,
//                                             fontWeight: semiBoldFont,
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 9.h,
//                                       ),
//                                       SizedBox(
//                                         width: 263.w,
//                                         child: BodyTextPrimaryWithLineHeight(
//                                           text: paymentReason.subtitle,
//                                           textColor: walletProvider
//                                                       .selectedPaymentReason
//                                                       ?.title ==
//                                                   paymentReason.title
//                                               ? white
//                                               : const Color.fromRGBO(
//                                                   0, 0, 0, 0.47),
//                                           fontSize: 12,
//                                           fontWeight: semiBoldFont,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                     height: 18.h,
//                                     width: 18.h,
//                                     decoration: BoxDecoration(
//                                         borderRadius:
//                                             BorderRadius.circular(100.r),
//                                         border: Border.all(
//                                             width: paymentReason.title ==
//                                                     walletProvider
//                                                         .selectedPaymentReason
//                                                         ?.title
//                                                 ? 2
//                                                 : 1,
//                                             color: paymentReason.title ==
//                                                     walletProvider
//                                                         .selectedPaymentReason
//                                                         ?.title
//                                                 ? white
//                                                 : const Color.fromRGBO(
//                                                     0, 0, 0, 0.33))),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                 ),
//                 SizedBox(
//                   height: 49.h,
//                 ),
//                 MainButton(
//                   proceed,
//                   () {
//                     if (walletProvider.selectedPaymentReason != null) {
//                       Navigator.pop(context);
//                     }
//                   },
//                   color: black,
//                 ),
//                 SizedBox(
//                   height: 39.h,
//                 ),
//               ],
//             ),
//           );
//         }),
//       );
//     }),
//   );
// }
