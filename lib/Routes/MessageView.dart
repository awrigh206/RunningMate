import 'dart:convert';
import 'dart:developer';

import 'package:application/CustomWidgets/MessageList.dart';
import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/ChatRoom.dart';
import 'package:application/Models/Message.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';

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
  final messageController = TextEditingController();
  List<Message> newMessages = List();
  MessageList messageList;
  Future<ChatRoom> chat;
  ChatRoom chatRoom;
  Pair pair;
  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
    pair = new Pair(widget.currentUser, widget.userTalkingTo);
    chat = getChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userTalkingTo.userName),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              }),
        ],
      ),
      body: FooterView(
        children: [
          Padding(
              padding: new EdgeInsets.all(0.0),
              child: Center(
                child: SingleChildScrollView(
                    primary: true,
                    child: FutureBuilder(
                      future: chat,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          chatRoom = snapshot.data;
                          if (newMessages != null) {
                            chatRoom.messages.addAll(newMessages);
                          }
                          return MessageList(
                            pair: new Pair(
                              widget.currentUser,
                              widget.userTalkingTo,
                            ),
                            chat: chatRoom,
                          );
                        } else if (snapshot.hasError) {
                          return new ListTile(
                            title: Text('There has been an error'),
                            trailing: Icon(Icons.error),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )),
              )),
        ],
        footer: new Footer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                    ),
                  ),
                ),
                IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      sendMessage(chatRoom);
                    }),
              ],
            ),
          ),
        ),
      ),
      drawer: SideDrawer(currentUser: widget.currentUser),
    );
  }

  Future<void> sendMessage(ChatRoom chatRoom) async {
    Pair pair = Pair(widget.currentUser, widget.userTalkingTo);
    Message msg = Message(pair, messageController.text,
        DateTime.now().toIso8601String(), widget.currentUser.userName);
    ChatRoom currentRoom = await chat;
    for (Message current in currentRoom.messages) {
      current.pair = pair;
    }
    Payload load = Payload(msg.toJson(), "send_message");
    await tcpHelper.sendPayload(load);
    Message toAdd;
    if (currentRoom.messages.length > 0) {
      toAdd = await getNew(currentRoom);
    } else {
      toAdd = Message.empty();
    }

    setState(() {
      newMessages.add(toAdd);
    });
  }

  Future<ChatRoom> getChatRoom() async {
    String text =
        await tcpHelper.sendPayload(new Payload(pair.toJson(), 'get_messages'));
    return await parseRoom(text);
  }

  Future<ChatRoom> parseRoom(String text) async {
    Map roomMap = await jsonDecode(text.substring(2));
    return ChatRoom.fromJson(roomMap);
  }

  Future<Message> parseMessage(String text) async {
    Map msgMap = await jsonDecode(text.substring(2));
    return Message.fromJson(msgMap);
  }

  Future<Message> getNew(ChatRoom chat) async {
    Map json = pair.toJson();
    json.addAll(chat.messages.last.toJson());
    String text = await tcpHelper.sendPayload(new Payload(json, 'get_new'));
    log("we got this: " + text.substring(2));
    return await parseMessage(text);
  }
}
