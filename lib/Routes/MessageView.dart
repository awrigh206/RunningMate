import 'dart:developer';

import 'package:application/CustomWidgets/MessageList.dart';
import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Pair.dart';
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
                  ),
                ),
                IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.send),
                    onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
      drawer: SideDrawer(currentUser: widget.currentUser),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {});
      //   },
      //   tooltip: "Refresh the message list",
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}
