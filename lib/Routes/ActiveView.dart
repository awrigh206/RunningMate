import 'dart:async';
import 'package:application/DTO/UpdateDto.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Helpers/LocationHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'dart:math';

class ActiveView extends StatefulWidget {
  ActiveView({Key key, @required this.currentPair}) : super(key: key);
  final Pair currentPair;
  @override
  _ActiveViewState createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {
  Timer timer;
  LocationHelper locationHelper = new LocationHelper();
  Future<LocationData> currentPosition;
  Future<LocationData> lastPosition;
  GetIt getIt = GetIt.instance;
  Future<bool> otherUserReady;

  @override
  void initState() {
    start();
    super.initState();
  }

  Future<void> start() async {
    await beginRun();
    otherUserReady = isOpponentReady();
    currentPosition = locationHelper.getLocationBasic();
    const duration = const Duration(seconds: 2);
    timer = Timer.periodic(duration, (timer) async {
      bool ready = await otherUserReady;
      if (ready) {
        await sendData();
      }
    });
  }

  Future<void> beginRun() async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res = await httpHelper.postRequest(
        getIt<String>() + 'run', this.widget.currentPair.toJson());
  }

  Future<void> sendData() async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    String id = this.widget.currentPair.issuingUser +
        this.widget.currentPair.challengedUser;
    //Code in this function body is run every two seconds
    lastPosition = currentPosition;
    currentPosition = locationHelper.getLocationBasic();
    Pair pair = this.widget.currentPair;
    UpdateDto updateDto = UpdateDto(pair,
        calculateDistance(await lastPosition, await currentPosition), 0.0, 2.0);
    httpHelper.putRequest(getIt<String>() + 'run/update', updateDto.toJson());
  }

  //calculate difference between two points using the haversine formula
  double calculateDistance(LocationData previous, LocationData current) {
    int radius = 6371; //radius of the earth in km
    var dlat = convertToRadian(current.latitude - previous.latitude);
    var dlon = convertToRadian(current.longitude - previous.longitude);

    var a = sin(dlat / 2) * sin(dlat / 2) +
        cos(convertToRadian(previous.latitude)) *
            cos(convertToRadian(current.latitude)) *
            sin(dlon / 2) *
            sin(dlon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var distance = radius * c;
    return distance;
  }

  double convertToRadian(double deg) {
    return deg * (pi / 180);
  }

  Future<bool> isOpponentReady() async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res = await httpHelper.getRequest(
        getIt<String>() +
            'run/challenger?name=' +
            this.widget.currentPair.challengedUser,
        true);
    return res.data;
  }

  Future<void> setWaiting(String name) async {
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res =
        await httpHelper.getRequest(getIt<String>() + 'run?name=' + name, true);
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
      body: FutureBuilder(
        future: otherUserReady,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('There has been an error');
          }
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Center(
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
              ));
            } else {
              return new Text('Waiting for your opponent');
            }
          } else {
            return new CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
