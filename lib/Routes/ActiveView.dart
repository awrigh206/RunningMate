import 'dart:async';

import 'package:application/Helpers/LocationHelper.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Distance.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/Position.dart';
import 'package:application/Models/StringPair.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class ActiveView extends StatefulWidget {
  ActiveView({Key key, @required this.currentPair}) : super(key: key);
  final Pair currentPair;
  @override
  _ActiveViewState createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {
  Timer timer;
  TcpHelper tcpHelper;
  Distance distanceTravelled;
  LocationHelper locationHelper = new LocationHelper();
  Position currentPosition;

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
    const duration = const Duration(seconds: 2);
    timer = Timer.periodic(duration, (timer) async {
      await sendData();
    });
  }

  Future<void> sendData() async {
    String id = this.widget.currentPair.issuingUser +
        this.widget.currentPair.challengedUser;
    //Code in this function body is run every two seconds
    LocationData locationData = await locationHelper.getLocationBasic();
    Position currentPosition = new Position(
        id,
        this.widget.currentPair.issuingUser,
        locationData.latitude,
        locationData.longitude,
        locationData.altitude);
    tcpHelper.sendPayload(new Payload(currentPosition.toJson(), 'update'));
  }

  @override
  void dispose() {
    //Stop/ get  rid of timer when view  is popped
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Go!"),
      ),
      body: Center(
          child: ListView(
        children: [
          ListTile(
            title: Text('Player One: '),
            trailing: Text(this.widget.currentPair.issuingUser),
          ),
          ListTile(
            title: Text('Player Two: '),
            trailing: Text(this.widget.currentPair.challengedUser),
          )
        ],
      )),
    );
  }
}
