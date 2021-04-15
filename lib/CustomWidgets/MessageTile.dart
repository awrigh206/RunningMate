import 'package:application/Models/Message.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  const MessageTile(
      {Key key, @required this.message, @required this.fromOtherUser})
      : super(key: key);

  final Message message;
  final bool fromOtherUser;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      //Build the widget which will display a chat message
      if (fromOtherUser) {
        return ListTile(
          title: Text(
            message.messageBody,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Sent: " + message.timeStamp,
            style: TextStyle(color: Colors.white),
          ),
          tileColor: Colors.blue[600],
        );
      } else {
        return ListTile(
          title: Text(
            message.messageBody,
            style: TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            'Sent:' + message.timeStamp,
            style: TextStyle(color: Colors.black),
          ),
          tileColor: Colors.white,
        );
      }
    });
  }
}
