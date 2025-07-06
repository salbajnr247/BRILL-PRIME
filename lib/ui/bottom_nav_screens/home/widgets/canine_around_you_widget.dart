// import 'package:canine_castle_mobile/providers/bottom_nav_provider.dart';
// import 'package:canine_castle_mobile/providers/search_provider.dart';
// import 'package:canine_castle_mobile/resources/constants/image_constant.dart';
// import 'package:canine_castle_mobile/resources/navigation_utils.dart';
// import 'package:canine_castle_mobile/ui/bottom_nav_screens/home/widgets/section_header_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../Widgets/custom_text.dart';
// import '../../../../providers/dashboard_provider.dart';
// import '../../../../resources/constants/color_constants.dart';
// import '../../../../resources/constants/dimension_constants.dart';
// import '../../../../resources/constants/font_constants.dart';
// import '../../../../resources/constants/string_constants.dart';
// import '../canine_around_you_detail_screen.dart';
//
// class CanineAroundYouWidget extends StatelessWidget {
//   const CanineAroundYouWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer3<DashboardProvider, SearchProvider, BottomNavProvider>(
//         builder: (ctx, dashboardProvider, searchProvider, bottomNavProvider, child) {
//       return dashboardProvider.dashboardInfoData!.canineAroundYou.isEmpty
//           ? Container()
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SectionHeaderWidget(
//                   onTap: () {
//                     searchProvider.updateIsDogTab(newValue: true);
//                     searchProvider.getAllCanines(context: context);
//                     bottomNavProvider.updateSelectedIndex(1);
//                   },
//                   title: "Around you",
//                   seeMoreText: seeAll,
//                 ),
//                 SizedBox(
//                   height: 16.h,
//                 ),
//                 SizedBox(
//                   height: 374,
//                   child: ListView.builder(
//                       itemCount: dashboardProvider
//                           .dashboardInfoData?.canineAroundYou.length,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         final canine = dashboardProvider
//                             .dashboardInfoData?.canineAroundYou[index];
//                         return Padding(
//                           padding: EdgeInsets.only(
//                               left: index == 0 ? horizontalPadding.w : 0,
//                               right: 12),
//                           child: InkWell(
//                             onTap: () {
//                               dashboardProvider
//                                   .updateSelectedCanineOfTheDay(canine);
//                               navToWithScreenName(
//                                   context: context,
//                                   screen: const CanineAroundYouDetailScreen());
//                             },
//                             child: SizedBox(
//                               height: 374,
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     width: 302,
//                                     height: 374,
//                                     decoration: BoxDecoration(
//                                         color: hintTextColor,
//                                         borderRadius: BorderRadius.circular(12),
//                                         image: DecorationImage(
//                                             image: NetworkImage(canine!
//                                                     .relationships
//                                                     .pictures
//                                                     .isEmpty
//                                                 ? ""
//                                                 : canine
//                                                     .relationships.pictures[0]),
//                                             fit: BoxFit.cover)),
//                                   ),
//                                   Container(
//                                     width: 302,
//                                     height: 374,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(12),
//                                       color: Colors.black.withOpacity(0.4),
//                                     ), // Adjust the color and opacity here
//                                   ),
//                                   Positioned(
//                                     bottom: 9,
//                                     left: 9,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           height: 100,
//                                         ),
//                                         BodyTextPrimaryWithLineHeight(
//                                           text: canine.name ?? "NA",
//                                           textColor: white,
//                                           fontWeight: boldFont,
//                                         ),
//                                         const SizedBox(
//                                           height: 12,
//                                         ),
//                                         BodyTextPrimaryWithLineHeight(
//                                           text: canine.relationships.breed ??
//                                               "NA",
//                                           textColor: white,
//                                           fontSize: 12,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Positioned(
//                                     bottom: 9,
//                                     right: 9,
//                                     child: Column(
//                                       children: [
//                                         CanineAroundYouItem(
//                                             value:
//                                                 "${canine.relationships.reviews.totalReviewsCount ?? '0'}",
//                                             icon: canineAroundYouStarIcon),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         CanineAroundYouItem(
//                                             value: "${canine.gender ?? 'NA'}",
//                                             icon: forYouMaleIcon),
//                                         const SizedBox(
//                                           height: 10,
//                                         ),
//                                         CanineAroundYouItem(
//                                             value:
//                                                 "${canine.relationships.state ?? '0'}",
//                                             icon: forYouLocationIcon),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                 ),
//               ],
//             );
//     });
//   }
// }
//
// class CanineAroundYouItem extends StatelessWidget {
//   final String icon;
//   final String value;
//   const CanineAroundYouItem(
//       {super.key, required this.value, required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SvgPicture.asset(icon),
//         const SizedBox(
//           height: 2,
//         ),
//         BodyTextPrimaryWithLineHeight(
//           text: value,
//           textColor: white,
//           fontSize: 10,
//           fontWeight: boldFont,
//         )
//       ],
//     );
//   }
// }
