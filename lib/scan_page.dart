import 'package:flutter/material.dart';

import 'qr_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(5.0),
            child: const Text(
              "Scan QR Code",
              style: TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(bottom: 30.0, left: 70.0, right: 70.0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueGrey, width: 5),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Image.asset("assets/images/qr-code.png"),
          ),
          const Text(
            textAlign: TextAlign.center,
            "QR Code Result",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onLongPress: () {},
            child: SelectableText(
              qrCodeResult,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: Colors.red,
              showCursor: true,
            ),
          ),
          const SizedBox(
            height: 10.0,
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
                borderRadius: BorderRadius.circular(
                  32.0,
                ),
              ),
            ),
            onPressed: () async{
              // open scanner view
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRScanner()),
              );
              setState(() {
                qrCodeResult = result;
              });
            },
            child: const Text(
              "Scan your QR Code",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
