import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../resources/constants/image_constant.dart';
import '../../../../resources/constants/dimension_constants.dart';
import '../../../../resources/constants/font_constants.dart';
import '../../../Widgets/custom_text.dart';
import '../../../widgets/components.dart';

Future<void> showTransactionCompletedDialog(
  BuildContext importedContext, {
  bool barrierDismissible = false,
}) async {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: importedContext,
      builder: (BuildContext context) => TransactionCompletedDialog(
            importedContext: importedContext,
          ));
}

class TransactionCompletedDialog extends StatefulWidget {
  final BuildContext importedContext;
  const TransactionCompletedDialog({super.key, required this.importedContext});

  @override
  State<TransactionCompletedDialog> createState() =>
      _TransactionCompletedDialogState();
}

class _TransactionCompletedDialogState
    extends State<TransactionCompletedDialog> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context);
      Navigator.pop(widget.importedContext);
      setState(() {
        // Here you can write your code for open new view
      });
    });

    super.initState();
  }

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
                  width: 188,
                  child: Image.asset(congratulationsImg)),
              SizedBox(
                height: 20.h,
              ),
              const BodyTextPrimaryWithLineHeight(
                text: "Transaction Completed",
                textColor: Color(0xFF181B01),
                fontSize: 16,
                fontWeight: extraBoldFont,
              ),
            ],
          ),
        ));
  }
}
