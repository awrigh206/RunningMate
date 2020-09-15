import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:application/Models/WaitingRoom.dart';
import 'package:encrypt/encrypt.dart';

class TcpHelper {
  Future<dynamic> sendPayload(Payload load) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    Completer<dynamic> completer = new Completer<dynamic>();
    socket.write(load.toJson());
    //socket.write(encrypt(load.toJson().toString()));

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

  Future<bool> userExists(String name) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    Completer<bool> completer = new Completer<bool>();
    User user = new User.nameOnly(name);
    socket.write(new Payload(user.toJson(), '"' + "exists" + '"').toJson());

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

  Future<bool> login(User user) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    Completer<bool> completer = new Completer<bool>();
    socket.write(new Payload(user.toJson(), '"' + "login" + '"').toJson());

    socket.listen((data) {
      bool authenticated = parseBool(data);
      completer.complete(authenticated);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    socket.close();
    return completer.future;
  }

  Future<WaitingRoom> getWaitingRoom(User user) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    Completer<WaitingRoom> completer = new Completer<WaitingRoom>();
    socket.write(new Payload(user.toJson(), '"' + "ready" + '"').toJson());
    String jsonData = "";
    WaitingRoom room;

    //Establish the onData, and onDone callbacks
    socket.listen((data) async {
      jsonData = parseText(data);
      Map roomMap = await jsonDecode(jsonData.substring(2));
      room = new WaitingRoom.fromJson(roomMap);
      completer.complete(room);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });
    socket.close();
    return completer.future;
  }

  String parseText(Uint8List data) {
    return new String.fromCharCodes(data).trim();
  }

  bool parseBool(Uint8List data) {
    return intToBool(data.elementAt(0));
  }

  bool intToBool(int number) => number == 0 ? false : true;

  String encrypt(String plainText) {
    final key = Key.fromUtf8("Hello there");
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }
}
