import 'dart:io';

import 'package:application/HttpSetting.dart';
import 'package:application/Routes/LoginView.dart';
import 'package:flutter/material.dart';

void main() {
  HttpOverrides.global = new HttpSetting();
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
      home: LoginView(title: 'Runnng Mate'),
    );
  }
}
