import 'dart:convert';
import 'dart:io';

class TcpHelper {
  Future<String> sendToServer(String message) async {
    Socket socket = await Socket.connect('82.23.232.59', 9090);
    print('connected');

    //send message to the socket
    socket.add(utf8.encode(message));
    socket.close();
  }
}
