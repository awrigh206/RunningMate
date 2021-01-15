import 'package:application/Models/User.dart';
import 'package:application/Routes/NativeAudioView.dart';
import 'package:application/Routes/SettingsView.dart';
import 'package:application/Routes/WaitingView.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = GetIt.I<User>();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            children: [
              Text('User: ' + user.userName),
              Text('Email: ' + user.email)
            ],
          )),
          ListTile(
            title: Text('Run'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WaitingView(
                            myUser: user,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsView()));
            },
            leading: Icon(Icons.settings),
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("/LoginView"));
            },
            leading: Icon(Icons.account_box),
          ),
          Divider(),
          ListTile(
            title: Text('Native Audio Testing'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NativeAudioView()));
            },
          )
        ],
      ),
    );
  }
}
