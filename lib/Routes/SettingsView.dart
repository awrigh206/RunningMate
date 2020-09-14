import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key key, @required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  final TcpHelper tcpHelper = TcpHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              ListTile(
                title: Text(
                    'Current User Name: ' + this.widget.currentUser.userName),
                subtitle:
                    Text('Current email: ' + this.widget.currentUser.email),
              ),
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
                  tcpHelper.sendToServer(
                      this.widget.currentUser, "remove", true);

                  Navigator.popUntil(
                      context, ModalRoute.withName('/LoginView'));
                },
                color: Colors.red[100],
              ),
            ],
          ),
        ),
      ),
      drawer: SideDrawer(
        currentUser: this.widget.currentUser,
      ),
    );
  }
}
