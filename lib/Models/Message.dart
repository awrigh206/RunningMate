import 'package:application/Helpers/Encryption.dart';
import 'package:encrypt/encrypt.dart';

import 'Pair.dart';

class Message {
  Pair pair;
  String messageBody;
  String timeStamp;
  String sender;

  Message(Pair pair, String body, String timeStamp, String sender) {
    this.messageBody = body;
    this.timeStamp = timeStamp;
    this.sender = sender;
    this.pair = pair;
  }

  Message.empty() {
    this.messageBody = " ";
    this.sender = " ";
    this.timeStamp = " ";
  }

  Message.fromJson(Map<String, dynamic> json)
      : pair = json['pair'],
        messageBody = json['messageBody'],
        timeStamp = json['timeStamp'],
        sender = json['sender'];

  Map<String, dynamic> toJson() => {
        '"pair"': pair.toJson().toString(),
        '"messageBody"': '"' + messageBody + '"',
        '"timeStamp"': '"' + timeStamp + '"',
        '"sender"': '"' + sender + '"',
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
