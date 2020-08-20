import 'package:flutter/material.dart';

class WaitingView extends StatefulWidget {
  WaitingView({Key key}) : super(key: key);

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Waiting page"),
    );
  }
}
