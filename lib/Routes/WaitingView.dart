import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:flutter/material.dart';

class WaitingView extends StatefulWidget {
  WaitingView({Key key, @required this.myUser}) : super(key: key);
  final User myUser;
  final TcpHelper tcp = TcpHelper();

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  final TcpHelper tcp = TcpHelper();

  @override
  Widget build(BuildContext context) {
    Future<WaitingRoom> waitingRoom =
        this.widget.tcp.getWaitingRoom(this.widget.myUser);
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiting Room"),
      ),
      body: Center(
        child: FutureBuilder(
          future: waitingRoom,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else {
              WaitingRoom room = snapshot.data;
              return ListView.builder(
                  itemCount: room.waitingUsers.length,
                  itemBuilder: (context, index) {
                    User currentUser = room.waitingUsers[index];
                    return ListTile(
                      leading: Text(currentUser.userName),
                      trailing: RaisedButton(
                        onPressed: () {
                          //code to start a run  goes here
                          Pair pair = Pair(this.widget.myUser, currentUser);
                          Payload payload = new Payload(pair.toJson(), '"run"');
                          tcp.sendPayload(payload);
                        },
                        child: Text("Challenge"),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      drawer: SideDrawer(currentUser: this.widget.myUser),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        tooltip: "Refresh the waiting room",
        child: Icon(Icons.refresh),
      ),
    );
  }
}
