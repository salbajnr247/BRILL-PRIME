// import 'package:flutter/material.dart';
// import '../Utils/constants.dart';
// import '../Utils/styles.dart';
//
// class CustomTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//   final Color color;
//   final bool dense;
//   final Color iconColor;
//   final Color iconBg;
//   final Widget trailing;
//   final Color textColor;
//   final double gap;
//   final String? img;
//   final double borderRadius;
//
//   const CustomTile({
//     Key? key,
//     this.icon,
//     this.title,
//     this.subtitle,
//     this.onTap,
//     this.color = tileColor,
//     this.dense = true,
//     this.iconColor = mainColor,
//     this.iconBg = iconBgColor,
//     this.trailing,
//     this.textColor = black,
//     this.gap = 16,
//     this.img,
//     this.borderRadius = 22,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       dense: dense,
//       onTap: onTap,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       tileColor: color,
//       horizontalTitleGap: gap,
//       leading: Container(
//         height: 41,
//         width: 41,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(borderRadius),
//           color: iconBg,
//         ),
//         child: img != null
//             ? Image.asset(img!)
//             : Icon(icon, color: iconColor),
//       ),
//       title: Text(
//         title,
//         style: TextStyle(
//           color: textColor,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       subtitle: subtitle == null
//           ? SizedBox()
//           : Text(
//               subtitle,
//               style: TextStyle(
//                 color: textColor,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//       trailing: trailing ??
//           Icon(
//             Icons.arrow_forward_ios_sharp,
//             color: textColor,
//             size: 18,
//           ),
//     );
//   }
// }
//
// class CustomImgTile extends StatelessWidget {
//   final String img;
//   final String title;
//   final VoidCallback onTap;
//   const CustomImgTile({
//     Key key,
//     this.img,
//     this.title,
//     this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       tileColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//       onTap: onTap,
//       dense: true,
//       title: Text(
//         title,
//         style: TxtStyles.title14(),
//       ),
//       leading: Image.asset(
//         img,
//         width: 30,
//         height: 30,
//       ),
//     );
//   }
// }
//
// const Color tileColor = Color(0xfff2f2f2);
// const Color iconBgColor = Color(0x1100afef);
