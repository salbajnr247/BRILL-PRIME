// import 'package:canine_castle_mobile/providers/helper_provider.dart';
// import 'package:canine_castle_mobile/resources/constants/color_constants.dart';
// import 'package:canine_castle_mobile/resources/constants/image_constant.dart';
// import 'package:canine_castle_mobile/ui/bottom_nav_screens/home/widgets/modals/search_pet_owner_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class AddMedicalReportBannerWidget extends StatelessWidget {
//   const AddMedicalReportBannerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final helperProvider = context.watch<HelperProvider>();
//     return InkWell(
//       onTap: () {
//         helperProvider.resetPetOwnerSearch();
//         showSearchPetOwnerModal(context);
//       },
//       child: Container(
//         height: 78,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: secondaryColor,
//             image: const DecorationImage(
//                 image: AssetImage(addMedicalReportBanner), fit: BoxFit.cover)),
//       ),
//     );
//   }
// }
