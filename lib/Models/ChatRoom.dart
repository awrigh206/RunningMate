import 'package:application/Models/Message.dart';

class ChatRoom {
  List<Message> messages;

  ChatRoom(List<Message> messages) {
    this.messages = messages;
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    var list = json['messages'] as List;
    List<Message> userList = list.map((i) => Message.fromJson(i)).toList();

    return new ChatRoom(userList);
  }

  Map<String, dynamic> toJson() => {
        '"messages"': messages,
      };
}
