// ignore_for_file: unnecessary_cast, unused_local_variable

import 'package:barcode_scanner/overlay/qr_scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final MobileScannerController _mobileScannerController = MobileScannerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: [
          MobileScanner(
            controller: _mobileScannerController,
            placeholderBuilder: (context, child) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue.shade900,
                ),
              );
            },
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? image = capture.image;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
          _flash(),
          _cameraSwitch(),
        ],
      ),
    );
  }

  Positioned _cameraSwitch() {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: ValueListenableBuilder(
            valueListenable: _mobileScannerController.cameraFacingState,
            builder: (context, state, child) {
              switch (state as CameraFacing) {
                case CameraFacing.front:
                  return const Icon(Icons.camera_front);
                case CameraFacing.back:
                  return const Icon(Icons.camera_rear);
              }
            },
          ),
          onPressed: () => _mobileScannerController.switchCamera(),
        ),
      ),
    );
  }

  Positioned _flash() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: ValueListenableBuilder(
            valueListenable: _mobileScannerController.torchState,
            builder: (context, state, child) {
              switch (state as TorchState) {
                case TorchState.off:
                  return const Icon(Icons.flash_off, color: Colors.grey);
                case TorchState.on:
                  return const Icon(Icons.flash_on, color: Colors.yellow);
              }
            },
          ),
          onPressed: () => _mobileScannerController.toggleTorch(),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.blue.shade900,
      title: const Text(
        'Mobile Scanner',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
