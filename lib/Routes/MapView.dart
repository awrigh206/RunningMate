import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final Placemark location;
  MapView({Key key, @required this.location}) : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
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
            target: LatLng(this.widget.location.position.latitude,
                this.widget.location.position.longitude),
            zoom: 12.0,
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
        ));
  }
}
