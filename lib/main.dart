import 'dart:io';
import 'package:application/HttpSetting.dart';
import 'package:application/Routes/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> setup() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("server", "https://192.168.0.45:9090");
  }
}
