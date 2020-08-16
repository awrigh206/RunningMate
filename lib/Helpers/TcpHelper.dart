import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';

class TcpHelper {
  Future<String> sendToServer(User user, String operation) async {
    String answer;
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    print('connected');

    //send message to the socket
    //socket.write(utf8.encode(message));
    //Payload payloadMessage = new Payload(message);
    socket.write(new Payload(user.toJson(), '"' + operation + '"').toJson());

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
