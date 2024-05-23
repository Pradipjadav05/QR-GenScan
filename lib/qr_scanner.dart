import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan/scan.dart';


class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _ScannerState();
}

class _ScannerState extends State<QRScanner> {

  final picker = ImagePicker();
  ScanController scanController = ScanController();

  @override
  void dispose() {
    scanController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          /*
          * Open scanner
          * */
          ScanView(
            controller: scanController,
            scanAreaScale: 0.7,
            scanLineColor: Colors.blueGrey,
            onCapture: (data) {
              String? str = data;
              if(str.isNotEmpty) {
                String str2 = str;
                Navigator.pop(context,str2);
              }
              scanController.resume();
            },
          ),

          Center(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*
              * Select QR code from gallery and read.
              * */
                InkWell(
                  onTap: _scanFromGallery,
                  child: Container(
                      margin: const EdgeInsets.only(right:10),
                      padding:const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blueGrey
                        ),
                        color: Colors.white,
                      ),
                      child:const Icon(Icons.image, color: Colors.black,size: 28,)
                  ),
                )
              ],
            ),
          )
        ],
      ),

    );
  }

  //Pick image from gallery and read.
  Future<void> _scanFromGallery() async{

    await Permission.storage.status.isDenied.then((value) {
      if(value){
        Permission.storage.request();
      }
    });

    await Permission.manageExternalStorage.status.isDenied.then((value) {
      if(value){
        Permission.manageExternalStorage.request();
      }
    });

    final res = await picker.pickImage(source: ImageSource.gallery);
    if (res != null) {
      String? str = await Scan.parse(res.path);
      if (str != null) {
        // print("data: $str");
        Navigator.pop(context,str);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nothing Found")));
      }
    }
  }
}