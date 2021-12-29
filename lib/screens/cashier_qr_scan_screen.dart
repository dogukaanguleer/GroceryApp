import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreenWidget extends StatefulWidget {
  const QRScreenWidget({Key? key}) : super(key: key);

  @override
  _QRScreenWidgetState createState() => _QRScreenWidgetState();
}

class _QRScreenWidgetState extends State<QRScreenWidget> {
  final recognisedCodes = <ExpectedScanResult>[
    ExpectedScanResult('cake', Icons.cake),
    ExpectedScanResult('cocktail', Icons.local_drink_outlined),
    ExpectedScanResult('coffee', Icons.coffee),
    ExpectedScanResult('burger', Icons.fastfood_rounded),
  ];

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      // controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR SCAN'),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        // alignment: Alignment.center,
        // fit: StackFit.passthrough,
        children: [
          QRView(
            cameraFacing: CameraFacing.back,
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderRadius: 10,
              borderWidth: 5,
              borderColor: Colors.white,
            ),
          ),
          // Container(
          //   color: Colors.white,
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 7,
              width: double.maxFinite,
              color: Colors.cyan.withOpacity(0.2),
              child: Center(
                child: Text(
                  'Scan the order',
                  style: Theme.of(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    final expectedCodes = recognisedCodes.map((e) => e.type);
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if (expectedCodes.any((element) => scanData.code == element)) {}
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ExpectedScanResult {
  final String type;
  final IconData icon;

  ExpectedScanResult(this.type, this.icon);
}
