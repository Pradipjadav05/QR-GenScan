import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class GenerateQrCodePage extends StatefulWidget {
  const GenerateQrCodePage({super.key});

  @override
  State<GenerateQrCodePage> createState() => _GenerateQrCodePageState();
}

class _GenerateQrCodePageState extends State<GenerateQrCodePage> {
  final GlobalKey _globalKey = GlobalKey();

  String qrData = 'https://github.com/Pradipjadav05';
  TextEditingController qrText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate QR Code"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("Generated QR Code",
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10.0,
              ),
              // display QR Code Image
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 250,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: QrImageView(data: qrData),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(
                color: Colors.black,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                child: const Text(
                  "You can also generate your own QR Code by entering the text below",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextField(
                controller: qrText,
                decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Enter your Data",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    )),
              ),
              const SizedBox(
                height: 14.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  if (qrText.text.isEmpty) {
                    setState(() {
                      qrData = "https://github.com/Pradipjadav05";
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please enter some Data!",
                              style: TextStyle(fontSize: 17.0))));
                    });
                  } else {
                    setState(() {
                      qrData = qrText.text;
                    });
                  }
                },
                child: const Text(
                  "Generate QR Code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () async{
                  await saveQRCode();
                },
                child: const Text(
                  "Save your QR Code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // save QR into device
  saveQRCode() async{
    try{
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();


      Directory appFolder = Directory('/storage/emulated/0/Download/QR Generator');
      bool appFolderExists = await appFolder.exists();
      if (!appFolderExists) {
        final created = await appFolder.create(recursive: true);
        print(created.path);
      }

      final filepath = '${appFolder.path}/qr_code.png';
      await File(filepath).writeAsBytes(pngBytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('QR Code saved to $filepath')));

    }catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save QR Code')));
    }
  }
}
