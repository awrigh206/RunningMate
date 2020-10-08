import 'package:application/CustomWidgets/MessageTile.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/ChatRoom.dart';
import 'package:application/Models/Message.dart';
import 'package:application/Models/Pair.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget {
  MessageList({Key key, @required this.pair, @required this.chat})
      : super(key: key);
  final Pair pair;
  final ChatRoom chat;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TcpHelper tcpHelper;
  Message lastMessage;
  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
    lastMessage = new Message.empty();
  }

  @override
  Widget build(BuildContext context) {
    ChatRoom chatRoom = widget.chat;
    return Builder(builder: (context) {
      if (chatRoom.messages.isEmpty) {
        return ListTile(
          title: Text('No messages'),
          trailing: Icon(Icons.message_rounded),
        );
      }
      if (chatRoom.messages.length > 1) {
        lastMessage = chatRoom.messages[chatRoom.messages.length - 1];
      }

      return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: chatRoom.messages.length,
          itemBuilder: (context, index) {
            Message message = chatRoom.messages[index];
            return MessageTile(
                message: message,
                fromOtherUser:
                    message.sender != widget.pair.playerOne.userName);
          });
    });
  }
}
