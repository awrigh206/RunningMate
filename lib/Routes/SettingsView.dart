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
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              RaisedButton(
                child: Text('Change User Name'),
                onPressed: () {
                  //change the user name of the current user
                },
              ),
              RaisedButton(
                child: Text('Change Password'),
                onPressed: () {
                  //change the password of the current user
                },
              ),
              RaisedButton(
                child: Text('Delete Account'),
                onPressed: () {
                  //Delete account of current user
                },
                color: Colors.red[100],
              ),
            ],
          ),
        ),
      ),
      drawer: SideDrawer(),
    );
  }
}
