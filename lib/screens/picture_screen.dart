import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:test_1/providers/provider.dart';

class DisplayPictureScreen extends StatefulWidget {
   String? imagePath;
  static const id = 'yo';
  DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  // ScreenshotController screenshotController = ScreenshotController();

//   void takeScreenshot() async {
//     final directory = (await getApplicationDocumentsDirectory())
//         .path; //from path_provide package
//     String fileName = DateTime.now().microsecondsSinceEpoch.toString();
//     String path = '$directory';
// print('check: path is $path');
//   //   screenshotController.captureAndSave(
//   //       path, //set path where screenshot will be saved
//   //       fileName: fileName);
//    }
  GlobalKey _globalKey = new GlobalKey();
  Uint8List? imageInMemory;
  String? imagePath;
  File? capturedFile;

  Future<Uint8List> _capturePng(GlobalKey globalKeys) async {
    try {      var status = await Permission.storage.status;
    print('check: 8');
    if (status.isDenied) {
      print('check: denied');
      await Permission.storage.request();
      print('requesting');
      if (Permission.storage.status.isGranted == false) {
        print('check: bounced');
        SnackBar(
          content: Text('Allow storage'),
        );
      }
    }
      print('check: inside');
      // inside = true;
      RenderRepaintBoundary boundary = globalKeys.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData;
      byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
//create file
//       final String dir = (await getApplicationDocumentsDirectory()).path;
//       imagePath = '$dir/file_name${DateTime.now()}.png';
//       capturedFile = File(imagePath!);
//       await capturedFile!.writeAsBytes(pngBytes);
//       print('check: path is: ${capturedFile!.path}');

      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 60, name: "file_name${DateTime.now()}");
    Fluttertoast.showToast(
        msg: "SAVED!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0
    );
      print('check: result is $result');
      print('check: png done');
      return pngBytes;
    } catch (e) {
      print('check: try no catch: ${e.toString()}');
      print('check: try no catch: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
bool visibi = true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocationProvider>(context, listen: false);

    return ChangeNotifierProvider(create: (_) => LocationProvider(),
      child: RepaintBoundary(key: _globalKey,
        child: Scaffold(

          // appBar: AppBar(title: const Text('Display the Picture with coordinates')),
          // The image is stored as a file on the device. Use the `Image.file`
          // constructor with the given path to display the image.
          body: SafeArea(
            //  child: RepaintBoundary(
            //  key: _globalKey!,
            child: Stack(
              children: <Widget>[
                Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Image.file(File(widget.imagePath!))),
                Positioned(
                  right: 10,
                  bottom: 50,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text('Userfirst LastName'),

                        Text('Phone: ${provider.mobileNumber != null ? provider.mobileNumber : 'phone'}'),
                        Text(
                            'Time: ${provider.currentTime != null ? provider.currentTime : 'Time'}'),
                        Text(
                          'Address: ${provider.address != null ? provider.address : 'address'}',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        )
                      ],
                    ),
                  )
                ),
              ],
            ),
            //),
          ),
          floatingActionButton: Consumer<LocationProvider>(builder: (_,provider, __) => Visibility(
            visible: provider.visible,
            child: FloatingActionButton(
              onPressed: () async {

                print('check: about to save');         provider.makeInvisible();
                Future.delayed(Duration(seconds: 3));
                await _capturePng(_globalKey);


//takeScreenshot();
              },child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[Icon(Icons.save_alt_outlined),
              Text('SAVE'),
            ],),
            ),
          ),),
        ),
      ),
    );
  }
}


