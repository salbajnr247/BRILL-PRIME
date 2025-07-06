// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../custom_text.dart';
// import '../pull_down_indicator.dart';
//
// Future showGenderSelectionModal(
//   BuildContext context,
// ) {
//   return showMaterialModalBottomSheet(
//     backgroundColor: Colors.transparent,
//     context: context,
//     builder: (context) => StatefulBuilder(builder: (context, setStateSB) {
//       return Container(
//         constraints: BoxConstraints(minHeight: 100.h, maxHeight: 656.h),
//         decoration: BoxDecoration(
//           color: white,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
//         ),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 14.h),
//               const PullDownIndicator(),
//               SizedBox(
//                 height: 19.h,
//               ),
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SemiBold16px(text: selectAnOption),
//                 ],
//               ),
//
//               SizedBox(
//                 height: 14.h,
//               ),
//               //
//               // SizedBox(height: 49.h,),
//               // MainButton(proceed, () {
//               //   Navigator.pop(context);
//               // },
//               //   color: black,),
//
//               SizedBox(
//                 height: 20.h,
//               ),
//             ],
//           ),
//         ),
//       );
//     }),
//   );
// }
