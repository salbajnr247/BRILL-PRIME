import 'dart:convert';
import 'dart:typed_data';
import 'package:brill_prime/resources/constants/color_constants.dart';
import 'package:brill_prime/resources/constants/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../providers/toll_gate_provider.dart';
import '../../../../../resources/constants/dimension_constants.dart';
import '../../../../../resources/constants/font_constants.dart';
import '../../../../Widgets/custom_text.dart';
import '../../../../widgets/components.dart';

import 'dart:ui' as ui;

Future<void> showQRCodeDisplayDialog(BuildContext importedContext) async {
  showDialog(
      context: importedContext,
      builder: (BuildContext context) => QRCodeDisplayDialog(
            importedContext: importedContext,
          ));
}

class QRCodeDisplayDialog extends StatefulWidget {
  final BuildContext importedContext;
  const QRCodeDisplayDialog({super.key, required this.importedContext});

  @override
  State<QRCodeDisplayDialog> createState() => _QRCodeDisplayDialogState();
}

class _QRCodeDisplayDialogState extends State<QRCodeDisplayDialog> {
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    GlobalKey globalKey = GlobalKey();
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: Colors.transparent,
        child:
            Consumer<TollGateProvider>(builder: (ctx, tollGateProvider, child) {
          return CustomContainerButton(
            onTap: () {},
            title: "",
            borderRadius: 12,
            height: 328,
            verticalPadding: 10,
            horizontalPadding: 20,
            useHeight: true,
            widget: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 20,
                  left: 50,
                  right: 50,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: SizedBox(
                      width: 228,
                      height: 231,
                      child: QrImageView(
                        data: jsonEncode({
                          'txRef': tollGateProvider.selectedOrder?.txRef ?? "",
                          'transactionId':
                              tollGateProvider.selectedOrder?.transactionId ??
                                  ""
                        }),
                        version: QrVersions.auto,
                        dataModuleStyle: const QrDataModuleStyle(
                            color: mainColor,
                            dataModuleShape: QrDataModuleShape.square),
                        eyeStyle: const QrEyeStyle(
                            color: mainColor, eyeShape: QrEyeShape.square),
                      ),
                    ),
                  ),
                ),

                // 5531886652142950
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: BodyTextPrimaryWithLineHeight(
                    text: "${tollGateProvider.selectedOrder?.id}",
                    fontSize: 20,
                    maxLines: 1,
                    textColor: const Color.fromRGBO(1, 14, 66, 1),
                    fontWeight: extraBoldFont,
                  ),
                ),
                Positioned(
                    bottom: -35,
                    right: -5,
                    child: GestureDetector(
                      onTap: () {
                        debugPrint("Tapped::::::");
                        generateFile(globalKey,
                            isImage: true,
                            orderId: tollGateProvider.selectedOrder?.txRef);
                      },
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Image.asset(shareQRCodeIcon),
                      ),
                    ))
              ],
            ),
          );
        }));
  }

  void generateFile(GlobalKey key,
      {bool isImage = true, required String orderId}) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 4);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    if (isImage) {
      //share the image
      await Share.shareXFiles(
        [
          XFile.fromData(
            pngBytes,
            name: 'Brill Prime $orderId.png',
            mimeType: 'image/png',
          )
        ],
      );
    }
  }
}
