import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/TcpHelper.dart';
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

  @override
  void initState() {
    super.initState();
    tcpHelper = TcpHelper();
  }

  @override
  Widget build(BuildContext context) {
    Pair pair = new Pair(widget.currentUser, widget.userTalkingTo);
    Future<Message> messages =
        tcpHelper.sendPayload(new Payload(pair.toJson(), 'message'));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userTalkingTo.userName),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: FutureBuilder(
                future: messages, builder: (context, snapshot) {})),
      ),
      drawer: SideDrawer(currentUser: widget.currentUser),
    );
  }
}
