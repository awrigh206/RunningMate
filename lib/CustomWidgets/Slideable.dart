import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/StringPair.dart';
import 'package:application/Routes/ActiveView.dart';
import 'package:application/Routes/MessageView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Slideable extends StatelessWidget {
  Slideable({Key key, @required this.pair, @required this.updatePage})
      : super(key: key);
  final StringPair pair;
  final TcpHelper tcpHelper = TcpHelper();
  final Function updatePage;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text("Challenged by: " + pair.userTwo),
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
            tcpHelper.sendPayload(new Payload(pair.toJson(), "deny"));
            updatePage();
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
                          pair: pair,
                        )));
          },
        )
      ],
    );
  }
}
