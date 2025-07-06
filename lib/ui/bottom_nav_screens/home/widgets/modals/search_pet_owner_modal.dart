// import 'package:canine_castle_mobile/Widgets/components.dart';
// import 'package:canine_castle_mobile/providers/helper_provider.dart';
// import 'package:canine_castle_mobile/resources/constants/image_constant.dart';
// import 'package:canine_castle_mobile/resources/navigation_utils.dart';
// import 'package:canine_castle_mobile/ui/bottom_nav_screens/home/search_pet_owner_dogs.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import '../../../../../Widgets/custom_text.dart';
// import '../../../../../resources/constants/color_constants.dart';
// import '../../../../../resources/constants/dimension_constants.dart';
// import '../../../../../resources/constants/font_constants.dart';
// import '../../../../../resources/styles_manager.dart';
// import '../../../../../widgets/custom_snack_back.dart';
// import '../../../../../widgets/pull_down_indicator.dart';
//
// Future showSearchPetOwnerModal(BuildContext importedContext,
//     {bool isTarget = true}) {
//   return showModalBottomSheet<void>(
//     isScrollControlled: true,
//     context: importedContext,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(modalRadius.r),
//           topRight: Radius.circular(modalRadius.r)),
//     ),
//     builder: (BuildContext context) {
//       return Padding(
//           padding: MediaQuery.of(context).viewInsets,
//           child:
//               Consumer<HelperProvider>(builder: (ctx, helperProvider, child) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (helperProvider.resMessage != '') {
//                 customSnackBar(context, helperProvider.resMessage);
//
//                 ///Clear the response message to avoid duplicate
//                 helperProvider.clear();
//               }
//             });
//             return Container(
//                 margin: EdgeInsets.only(bottom: bottomPadding.h, top: 14.h),
//                 decoration: BoxDecoration(
//                   color: white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(modalRadius.r),
//                       topRight: Radius.circular(modalRadius.r)),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     SizedBox(height: 14.h),
//                     const Center(child: PullDownIndicator()),
//                     SizedBox(
//                       height: 19.h,
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: horizontalPadding.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const BodyTextLightWithLineHeight(
//                             text: "Search Canine Owner",
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
//                       height: 40.h,
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: horizontalPadding.w),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               height: 48,
//                               decoration: BoxDecoration(
//                                 color: white,
//                                 borderRadius: BorderRadius.circular(50.r),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Color.fromRGBO(3, 31, 76, 0.1),
//                                     spreadRadius: 1,
//                                     blurRadius: 1,
//                                     offset: Offset(
//                                         1, 1), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   SizedBox(
//                                     width: 16.w,
//                                   ),
//                                   SvgPicture.asset(searchIconSvg),
//                                   SizedBox(
//                                     width: 10.w,
//                                   ),
//                                   Expanded(
//                                       child: TextField(
//                                     controller:
//                                         helperProvider.petOwnerNameController,
//                                     autofocus: false,
//                                     autocorrect: false,
//                                     onChanged: (value) {
//                                       if (helperProvider.petOwner != null) {
//                                         helperProvider.resetPetOwnerSearch(
//                                             resetSearchString: false);
//                                       }
//                                     },
//                                     cursorColor: mainColor,
//                                     textInputAction: TextInputAction.search,
//                                     onSubmitted: (value) {
//                                       helperProvider.searchPetOwner(
//                                           context: context);
//                                     },
//                                     decoration: const InputDecoration(
//                                       hintText: "Enter username",
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                       ),
//                                       disabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide.none,
//                                       ),
//                                     ),
//                                     style: textInputStyle(),
//                                   )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 44,
//                     ),
//                     if (helperProvider.petOwner != null)
//                       Column(
//                         children: [
//                           BodyTextPrimaryWithLineHeight(
//                             text: "${helperProvider.petOwner?.details.name}",
//                             fontWeight: semiBoldFont,
//                             fontSize: 20,
//                             textColor: blackTextColor,
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: horizontalPadding.w),
//                             child: MainButton("Get Canines", () {
//                               helperProvider.getSearchedOwnerDogs(
//                                   context: context);
//                               Navigator.pop(context);
//                               navToWithScreenName(
//                                   context: context,
//                                   screen: const SearchedPerOwnerDogsScreen());
//                             }),
//                           ),
//                         ],
//                       ),
//                     helperProvider.gettingPetOwner
//                         ? const Center(child: CupertinoActivityIndicator())
//                         : Container(),
//                     SizedBox(
//                       height: bottomPadding.h,
//                     ),
//                   ],
//                 ));
//           }));
//     },
//   );
// }
