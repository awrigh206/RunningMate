import 'dart:developer';

import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

class LocationHelper {
  Location location = new Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  //Use the location plugin to find the current  location of the device
  Future<LocationData> getLocationBasic() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        //The gps service is not enabled
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        //Permission to access location has not been granted
        return null;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  //Use the geolocator plugin to find the location of the device
  Future<geo.Position> getPosition() async {
    final geo.Geolocator geolocator = geo.Geolocator()
      ..forceAndroidLocationManager;
    geo.Position futurePosition;

    await geolocator
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.best)
        .then((geo.Position position) {
      futurePosition = position;
    }).catchError((e) {
      print(e);
      return futurePosition;
    });
    return futurePosition;
  }

  Future<geo.Placemark> getCurrentAddress() async {
    final geo.Geolocator geolocator = geo.Geolocator()
      ..forceAndroidLocationManager;
    geo.Position position = await getPosition();
    try {
      List<geo.Placemark> p = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);
      geo.Placemark place = p[0];
      log("This is the country:" + place.country);
      return place;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
