import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key key}) : super(key: key);

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            ListTile(
              title: Text('Change User Name'),
              onTap: () {
                //change the user  name of the current user
              },
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                //change password of current user
              },
            ),
            ListTile(
              title: Text('Delete Account'),
              onTap: () {
                //delete the current user from the system
              },
            )
          ],
        ),
      ),
      drawer: SideDrawer(),
    );
  }
}
