import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/CustomWidgets/Slideable.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:application/Routes/SettingsView.dart';
import 'package:application/Routes/WaitingView.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  UserView({Key key, @required this.currentUser}) : super(key: key);
  final User currentUser;

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  TcpHelper tcpHelper;
  Future<WaitingRoom> challenger;

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
  }

  @override
  Widget build(BuildContext context) {
    challenger = tcpHelper.getWaitingRoom(this.widget.currentUser, 'check');
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
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
            FutureBuilder<dynamic>(
                future: challenger,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return new ListTile(
                      title: Text('Checking for challenges'),
                      trailing: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return new ListTile(
                      title: Text('There has been an error'),
                      subtitle: Text('Please try again later'),
                      trailing: Icon(Icons.error),
                    );
                  }
                  WaitingRoom challangers = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: challangers.waitingUsers.length,
                      primary: false,
                      itemBuilder: (context, index) {
                        User current = challangers.waitingUsers[index];
                        return new Slideable(
                            displayUser: current,
                            currentUser: this.widget.currentUser);
                      });
                }),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsView(
                            currentUser: this.widget.currentUser)));
              },
            )
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: "Refresh the page",
        child: Icon(Icons.refresh),
      ),
      drawer: SideDrawer(currentUser: this.widget.currentUser),
    );
  }
}
