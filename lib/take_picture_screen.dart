import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:test_1/picture_screen.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:test_1/provider.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, this.camera}) : super(key: key);
  final CameraDescription? camera;
  static const id = 'take';

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera!,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(children: <Widget>[
              CameraPreview(_controller),
              Positioned(
                  right: 10,
                  bottom: 20,
                  child: Consumer<LocationProvider>(
                    builder: (_, provider, __) => Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Sean Onuoha'),
                          Text(
                              'Phone: ${provider.mobileNumber != null ? provider.mobileNumber : 'Number'}'),
                          Text(
                              'Time: ${provider.currentTime != null ? provider.currentTime : 'Time'}'),
                          Text(
                            'Address: ${provider.address! != null ? provider.address : 'address'}',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          )
                        ],
                      ),
                    ),
                  ))
            ]);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            //final image = await _controller.takePicture();

            print('check: 0');
            XFile xfile = await _controller.takePicture();
            print('check: 1');
            final path = xfile.path;

            print('check: 2');
            //   final bytes = await File(path).readAsBytes();
            print('check: 3');
            //   final img.Image image = img.decodeImage(bytes)!;
            print('check: 4');
            //  img.Image yo = img.drawString(u, img.arial_14, 0, 0, 'Hello World');
            print('check: 5');
            //  var yog = yo.getBytes(format: img.Format.rgba);
            print('check: 6');
            //   File file = File.fromRawPath(yog);
            print('check: 7');
            // // var status = await Permission.storage.status;
            //  print('check: 8');
            //  if (status.isDenied) {
            //    print('check: denied');
            //    await Permission.storage.request();
            //    print('requesting');
            //    if (Permission.storage.status.isGranted == false) {
            //      print('check: bounced');
            //      return;
            //    }
            //  }
            print('check: 9');
            //     ImageGallerySaver.saveImage(yog, name: 'tested');
            print('check: 10');
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print('check: exception is $e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
