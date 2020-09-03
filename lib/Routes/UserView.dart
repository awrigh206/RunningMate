import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  UserView({Key key, @required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiting Room"),
      ),
      body: Container(
        child: Text("Hello"),
      ),
    );
  }
}
