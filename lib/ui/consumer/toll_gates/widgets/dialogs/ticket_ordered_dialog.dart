import 'package:brill_prime/providers/auth_provider.dart';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/ui/consumer/toll_gates/widgets/dialogs/qr_code_display_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../resources/constants/dimension_constants.dart';
import '../../../../../resources/constants/font_constants.dart';
import '../../../../../resources/constants/image_constant.dart';
import '../../../../Widgets/custom_text.dart';
import '../../../../widgets/components.dart';
import '../../../../widgets/custom_snack_back.dart';

Future<void> showTicketOrderedDialog(
  BuildContext importedContext, {
  bool barrierDismissible = false,
}) async {
  showDialog(
      barrierDismissible: barrierDismissible,
      context: importedContext,
      builder: (BuildContext context) => TicketOrderedDialog(
            importedContext: importedContext,
          ));
}

class TicketOrderedDialog extends StatefulWidget {
  final BuildContext importedContext;
  const TicketOrderedDialog({super.key, required this.importedContext});

  @override
  State<TicketOrderedDialog> createState() => _TicketOrderedDialogState();
}

class _TicketOrderedDialogState extends State<TicketOrderedDialog> {
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
          height: 162,
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
              const BodyTextPrimaryWithLineHeight(
                text: "Payment Successful!",
                textColor: Color(0xFF181B01),
                fontSize: 16,
                fontWeight: extraBoldFont,
              ),
              SizedBox(
                height: 20.h,
              ),
              Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (authProvider.resMessage != '') {
                    customSnackBar(context, authProvider.resMessage,
                        isError: authProvider.isErrorMessage);

                    ///Clear the response message to avoid duplicate
                    authProvider.clear();
                  }
                });
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: MainButton(
                          "",
                          () async {
                            Navigator.pop(context);
                            showQRCodeDisplayDialog(widget.importedContext);
                          },
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 27,
                                width: 27,
                                child: Image.asset(scanQRCodeWhiteIcon),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const BodyTextPrimaryWithLineHeight(
                                text: "Generate QR",
                                fontSize: 16,
                                textColor: white,
                              )
                            ],
                          ),
                          color: const Color.fromRGBO(11, 26, 81, 1),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          ),
        ));
  }
}
