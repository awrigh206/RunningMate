import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/WaitingRoom.dart';

class TcpHelper {
  Future<dynamic> sendToServer(
      dynamic user, String operation, bool text) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    socket.write(new Payload(user.toJson(), '"' + operation + '"').toJson());

    //Establish the onData, and onDone callbacks
    socket.listen((data) {
      if (text) {
        return parseText(data);
      }
      log("Answer: " + parseBool(data).toString());
      return parseBool(data);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    socket.close();
  }

  Future<WaitingRoom> getWaitingRoom(dynamic user) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    socket.write(new Payload(user.toJson(), '"' + "ready" + '"').toJson());
    String jsonData = "";
    WaitingRoom room;

    //Establish the onData, and onDone callbacks
    socket.listen((data) {
      jsonData = parseText(data);
      log(jsonData.substring(2));
      Map roomMap = jsonDecode(jsonData.substring(2));
      room = new WaitingRoom.fromJson(roomMap);
      return room;
    }, onDone: () {
      print("Done");
      socket.destroy();
      return null;
    });
    socket.close();
    return room;
  }

  String parseText(Uint8List data) {
    return new String.fromCharCodes(data).trim();
  }

  bool parseBool(Uint8List data) {
    return intToBool(data.elementAt(0));
  }

  bool intToBool(int number) => number == 0 ? false : true;
}
