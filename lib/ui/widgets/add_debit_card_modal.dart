import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../resources/constants/color_constants.dart';
import '../../resources/constants/dimension_constants.dart';
import '../../resources/constants/font_constants.dart';
import '../../resources/constants/string_constants.dart';
import 'components.dart';
import 'custom_text.dart';
import 'long_divider.dart';
import 'modal_header_with_close_icon_widget.dart';

Future showAddDebitCardModal(BuildContext importedContext,
    {bool isTarget = true}) {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: importedContext,
    backgroundColor: white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(modalRadius.r),
          topRight: Radius.circular(modalRadius.r)),
    ),
    builder: (BuildContext context) {
      return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
              margin: EdgeInsets.only(
                  bottom: bottomPadding.h,
                  top: 14.h,
                  left: horizontalPadding.w,
                  right: horizontalPadding.w),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(modalRadius.r),
                    topRight: Radius.circular(modalRadius.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 14.h),
                  const ModalHeaderWithCloseIconWidget(),
                  SizedBox(
                    height: 49.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextWithLineHeight(
                              text: "",
                              fontSize: 16,
                              fontWeight: boldFont,
                              textColor: Color(0xFF1A202C),
                              alignCenter: true,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        const LongDivider(),
                        SizedBox(
                          height: 24.h,
                        ),
                        SizedBox(
                          height: 48.h,
                        ),
                        MainButton(proceed, () {
                          Navigator.pop(context);
                        })
                      ],
                    ),
                  ),
                ],
              )));
    },
  );
}
