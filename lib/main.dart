import 'package:flutter/material.dart';
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
    Future<LocationData> position = locationHelper.getLocation();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
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

                  LocationData loadedPosition = snapshot.data ?? LocationData;
                  if (loadedPosition != null) {
                    lat = loadedPosition.latitude;
                    long = loadedPosition.longitude;
                    return new Text('lat: ' +
                        lat.toString() +
                        '\n long: ' +
                        long.toString());
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
