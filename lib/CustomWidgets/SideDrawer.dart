import 'package:application/Models/User.dart';
import 'package:application/Routes/LoginView.dart';
import 'package:application/Routes/SettingsView.dart';
import 'package:application/Routes/WaitingView.dart';
import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key key, @required this.currentUser}) : super(key: key);

  final User currentUser;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Header')),
          ListTile(
            title: Text('Run'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WaitingView(
                            myUser: currentUser,
                          )));
            },
            leading: Icon(Icons.directions_run),
          ),
          Divider(),
          ListTile(
            title: Text('Cycle'),
            onTap: () {
              Navigator.pop(context);
            },
            leading: Icon(Icons.directions_bike),
          ),
          Divider(),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsView(currentUser: currentUser)));
            },
            leading: Icon(Icons.settings),
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginView()));
            },
            leading: Icon(Icons.account_box),
          ),
        ],
      ),
    );
  }
}
