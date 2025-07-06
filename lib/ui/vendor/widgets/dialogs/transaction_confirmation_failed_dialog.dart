import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../resources/constants/image_constant.dart';
import '../../../../resources/constants/dimension_constants.dart';
import '../../../../resources/constants/font_constants.dart';
import '../../../Widgets/custom_text.dart';
import '../../../widgets/components.dart';

Future<void> showTransactionConfirmationFailedDialog(
  BuildContext importedContext, {
  bool barrierDismissible = true,
}) async {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: importedContext,
      builder: (BuildContext context) => TransactionConfirmationFailedDialog(
            importedContext: importedContext,
          ));
}

class TransactionConfirmationFailedDialog extends StatefulWidget {
  final BuildContext importedContext;
  const TransactionConfirmationFailedDialog(
      {super.key, required this.importedContext});

  @override
  State<TransactionConfirmationFailedDialog> createState() =>
      _TransactionConfirmationFailedDialogState();
}

class _TransactionConfirmationFailedDialogState
    extends State<TransactionConfirmationFailedDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: Colors.transparent,
        child: CustomContainerButton(
          onTap: () {},
          title: "",
          borderRadius: 12,
          height: 328,
          verticalPadding: 10,
          horizontalPadding: 20,
          useHeight: true,
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                  height: 188,
                  width: 210,
                  child: Image.asset(confirmationFailImg)),
              SizedBox(
                height: 20.h,
              ),
              const BodyTextPrimaryWithLineHeight(
                text: "Oops! Try Again",
                textColor: Color(0xFF181B01),
                fontSize: 16,
                fontWeight: extraBoldFont,
              ),
            ],
          ),
        ));
  }
}
