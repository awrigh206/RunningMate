import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final Placemark location;
  final LatLng coordinates;
  MapView({Key key, @required this.location, @required this.coordinates})
      : super(key: key);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController mapController;
  Set<Marker> _markers = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Running Mate'),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: this.widget.coordinates,
            zoom: 15.0,
          ),
          mapType: MapType.normal,
          markers: _markers,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              _markers.add(Marker(
                markerId: MarkerId('<USER_LOCATION>'),
                position: LatLng(this.widget.location.position.latitude,
                    this.widget.location.position.longitude),
              ));
            });
          },
        ));
  }
}
