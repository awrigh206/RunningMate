import 'package:application/Helpers/Encryption.dart';
import 'package:encrypt/encrypt.dart';

class Message {
  String messageBody;
  String timeStamp;
  String sender;

  Message(String body, String timeStamp, String sender) {
    this.messageBody = body;
    this.timeStamp = timeStamp;
    this.sender = sender;
  }

  Message.fromJson(Map<String, dynamic> json)
      : messageBody = json['messageBody'],
        timeStamp = json['timeStamp'],
        sender = json['sender'];

  Map<String, dynamic> toJson() => {
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
}
