import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:application/Helpers/Encryption.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:encrypt/encrypt.dart';

class TcpHelper {
  Future<dynamic> sendPayload(Payload load) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    Completer<dynamic> completer = new Completer<dynamic>();
    socket.write(load.toJson());
    //socket.write(encrypt.encrypt(load.toJson().toString()));

    socket.listen((data) {
      dynamic sent = parseText(data);
      completer.complete(sent);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    socket.close();
    return completer.future;
  }

  Future<bool> sendPayloadBoolean(Payload load) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    Completer<bool> completer = new Completer<bool>();
    socket.write(load.toJson());
    print(load.toJson());

    socket.listen((data) {
      bool exists = parseBool(data);
      completer.complete(exists);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    socket.close();
    return completer.future;
  }

  Future<WaitingRoom> getWaitingRoom(User user) async {
    Completer<WaitingRoom> completer = new Completer<WaitingRoom>();
    String text = await sendPayload(Payload(user.toJson(), 'ready'));
    WaitingRoom room;
    Map roomMap = await jsonDecode(text.substring(2));

    room = WaitingRoom.fromJson(roomMap);
    completer.complete(room);
    return completer.future;
  }

  String parseText(Uint8List data) {
    return new String.fromCharCodes(data).trim();
  }

  bool parseBool(Uint8List data) {
    return intToBool(data.elementAt(0));
  }

  bool intToBool(int number) => number == 0 ? false : true;
}
