import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:flutter/material.dart';

class WaitingView extends StatefulWidget {
  WaitingView({Key key, @required this.myUser}) : super(key: key);
  final User myUser;

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  final TcpHelper tcp = TcpHelper();

  @override
  Widget build(BuildContext context) {
    Future<WaitingRoom> waitingRoom = tcp.getWaitingRoom(this.widget.myUser);
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiting Room"),
      ),
      body: Container(
        child: FutureBuilder(
          future: waitingRoom,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Something went wrong, check the log file");
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            } else {
              WaitingRoom room = snapshot.data;
              //return Text(room.toJson().toString());
              return ListView.builder(
                  itemCount: room.waitingUsers.length,
                  itemBuilder: (context, index) {
                    User currentUser = room.waitingUsers[index];
                    return ListTile(
                      leading: Text(currentUser.userName),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
