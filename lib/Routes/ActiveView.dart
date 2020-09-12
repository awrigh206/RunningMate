import 'dart:async';

import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Distance.dart';
import 'package:application/Models/Payload.dart';
import 'package:flutter/material.dart';

class ActiveView extends StatefulWidget {
  ActiveView({Key key}) : super(key: key);

  @override
  _ActiveViewState createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {
  Timer timer;
  TcpHelper tcpHelper;
  Distance distanceTravelled;

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
    timer = Timer(Duration(seconds: 2), () {
      //Code in this function body is run every two seconds
      tcpHelper.sendPayload(new Payload(distanceTravelled.toJson(), "update"));
    });
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
        child: Text("placeholder"),
      ),
    );
  }
}
