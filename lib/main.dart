import 'dart:async';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Routes/MapView.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'Helpers/LocationHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Running Mate',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Runnng Mate'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final locationHelper = LocationHelper();
  final TcpHelper tcp = TcpHelper();

  @override
  Widget build(BuildContext context) {
    //Future<LocationData> position = locationHelper.getLocationBasic();
    //Future<Position> position = locationHelper.getPosition();
    Future<Placemark> position = locationHelper.getCurrentAddress();
    Placemark loadedLocation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Placemark>(
                future: position,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Icon(Icons.gps_not_fixed);
                  }
                  if (snapshot.hasError) {
                    return Icon(Icons.error);
                  }

                  if (position == null) {
                    return new Text('Do not have location permission');
                  }

                  if (snapshot.data == null) {
                    return new Text("The location data is null I'm afraid");
                  }

                  Placemark loadedPlace = snapshot.data ?? Placemark;
                  //LocationData loadedPosition = snapshot.data ?? LocationData;
                  if (position != null) {
                    loadedLocation = loadedPlace;
                    //lat = loadedPosition.latitude;
                    //long = loadedPosition.longitude;
                    return new Text('You are in the: ' +
                        loadedPlace.country +
                        '\n more precisely: ' +
                        loadedPlace.administrativeArea +
                        '\n even more precisely: ' +
                        loadedPlace.subAdministrativeArea +
                        '\n with the postcode: ' +
                        loadedPlace.postalCode +
                        '\n with the streetname: ' +
                        loadedPlace.thoroughfare);
                  } else {
                    return new Text('Unable to find your location currently');
                  }
                }),
            RaisedButton(
                child: Text("Send Message"),
                onPressed: () {
                  tcp.sendToServer("hi");
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapView(location: loadedLocation)),
          );
        },
        tooltip: "Go to next page",
        child: Icon(Icons.map),
      ),
    );
  }
}
