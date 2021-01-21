import 'package:application/CustomWidgets/MessageTile.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Message.dart';
import 'package:application/Models/Pair.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget {
  MessageList({Key key, @required this.pair, @required this.messages})
      : super(key: key);
  final Pair pair;
  final List<Message> messages;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TcpHelper tcpHelper;
  Message lastMessage;
  @override
  void initState() {
    super.initState();
    lastMessage = new Message.empty();
  }

  @override
  Widget build(BuildContext context) {
    List<Message> messages = widget.messages;
    return Builder(builder: (context) {
      if (messages.isEmpty) {
        return ListTile(
          title: Text('No messages'),
          trailing: Icon(Icons.message_rounded),
        );
      }
      if (messages.length > 1) {
        lastMessage = messages[messages.length - 1];
      }

      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Message message = messages[index];
            return MessageTile(
                message: message,
                fromOtherUser: message.sender != widget.pair.issuingUser);
          });
    });
  }
}
