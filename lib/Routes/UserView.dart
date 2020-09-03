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
        title: Text("Home"),
      ),
      body: Container(
          child: Card(
        child: Column(
          children: [
            ListTile(
                title: Text(this.widget.currentUser.userName),
                subtitle: Text(this.widget.currentUser.email),
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.blue[500],
                )),
          ],
        ),
      )),
    );
  }
}
