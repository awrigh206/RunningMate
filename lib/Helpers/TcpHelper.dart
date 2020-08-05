import 'dart:convert';
import 'dart:developer';
import 'dart:io';

class TcpHelper {
  Future<String> sendToServer(String message) async {
    String answer;
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    print('connected');

    //send message to the socket
    //socket.write(utf8.encode(message));
    socket.write(message);

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
