import 'dart:async';

import 'package:flutter/material.dart';

class ActiveView extends StatefulWidget {
  ActiveView({Key key}) : super(key: key);

  @override
  _ActiveViewState createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 2), () {
      //Code in this function body is run every two seconds
    });
  }

  @override
  void dispose() {
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
