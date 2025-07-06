import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/constants/color_constants.dart';
import '../../resources/constants/image_constant.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final double height;
  final String imageUrl;
  final double? width;
  final double topLeftRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double topRightRadius;
  final BoxFit? fit;
  const CachedNetworkImageWidget({
    super.key,
    required this.height,
    required this.imageUrl,
    this.width,
    this.topLeftRadius = 10,
    this.topRightRadius = 10,
    this.bottomLeftRadius = 10,
    this.bottomRightRadius = 10,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: hintTextColor,
                image: const DecorationImage(
                    image: NetworkImage(networkImagePlaceHolder),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius.r),
                  bottomLeft: Radius.circular(bottomLeftRadius.r),
                  topRight: Radius.circular(topRightRadius.r),
                  bottomRight: Radius.circular(bottomRightRadius.r),
                )),
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius),
                  bottomLeft: Radius.circular(bottomLeftRadius),
                  topRight: Radius.circular(topRightRadius),
                  bottomRight: Radius.circular(bottomRightRadius),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.cover,
                ),
                // color: ColorManager.primaryColor
              ),
            ),
            placeholder: (context, url) => Container(
              width: width,
              height: height,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFFF9F9F9), Color(0xFFFAFAFA)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topLeftRadius.r),
                    bottomLeft: Radius.circular(bottomLeftRadius.r),
                    topRight: Radius.circular(topRightRadius.r),
                    bottomRight: Radius.circular(bottomRightRadius.r),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }
}
