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
import 'package:test_1/screens/picture_screen.dart';
// import 'package:screenshot/screenshot.dart';
import 'package:test_1/providers/provider.dart';
import 'package:test_1/screens/take_picture_screen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: FirstScreen(
          // Pass the appropriate camera to the TakePictureScrfeen widget.
          camera: firstCamera,
        ),
      ),
    ),
  );
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key, this.camera}) : super(key: key);
  final CameraDescription? camera;
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}


class _FirstScreenState extends State<FirstScreen> {

  @override
  void initState() {


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<LocationProvider>(context, listen: false);
    provider.getLocation();
    return Scaffold(body: SafeArea(child: Center(child: TextButton(onPressed:   (){
      print('check: pressed');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  TakePictureScreen(camera: widget.camera!,)),
      );

    },child: Text('Open Camera'),),),));
  }
}

// A


