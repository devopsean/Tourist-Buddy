import 'dart:io' as io;
import 'package:geocoding/geocoding.dart' as geo;
import 'dart:core';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:provider/provider.dart';

class LocationProvider extends ChangeNotifier {


  bool visible = true;
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  Location location = Location();
  String cordinates = 'Coordinates';
  String mobileNumber ='Mobile';
  Image image = Image.asset('assets/image.jpeg');
  String currentTime = 'time';
  String address ='Address';



  void getLocation() async {


    print('check: getting location');
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      print('check: service not enabled, requesting...');
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }
    print('check: service enabled');
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {

        return;
      }
    }
print('check: permission cleared, attempting location');
    locationData = await location.getLocation();
    print('check: get lcoation clear: $location');
    cordinates =
        'Coordinates: ${locationData!.longitude!.toString()}, ${locationData!.latitude!.toString()} ';

    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData!.latitude!, locationData!.longitude!);
    print('checK: place0');
    print(placemarks);
    print('checK: place1');
    geo.Placemark kpa = placemarks[0];
 //   address = '${kpa.subLocality}, ${kpa.country}';
address =' ${kpa.name!}, ${kpa.street}, ${kpa.locality}, ${kpa.subLocality}, ${kpa.country}';
    try {
      bool isPermissionGranted = await MobileNumber.hasPhonePermission;
      if (isPermissionGranted) {
        print('check: mobile is ${MobileNumber.mobileNumber}');
        mobileNumber = await MobileNumber.mobileNumber!;
      } else {
        await MobileNumber.requestPhonePermission;
        if (await MobileNumber.hasPhonePermission) {
          mobileNumber = await MobileNumber.mobileNumber!;
        }
      }
    } catch (e) {
      print('check: problem is $e');
    }
    final yosko = DateTime.now();

    currentTime =
        '${yosko.hour.toString()}:${yosko.minute.toString()} ${yosko.day.toString()}, ${yosko.month.toString()} ${yosko.year.toString()}';
    notifyListeners();
  }

  void makeInvisible() {
    visible = false;
    notifyListeners();
  }
}
