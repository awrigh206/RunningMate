import 'package:application/Helpers/Encryption.dart';
import 'package:encrypt/encrypt.dart';

import 'Pair.dart';

class Message {
  String messageBody;
  String timeStamp;
  String sender;
  String recipient;

  Message(String body, String timeStamp, String sender, String recipient) {
    this.messageBody = body;
    this.timeStamp = timeStamp;
    this.sender = sender;
    this.recipient = recipient;
  }

  Message.empty() {
    this.recipient = "";
    this.messageBody = " ";
    this.sender = " ";
    this.timeStamp = " ";
  }

  Message.fromJson(Map<String, dynamic> json)
      : messageBody = json['messageBody'],
        timeStamp = json['timeStamp'],
        sender = json['sender'],
        recipient = json['recipient'];

  Map<String, dynamic> toJson() => {
        'messageBody': messageBody,
        'timeStamp': timeStamp,
        'sender': sender,
        'recipient': recipient
      };

  encryptDetails() async {
    Encryption crypt = Encryption();
    Encrypted encryptedBody = await crypt.encrypt(this.messageBody);
    this.messageBody = encryptedBody.base64;

    Encrypted encryptedTime = await crypt.encrypt(this.timeStamp);
    this.timeStamp = encryptedTime.base64;

    Encrypted encryptedSender = await crypt.encrypt(this.sender);
    this.sender = encryptedSender.base64;
  }

  @override
  String toString() {
    return "Body: " + messageBody + " , Sender: " + sender;
  }
}
