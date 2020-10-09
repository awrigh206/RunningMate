import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';

class NativeAudioView extends StatefulWidget {
  NativeAudioView({Key key, @required this.currentUser}) : super(key: key);

  final User currentUser;
  @override
  _NativeAudioViewState createState() => _NativeAudioViewState();
}

class _NativeAudioViewState extends State<NativeAudioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(currentUser: widget.currentUser),
      appBar: AppBar(
        title: Text('Audio Test'),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
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
