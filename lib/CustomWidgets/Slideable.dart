import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:application/Routes/ActiveView.dart';
import 'package:application/Routes/MessageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Slideable extends StatelessWidget {
  Slideable({Key key, @required this.displayUser, @required this.currentUser})
      : super(key: key);
  final User displayUser;
  final User currentUser;
  final TcpHelper tcpHelper = TcpHelper();
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text("Challenged by: " + displayUser.userName),
          leading: CircleAvatar(
            backgroundColor: Colors.purpleAccent,
          ),
        ),
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Accept',
          color: Colors.greenAccent,
          icon: Icons.check,
          onTap: () {
            Pair pair = new Pair(currentUser, displayUser);
            tcpHelper.sendPayload(new Payload(pair.toJson(), "run"));
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ActiveView(currentPair: pair)),
            );
          },
        ),
        IconSlideAction(
          caption: 'Decline',
          color: Colors.redAccent,
          icon: Icons.remove_circle,
          onTap: () {
            Pair pair = new Pair(currentUser, displayUser);
            tcpHelper.sendPayload(new Payload(pair.toJson(), "deny"));
          },
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Message',
          icon: Icons.message,
          color: Colors.blueAccent,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageView(
                      currentUser: currentUser, userTalkingTo: displayUser),
                ));
          },
        )
      ],
    );
  }
}
