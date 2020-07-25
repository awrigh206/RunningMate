import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

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
  double lat;
  double long;

  @override
  Widget build(BuildContext context) {
    //Future<LocationData> position = locationHelper.getLocationBasic();
    //Future<Position> position = locationHelper.getPosition();
    Future<Placemark> position = locationHelper.getCurrentAddress();
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
                    //lat = loadedPosition.latitude;
                    //long = loadedPosition.longitude;
                    return new Text(loadedPlace.toString());
                  } else {
                    return new Text('Unable to find your location currently');
                  }
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: "Go to next page",
        child: Icon(Icons.add),
      ),
    );
  }
}
