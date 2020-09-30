import 'dart:convert';

import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/ChatRoom.dart';
import 'package:application/Models/Message.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/Payload.dart';
import 'package:flutter/material.dart';

class MessageList extends StatefulWidget {
  MessageList({Key key, @required this.pair}) : super(key: key);
  final Pair pair;

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  Future<ChatRoom> chat;
  TcpHelper tcpHelper;

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
    chat = getChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    chat = getChatRoom();
    return FutureBuilder(
        future: chat,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ChatRoom chatRoom = snapshot.data;
            if (chatRoom.messages.isEmpty) {
              return ListTile(
                title: Text('No messages'),
                trailing: Icon(Icons.message_rounded),
              );
            }
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: chatRoom.messages.length,
                itemBuilder: (context, index) {
                  Message message = chatRoom.messages[index];
                  return ListTile(
                    title: Text(message.messageBody),
                    subtitle: Text(message.timeStamp),
                  );
                });
          } else if (snapshot.hasError) {
            return new ListTile(
              title: Text('There has been an error, please try again'),
              trailing: Icon(Icons.error),
            );
          } else
            return CircularProgressIndicator();
        });
  }

  Future<ChatRoom> getChatRoom() async {
    String text = await tcpHelper
        .sendPayload(new Payload(widget.pair.toJson(), 'get_messages'));
    Map roomMap = await jsonDecode(text.substring(2));
    return ChatRoom.fromJson(roomMap);
  }
}
