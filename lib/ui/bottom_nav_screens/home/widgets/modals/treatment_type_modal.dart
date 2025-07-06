// import 'package:canine_castle_mobile/providers/helper_provider.dart';
// import 'package:canine_castle_mobile/resources/constants/image_constant.dart';
// import 'package:canine_castle_mobile/resources/navigation_utils.dart';
// import 'package:canine_castle_mobile/ui/bottom_nav_screens/home/treatment_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import '../../../../../Widgets/components.dart';
// import '../../../../../Widgets/custom_text.dart';
// import '../../../../../resources/constants/color_constants.dart';
// import '../../../../../resources/constants/dimension_constants.dart';
// import '../../../../../resources/constants/font_constants.dart';
// import '../../../../../resources/constants/string_constants.dart';
// import '../../../../../widgets/custom_snack_back.dart';
//
// Future showTreatmentTypeModal(BuildContext importedContext) {
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
//                           minHeight: MediaQuery.of(context).size.height * 0.4,
//                           maxHeight: MediaQuery.of(context).size.height * 0.6),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: horizontalPadding.w),
//                         child: helperProvider.gettingTreatmentTypes
//                             ? const Center(child: CupertinoActivityIndicator())
//                             : ListView.builder(
//                                 itemCount: helperProvider.treatmentTypes.length,
//                                 itemBuilder: (context, index) {
//                                   final treatmentType =
//                                       helperProvider.treatmentTypes[index];
//                                   return Padding(
//                                     padding: const EdgeInsets.only(bottom: 12),
//                                     child: CustomContainerButton(
//                                       onTap: () {
//                                         helperProvider
//                                             .updateSelectedTreatmentType(
//                                                 treatmentType,
//                                                 context: context);
//                                       },
//                                       title: "",
//                                       bgColor: helperProvider
//                                                   .selectedTreatmentType ==
//                                               treatmentType
//                                           ? const Color(0xFFFBF5F0)
//                                           : white,
//                                       borderColor: helperProvider
//                                                   .selectedTreatmentType ==
//                                               treatmentType
//                                           ? mainColor
//                                           : const Color(0xFFE6E6E6),
//                                       borderRadius: 11,
//                                       widget: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           BodyTextPrimaryWithLineHeight(
//                                             text: treatmentType.name,
//                                             textColor: const Color(0xFF0C0C0C),
//                                           ),
//                                           SvgPicture.asset(helperProvider
//                                                       .selectedTreatmentType ==
//                                                   treatmentType
//                                               ? checkedIconSvg
//                                               : uncheckedIconSvg)
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: horizontalPadding.w),
//                       child: MainButton(
//                         continueTo,
//                         () async {
//                           if (helperProvider.selectedTreatmentType != null) {
//                             Navigator.pop(context);
//                             navToWithScreenName(
//                                 context: context,
//                                 screen: const TreatmentScreen());
//                           }
//                         },
//                       ),
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
