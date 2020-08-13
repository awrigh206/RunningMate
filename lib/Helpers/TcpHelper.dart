import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:application/Models/Payload.dart';

class TcpHelper {
  Future<String> sendToServer(String message) async {
    String answer;
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    print('connected');

    //send message to the socket
    //socket.write(utf8.encode(message));
    Payload payloadMessage = new Payload(message);
    socket.write(payloadMessage.toJson());

    //Establish the onData, and onDone callbacks
    socket.listen((data) {
      answer = new String.fromCharCodes(data).trim();
      log(answer);
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    socket.close();
  }
}
