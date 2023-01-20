import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../completed_dailog/completed_dailog.dart';
import '../main/main_screen.dart';
class CreateQrPage extends StatelessWidget {
  final qrKey = GlobalKey();
 String currentcow = "";
  CreateQrPage({Key? key, required this.currentcow}) : super(key: key);

  takeScreenShot(BuildContext contextx) async {
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {

      final qrValidationResult = QrValidator.validate(
        data: currentcow,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
      );
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode as QrCode,
        color: const Color(0xFFFFFFFF),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );
      final directory = (await getApplicationDocumentsDirectory()).path;
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '$directory/$ts.png';
      final picData = await painter.toImageData(2048, format: ui.ImageByteFormat.png);
      if (picData != null) {
        final pngBytes = picData.buffer.asUint8List();
  //      final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
          path
        );
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then((success) async {


          showDialog(
            context: contextx,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              insetPadding: const EdgeInsets.all(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  SizedBox(height: 15),
                  Text("QR CODE Successfully Saved")
                ],
              ),
              actions: [
                ElevatedButton(
                    child: Column(
                      children: const [
                        Icon(Icons.check),
                        SizedBox(height: 8),
                        Text("Okay"),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        contextx,
                        MaterialPageRoute(builder: (context) =>  MainScreen()),);

                    }

                ),

              ],
            ),
          );

        });

        print("image saved successfully22");
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Center(
              child: RepaintBoundary(
                key: qrKey,
                child: QrImage(
                  data: currentcow,
                  size: 250,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto,
                ),
              ),
            ),
            const SizedBox(height: 25),
            CupertinoButton(
              child: const Text("Save"),
              onPressed: () => takeScreenShot(context),
            ),
            const SizedBox(height: 25)
          ],
        ),
      ),
    );
  }
}
