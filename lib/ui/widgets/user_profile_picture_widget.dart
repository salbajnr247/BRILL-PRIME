import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:flutter/material.dart';

class UserProfilePictureWidget extends StatelessWidget {
  final String avatar;
  final double dimension;
  final VoidCallback onTap;
   const UserProfilePictureWidget(

      {super.key, this.avatar = userAvata, this.dimension = 70,
        required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: dimension,
        width: dimension,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
            image: DecorationImage(image: NetworkImage(userAvata))),
      ),
    );
  }
}
