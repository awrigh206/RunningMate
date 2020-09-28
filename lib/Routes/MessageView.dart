import 'dart:convert';
import 'dart:developer';

import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/ChatRoom.dart';
import 'package:application/Models/Message.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  MessageView(
      {Key key, @required this.currentUser, @required this.userTalkingTo})
      : super(key: key);
  final User currentUser;
  final User userTalkingTo;

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  TcpHelper tcpHelper;
  Future<ChatRoom> chat;

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
    chat = getChatRoom();
  }

  Future<ChatRoom> getChatRoom() async {
    Pair pair = new Pair(widget.currentUser, widget.userTalkingTo);
    String text =
        await tcpHelper.sendPayload(new Payload(pair.toJson(), 'get_messages'));
    Map roomMap = await jsonDecode(text.substring(2));
    return ChatRoom.fromJson(roomMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userTalkingTo.userName),
      ),
      body: Center(
        child: SingleChildScrollView(
            primary: true,
            child: FutureBuilder(
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
                })),
      ),
      drawer: SideDrawer(currentUser: widget.currentUser),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            chat = getChatRoom();
          });
        },
        tooltip: "Refresh the waiting room",
        child: Icon(Icons.refresh),
      ),
    );
  }
}
