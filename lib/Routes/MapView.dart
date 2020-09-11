import 'package:application/Helpers/LocationHelper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  MapView({Key key}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
  final locationHelper = LocationHelper();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  Set<Marker> markers = {};
  Placemark loadedLocation;

  @override
  Widget build(BuildContext context) {
    final Future<Placemark> position =
        this.widget.locationHelper.getCurrentAddress();
    return Scaffold(
        appBar: AppBar(
          title: Text('Current Location'),
        ),
        body: Center(
          child: FutureBuilder<Placemark>(
              future: position,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Icon(Icons.error);
                }

                if (position == null) {
                  return new Text(
                      'You have not eabled lcoation services for this app');
                }
                Placemark loadedPlace = snapshot.data ?? Placemark;
                if (position != null) {
                  loadedLocation = loadedPlace;
                  LatLng coords = new LatLng(loadedPlace.position.latitude,
                      loadedPlace.position.longitude);
                  markers.add(Marker(
                      markerId: MarkerId('<USER_LOCATION>'), position: coords));
                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: coords,
                      zoom: 15.0,
                    ),
                    mapType: MapType.normal,
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {},
                  );
                } else {
                  Future<LocationData> basicLocation =
                      this.widget.locationHelper.getLocationBasic();
                  return FutureBuilder<LocationData>(
                      future: basicLocation,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Icon(Icons.gps_not_fixed);
                        }

                        if (basicLocation == null) {
                          return new Text('Do not have location permission');
                        }
                        LocationData loadedBasic =
                            snapshot.data ?? LocationData;
                        return new Text("Lat: " +
                            loadedBasic.latitude.toString() +
                            " Lng: " +
                            loadedBasic.longitude.toString());
                      });
                }
              }),
        ));
  }
}
