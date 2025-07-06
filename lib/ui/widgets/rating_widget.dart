import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/constants/image_constant.dart';

class RatingWidget extends StatelessWidget {
  final int rating;
  const RatingWidget({super.key, this.rating = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(rating < 1 ? emptyStarIcon : filledStarIcon),
        const SizedBox(
          width: 10,
        ),
        SvgPicture.asset(rating < 2 ? emptyStarIcon : filledStarIcon),
        const SizedBox(
          width: 10,
        ),
        SvgPicture.asset(rating < 3 ? emptyStarIcon : filledStarIcon),
        const SizedBox(
          width: 10,
        ),
        SvgPicture.asset(rating < 4 ? emptyStarIcon : filledStarIcon),
        const SizedBox(
          width: 10,
        ),
        SvgPicture.asset(rating < 5 ? emptyStarIcon : filledStarIcon),
      ],
    );
  }
}
