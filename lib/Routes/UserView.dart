import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Models/User.dart';
import 'package:application/Routes/SettingsView.dart';
import 'package:flutter/material.dart';

import 'WaitingView.dart';

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
          child: Center(
        child: Column(
          children: [
            ListTile(
                title: Text(this.widget.currentUser.userName),
                subtitle: Text(this.widget.currentUser.email),
                leading: Icon(
                  Icons.verified_user,
                  color: Colors.blue[500],
                )),
            ListTile(
              title: Text('Run against another user'),
              subtitle: Text("Go for a run it's lots of fun"),
              leading: Icon(Icons.directions_run),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          WaitingView(myUser: this.widget.currentUser)),
                );
              },
              onLongPress: () {},
            ),
            ListTile(
              title: Text('Cycle against another user'),
              subtitle: Text('Good luck!'),
              leading: Icon(Icons.directions_bike),
            ),
            ListTile(
              title: Text('Change account details'),
              subtitle: Text('Quick and painless'),
              leading: Icon(Icons.account_box),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsView()));
              },
            )
          ],
        ),
      )),
      drawer: SideDrawer(),
    );
  }
}
