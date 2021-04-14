import 'package:application/Helpers/Encryption.dart';
import 'package:encrypt/encrypt.dart';
import 'Pair.dart';

class Message {
  String messageBody;
  String timeStamp;
  List<String> usersInvolved;

  Message(String body, String timeStamp, List<String> usersInvolved) {
    this.messageBody = body;
    this.timeStamp = timeStamp;
    this.usersInvolved = usersInvolved;
  }

  Message.empty() {
    this.messageBody = " ";
    this.timeStamp = " ";
    this.usersInvolved = List.empty(growable: true);
  }

  // Message.fromJson(Map<String, dynamic> json)
  //     : messageBody = json['messageBody'],
  //       timeStamp = json['timeStamp'],
  //       usersInvolved = json['usersInvolved'];
  factory Message.fromJson(Map<String, dynamic> parsedJson) {
    var sender = parsedJson['sender'];
    var recipient = parsedJson['recipient'];
    List<String> usersList = new List<String>.from([sender, recipient]);
    return Message(
        parsedJson['messageBody'], parsedJson['timeStamp'], usersList);
  }

  Map<String, dynamic> toJson() => {
        'messageBody': messageBody,
        'timeStamp': timeStamp,
        'usersInvolved': usersInvolved,
      };

  encryptDetails() async {
    Encryption crypt = Encryption();
    Encrypted encryptedBody = await crypt.encrypt(this.messageBody);
    this.messageBody = encryptedBody.base64;

    Encrypted encryptedTime = await crypt.encrypt(this.timeStamp);
    this.timeStamp = encryptedTime.base64;

    // Encrypted encryptedSender = await crypt.encrypt(this.sender);
    // this.sender = encryptedSender.base64;
  }

  @override
  String toString() {
    return "Body: " + messageBody;
  }
}
