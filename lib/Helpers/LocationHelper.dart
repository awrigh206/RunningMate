import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geo;

class LocationHelper {
  Location location = new Location();
  final geo.Geolocator geolocator = geo.Geolocator()
    ..forceAndroidLocationManager;
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
    geo.GeolocationStatus geolocationStatus =
        await geo.Geolocator().checkGeolocationPermissionStatus();

    if (geolocationStatus.value == 0) {
      return null;
    }

    Future<geo.Position> position;

    geolocator
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.best)
        .then((geo.Position position) {
      position = position;
    }).catchError((e) {
      print(e);
    });
    return position;
  }

  Future<geo.Placemark> getCurrentAddress() async {
    geo.Position position = await getPosition();
    try {
      List<geo.Placemark> p = await geolocator.placemarkFromCoordinates(
          position.latitude, position.longitude);
      geo.Placemark place = p[0];
      print("This is the country:" + place.country);
      return place;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
