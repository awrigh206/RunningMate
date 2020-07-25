import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  MapView({Key key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  final LatLng centre = const LatLng(45.521563, -122.677433);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Running Mate'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: centre,
            zoom: 12.0,
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
        ));
  }
}
