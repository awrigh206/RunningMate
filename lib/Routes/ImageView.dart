import 'dart:convert';
import 'package:application/Models/ImageMessage.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key key, @required this.images}) : super(key: key);
  final Future<List<ImageMessage>> images;
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
                  List<ImageMessage> actualImages = snapshot.data;
                  if (actualImages.isEmpty) {
                    return Text('You do not have any images');
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: actualImages.length,
                      itemBuilder: (context, index) {
                        ImageMessage message = actualImages[index];
                        return new ListTile(
                          title: new Image.memory(base64Decode(message.base64)),
                          subtitle: new Text(message.name),
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
