import 'dart:convert';
import 'package:application/Models/Message.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key key, @required this.images}) : super(key: key);
  final Future<List<Message>> images;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: Center(
          child: FutureBuilder(
              future: images,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> actualImages;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: actualImages.length,
                      itemBuilder: (context, index) {
                        Message message = actualImages[index];
                        return new ListTile(
                          title: new Image.memory(
                              base64Decode(message.messageBody)),
                          subtitle: new Text(message.timeStamp),
                        );
                      });
                }
                if (snapshot.hasError) {
                  return new Icon(Icons.error);
                } else {
                  return new CircularProgressIndicator();
                }
              })),
    );
  }
}
