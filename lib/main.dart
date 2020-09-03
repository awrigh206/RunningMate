import 'dart:async';
import 'dart:developer';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:application/Routes/MapView.dart';
import 'package:application/Routes/WaitingView.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'Helpers/LocationHelper.dart';
import 'Models/User.dart';

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
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  Future<WaitingRoom> room;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Icon(Icons.error);
                  }

                  if (position == null) {
                    return new Text('Do not have location permission');
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
                    Future<LocationData> basicLocation =
                        locationHelper.getLocationBasic();
                    return FutureBuilder<LocationData>(
                        future: basicLocation,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
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
            Form(
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: false,
                    controller: userNameController,
                    decoration: const InputDecoration(
                      hintText: 'User Name',
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  TextFormField(
                    autocorrect: false,
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      tcp.sendToServer(
                          new User(userNameController.text,
                              passwordController.text, emailController.text),
                          "register",
                          true);
                    },
                    child: Text("Register"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      tcp.sendToServer(
                          new User(userNameController.text,
                              passwordController.text, emailController.text),
                          "login",
                          true);
                    },
                    child: Text("Login"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      // Future<WaitingRoom> waitingRoom = tcp.getWaitingRoom(
                      //     new User(userNameController.text,
                      //         passwordController.text, emailController.text));
                      // room = waitingRoom;

                      // setState(() {});

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WaitingView(
                                  myUser: new User(
                                      userNameController.text,
                                      passwordController.text,
                                      emailController.text),
                                )),
                      );
                    },
                    child: Text("Send Ready Message"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      tcp.sendToServer(
                          new User.nameOnly(userNameController.text),
                          "run",
                          true);
                    },
                    child: Text("Send run command"),
                  ),
                ],
              ),
            ),
            RaisedButton(
                child: Text("Send Message"),
                onPressed: () {
                  tcp.sendToServer(
                      new User(userNameController.text, passwordController.text,
                          emailController.text),
                      "login",
                      false);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapView(
                      location: loadedLocation,
                      coordinates: LatLng(loadedLocation.position.latitude,
                          loadedLocation.position.longitude),
                    )),
          );
        },
        tooltip: "Go to next page",
        child: Icon(Icons.map),
      ),
    );
  }
}
