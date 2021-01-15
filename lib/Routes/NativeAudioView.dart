import 'dart:developer';

import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeAudioView extends StatefulWidget {
  NativeAudioView({Key key}) : super(key: key);

  @override
  _NativeAudioViewState createState() => _NativeAudioViewState();
}

class _NativeAudioViewState extends State<NativeAudioView> {
  static const platform =
      const MethodChannel('application.flutter.dev/playSound');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Audio Test'),
        actions: [
          IconButton(
              icon: Icon(Icons.message),
              onPressed: () async {
                try {
                  await platform.invokeMethod(
                      'playAudio', {'fileName': 'totalitarian.ogg'});
                } on PlatformException catch (e) {
                  log(e.message);
                }
                setState(() {});
              }),
        ],
      ),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
