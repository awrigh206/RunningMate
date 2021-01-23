import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:application/CustomWidgets/MessageList.dart';
import 'package:application/CustomWidgets/SideDrawer.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/Models/ImageMessage.dart';
import 'package:application/Models/Message.dart';
import 'package:application/Models/Pair.dart';
import 'package:application/Models/User.dart';
import 'package:application/Routes/ImageView.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class MessageView extends StatefulWidget {
  MessageView({Key key, @required this.pair}) : super(key: key);
  final Pair pair;

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  Timer updateTimer;
  final messageController = TextEditingController();
  Message newMessage;
  Future<List<Message>> messages;
  Future<List<ImageMessage>> imageMessages;
  @override
  void initState() {
    imageMessages = getImages();
    super.initState();
    // chat = getChatRoom();
    updateTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      setState(() {});
      // // newMessage = await getNew(await chat);
      // if (newMessage.messageBody != chatRoom.messages.last.messageBody) {
      //   setState(() {});
      // }
    });
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    messageController.dispose();
    super.dispose();
  }

  Future<List<Message>> getMessages(Pair pair) async {
    GetIt getIt = GetIt.I;
    HttpHelper helper = getIt<HttpHelper>();
    final res =
        await helper.putRequest(getIt<String>() + 'message', pair.toJson());
    if (res.data == null) {
      //then there are no messages
      return List();
    } else {
      var list = res.data as List;
      List<Message> messages = list.map((i) => Message.fromJson(i)).toList();
      // messages = res.data != null ? List.from(res.data) : null;
      return messages;
    }
  }

  Future<void> sendMessage(Message message) async {
    GetIt getIt = GetIt.I;
    HttpHelper helper = getIt<HttpHelper>();
    final res =
        await helper.postRequest(getIt<String>() + 'message', message.toJson());
    messageController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    messages = getMessages(this.widget.pair);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pair.challengedUser),
        actions: [
          IconButton(
              icon: Icon(Icons.image_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            images: imageMessages,
                          )),
                );
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
                      future: messages,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return MessageList(
                            pair: this.widget.pair,
                            messages: snapshot.data,
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
                    decoration: InputDecoration(
                        hintText: 'Message',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            messageController.clear();
                          },
                        )),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: () async {
                      File file = await ImagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 20,
                          maxHeight: 1280,
                          maxWidth: 720);
                      await sendImage(file);
                    }),
                IconButton(
                    icon: Icon(Icons.image),
                    onPressed: () async {
                      File file = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 20,
                          maxHeight: 1280,
                          maxWidth: 720);
                      await sendImage(file);
                    }),
                IconButton(
                    color: Colors.blue,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      Message msg = Message(
                          messageController.text,
                          DateTime.now().toIso8601String(),
                          GetIt.I<User>().userName,
                          widget.pair.challengedUser);
                      sendMessage(msg);
                    }),
              ],
            ),
          ),
        ),
      ),
      drawer: SideDrawer(),
    );
  }

  Future<void> sendImage(File file) async {
    if (file == null) return;
    String base64 = base64Encode(file.readAsBytesSync());
    String name = file.path.split('/').last;

    GetIt getIt = GetIt.I;
    HttpHelper httpHelper = getIt<HttpHelper>();
    ImageMessage msg = ImageMessage(
        base64, name, getIt<User>().userName, widget.pair.challengedUser);
    httpHelper.postRequest(getIt<String>() + 'message/image', msg.toJson());
  }

  Future<List<ImageMessage>> getImages() async {
    GetIt getIt = GetIt.I;
    HttpHelper httpHelper = getIt<HttpHelper>();
    final res = await httpHelper.putRequest(
        getIt<String>() + 'message/images', widget.pair.toJson());
    if (res.data == null) {
      //then there are no messages
      return List();
    } else {
      var list = res.data as List;
      List<ImageMessage> messages =
          list.map((i) => ImageMessage.fromJson(i)).toList();
      // messages = res.data != null ? List.from(res.data) : null;
      return messages;
    }
  }
}
