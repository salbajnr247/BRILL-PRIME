import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/image_constant.dart';
import 'components.dart';
import 'custom_text.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class HashITLoadingIndicator extends StatelessWidget {
  final String message;
  final String gif;
  const HashITLoadingIndicator({
    this.message = "Please hold on",
    this.gif = splashScreenLogo,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
        backgroundColor: Colors.transparent,
        child: CustomContainerButton(
          onTap: () {},
          title: "",
          height: 152.h,
          useHeight: true,
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 47.h,
                width: 47.h,
                child: Image.asset(
                  gif,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              CustomTextWithLineHeight(
                text: message,
                textColor: const Color.fromRGBO(24, 29, 38, 1),
                fontWeight: mediumFont,
                fontSize: 12,
              ),
            ],
          ),
        ));
  }
}
