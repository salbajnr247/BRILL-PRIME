//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import '../../../../../resources/constants/color_constants.dart';
// import '../../../../../resources/constants/dimension_constants.dart';
// import '../../../../../resources/constants/font_constants.dart';
//
// Future showConfirmSubmitModal(BuildContext importedContext) {
//   return showModalBottomSheet<void>(
//     isScrollControlled: true,
//     context: importedContext,
//     backgroundColor: white,
//     isDismissible: false,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(modalRadius.r),
//           topRight: Radius.circular(modalRadius.r)),
//     ),
//     builder: (BuildContext context) {
//       return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child: Container(
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: white,
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(modalRadius.r),
//                     topRight: Radius.circular(modalRadius.r)),
//               ),
//               child: Consumer<HelperProvider>(
//                   builder: (ctx, helperProvider, child) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (helperProvider.resMessage != '') {
//                     customSnackBar(context, helperProvider.resMessage,
//                         isError: helperProvider.isErrorMessage);
//
//                     ///Clear the response message to avoid duplicate
//                     helperProvider.clear();
//                   }
//                 });
//                 return Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: horizontalPadding.w),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 10.h,
//                       ),
//                       Row(
//                         children: [
//                           SvgPicture.asset(dogRequestInformationIcon),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       const BodyTextPrimaryWithLineHeight(
//                         text: "Submit Medical Report",
//                         textColor: Color(0xFF181B01),
//                         fontSize: 16,
//                         fontWeight: semiBoldFont,
//                       ),
//                       SizedBox(
//                         height: 8.h,
//                       ),
//                       Consumer<CanineProvider>(
//                           builder: (ctx, canineProvider, child) {
//                         return RichText(
//                           textAlign: TextAlign.start,
//                           text: TextSpan(
//                             text:
//                                 "A request to add a medical report will be sent to the dog owner. \nUpon acceptance, you will able to add report, check your request page for further updates.",
//                             style: getRichTextStyle(
//                                 fontSize: 12,
//                                 textColor: black,
//                                 fontWeight: regularFont),
//                             children: <TextSpan>[],
//                           ),
//                         );
//                       }),
//                       SizedBox(
//                         height: 20.h,
//                       ),
//                       Consumer2<TreatmentProvider, CanineProvider>(builder:
//                           (ctx, treatmentProvider, canineProvider, child) {
//                         WidgetsBinding.instance.addPostFrameCallback((_) {
//                           if (treatmentProvider.resMessage != '') {
//                             customSnackBar(
//                                 context, treatmentProvider.resMessage,
//                                 isError: treatmentProvider.isErrorMessage);
//
//                             ///Clear the response message to avoid duplicate
//                             treatmentProvider.clear();
//                           }
//                         });
//                         return treatmentProvider.submittingMedicalReport
//                             ? const Center(
//                                 child: CupertinoActivityIndicator(),
//                               )
//                             : Row(
//                                 children: [
//                                   Expanded(
//                                       child: MainButton(
//                                     "Cancel",
//                                     () {
//                                       Navigator.pop(context);
//                                     },
//                                     color: const Color(0xFFFBF5F0),
//                                     textColor: mainColor,
//                                   )),
//                                   SizedBox(
//                                     width: 10.w,
//                                   ),
//                                   Expanded(
//                                       child: MainButton("Submit", () async {
//                                     bool recordSubmitted =
//                                         await treatmentProvider
//                                             .createMedicalRecord(
//                                                 context: context);
//
//                                     canineProvider.getSingleCanine(
//                                         context: context,
//                                         canineSlug: canineProvider
//                                                 .selectedCanine?.slug ??
//                                             "");
//                                     debugPrint(
//                                         "Medical Report Submitted:::: $recordSubmitted In Modal");
//                                   })),
//                                 ],
//                               );
//                       }),
//                       SizedBox(
//                         height: bottomPadding.h,
//                       ),
//                     ],
//                   ),
//                 );
//               })));
//     },
//   );
// }
