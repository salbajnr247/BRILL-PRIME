// import 'package:canine_castle_mobile/providers/treatment_provider.dart';
// import 'package:canine_castle_mobile/resources/constants/image_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import '../../../../../Widgets/components.dart';
// import '../../../../../Widgets/custom_text.dart';
// import '../../../../../resources/constants/color_constants.dart';
// import '../../../../../resources/constants/dimension_constants.dart';
// import '../../../../../resources/constants/font_constants.dart';
// import '../../../../../widgets/custom_snack_back.dart';
//
// Future showTreatmentFrequencyModal(BuildContext importedContext) {
//   return showModalBottomSheet<void>(
//     isScrollControlled: true,
//     context: importedContext,
//     backgroundColor: white,
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
//               child: Consumer<TreatmentProvider>(
//                   builder: (ctx, treatmentProvider, child) {
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (treatmentProvider.resMessage != '') {
//                     customSnackBar(context, treatmentProvider.resMessage,
//                         isError: treatmentProvider.isErrorMessage);
//
//                     ///Clear the response message to avoid duplicate
//                     treatmentProvider.clear();
//                   }
//                 });
//                 return Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 20.h,
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: horizontalPadding.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const BodyTextLightWithLineHeight(
//                             text: "Select treatment",
//                             textColor: blackTextColor,
//                             fontSize: 23,
//                             fontWeight: semiBoldFont,
//                           ),
//                           InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: SvgPicture.asset(closeIconSvg)),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 14.h,
//                     ),
//                     Container(
//                       constraints: BoxConstraints(
//                           minHeight: MediaQuery.of(context).size.height * 0.2,
//                           maxHeight: MediaQuery.of(context).size.height * 0.4),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: horizontalPadding.w),
//                         child: ListView.builder(
//                             itemCount: treatmentFrequencies.length,
//                             itemBuilder: (context, index) {
//                               final treatmentType = treatmentFrequencies[index];
//                               return Padding(
//                                 padding: const EdgeInsets.only(bottom: 12),
//                                 child: CustomContainerButton(
//                                   onTap: () {
//                                     treatmentProvider
//                                         .updateSelectedTreatmentFrequency(
//                                             treatmentType);
//                                     Navigator.pop(context);
//                                   },
//                                   title: "",
//                                   bgColor: treatmentProvider
//                                               .selectedTreatmentFrequency ==
//                                           treatmentType
//                                       ? const Color(0xFFFBF5F0)
//                                       : white,
//                                   borderColor: treatmentProvider
//                                               .selectedTreatmentFrequency ==
//                                           treatmentType
//                                       ? mainColor
//                                       : const Color(0xFFE6E6E6),
//                                   borderRadius: 11,
//                                   widget: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       BodyTextPrimaryWithLineHeight(
//                                         text: treatmentType,
//                                         textColor: const Color(0xFF0C0C0C),
//                                       ),
//                                       SvgPicture.asset(treatmentProvider
//                                                   .selectedTreatmentFrequency ==
//                                               treatmentType
//                                           ? checkedIconSvg
//                                           : uncheckedIconSvg)
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     SizedBox(
//                       height: 32.h,
//                     ),
//                   ],
//                 );
//               })));
//     },
//   );
// }
