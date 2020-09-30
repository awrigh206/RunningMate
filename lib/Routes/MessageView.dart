import 'dart:developer';

import 'package:application/CustomWidgets/MessageList.dart';
import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
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

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
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
              padding: new EdgeInsets.all(10.0),
              child: Center(
                child: SingleChildScrollView(
                  primary: true,
                  child: MessageList(
                      pair: new Pair(widget.currentUser, widget.userTalkingTo)),
                ),
              ))
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
                      Pair pair =
                          Pair(widget.currentUser, widget.userTalkingTo);
                      Message msg = Message(
                          pair,
                          messageController.text,
                          DateTime.now().toIso8601String(),
                          widget.currentUser.userName);
                      Payload load = Payload(msg.toJson(), "send_message");
                      tcpHelper.sendPayload(load);
                    }),
              ],
            ),
          ),
        ),
      ),
      drawer: SideDrawer(currentUser: widget.currentUser),
    );
  }
}
