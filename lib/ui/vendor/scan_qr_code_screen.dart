import 'dart:convert';
import 'package:brill_prime/providers/vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScanOrderScreen extends StatefulWidget {
  const ScanOrderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScanOrderScreenState();
}

class _ScanOrderScreenState extends State<ScanOrderScreen> {
  Barcode? _barcode;

  bool isScanned = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late VendorProvider vendorProvider;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!isScanned) {
      if (mounted) {
        try {
          setState(() {
            _barcode = barcodes.barcodes.firstOrNull;
            if (_barcode != null) {
              String barcodeValue = _barcode?.displayValue ?? "";
              if (barcodeValue.isNotEmpty) {
                final decodedBarcode = json.decode(barcodeValue);
                if (decodedBarcode["txRef"] == null || decodedBarcode["transactionId"] == null) {
                  throw FormatException('Invalid QR code format');
                }
                Navigator.pop(context,
                    (decodedBarcode["txRef"], decodedBarcode["transactionId"]));
                isScanned = true;
              }
            }
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error scanning QR code: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan Order',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    vendorProvider = context.watch<VendorProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    //   Scaffold(
    //   backgroundColor: black,
    //   body: SafeArea(
    //     // top: false,
    //     child: Column(
    //       children: <Widget>[
    //         const TopPadding(),
    //         const HashITAppBar(
    //           title: "",
    //           arrowBackColor: white,
    //         ),
    //         SizedBox(
    //           height: 50.h,
    //         ),
    //         SizedBox(height: 300.h, child: _buildQrView(context)),
    //         SizedBox(
    //           height: 135.h,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  // Widget _buildQrView(BuildContext context) {
  //   var scanArea = (MediaQuery.of(context).size.width < 400 ||
  //           MediaQuery.of(context).size.height < 400)
  //       ? 300.h
  //       : 300.h;
  //   // To ensure the Scanner view is properly sizes after rotation
  //   // we need to listen for Flutter SizeChanged notification and update controller
  //   return QRView(
  //     key: qrKey,
  //     onQRViewCreated: _onQRViewCreated,
  //     overlay: QrScannerOverlayShape(
  //         borderColor: white,
  //         borderRadius: 20,
  //         borderLength: 20,
  //         borderWidth: 13,
  //         cutOutSize: scanArea),
  //     onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
  //   );
  // }
  //
  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //       if (result?.code != null) {
  //         cryptoProvider.walletAddressController.text = result?.code ?? "";
  //         context.goNamed(sendCryptoScreen);
  //       }
  //     });
  //   });
  // }
  //
  // void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
  //   log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
  //   if (!p) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('no Permission')),
  //     );
  //   }
  // }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }
}
