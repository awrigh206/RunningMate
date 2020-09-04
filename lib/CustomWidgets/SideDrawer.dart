import 'package:flutter/material.dart';

import '../main.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Header')),
          ListTile(
            title: Text('Run'),
            onTap: () {
              Navigator.pop(context);
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
              Navigator.pop(context);
            },
            leading: Icon(Icons.settings),
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
              Navigator.pop(context);
            },
            leading: Icon(Icons.account_box),
          ),
        ],
      ),
    );
  }
}
