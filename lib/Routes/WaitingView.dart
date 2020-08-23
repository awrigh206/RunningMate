import 'package:application/Models/User.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:flutter/material.dart';

class WaitingView extends StatefulWidget {
  WaitingView({Key key, @required this.waitingRoom}) : super(key: key);
  final Future<WaitingRoom> waitingRoom;

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: this.widget.waitingRoom,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == null) {
            print("data is: " + snapshot.data);
            return Text("Something went wrong, check the log file");
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return Text("Working on the request");
          }
          if (snapshot.data == null) {
            return Text("The response was null");
          } else {
            WaitingRoom room = snapshot.data;
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
    );
  }
}
