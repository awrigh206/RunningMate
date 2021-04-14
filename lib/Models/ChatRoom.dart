import 'package:application/Models/Message.dart';

class ChatRoom {
  List<Message> messages;

  ChatRoom(List<Message> messages) {
    this.messages = messages;
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    var list = json['messages'] as List;
    List<Message> messageList = list.map((i) => Message.fromJson(i)).toList();

    return new ChatRoom(messageList);
  }

  Map<String, dynamic> toJson() => {
        '"messages"': messages,
      };

  @override
  String toString() {
    String text;
    for (int i = 0; i < messages.length; i++) {
      text += messages[i].toString();
    }
    return text;
  }
}
