import 'package:application/Helpers/Encryption.dart';
import 'package:encrypt/encrypt.dart';

class User {
  String userName;
  String password;
  String email;

  User(String userName, String password, String email) {
    this.userName = userName;
    this.password = password;
    this.email = email;
  }

  User.nameOnly(String userName) {
    this.userName = userName;
    this.password = '';
    this.email = '';
  }

  User.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        password = json['password'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        '"userName"': '"' + userName + '"',
        '"password"': '"' + password + '"',
        '"email"': '"' + email + '"',
      };
  encryptDetails() async {
    Encryption crypt = Encryption();
    Encrypted encryptedName = await crypt.encrypt(this.userName);
    this.userName = encryptedName.base64;

    Encrypted encryptedEmail = await crypt.encrypt(this.email);
    this.email = encryptedEmail.base64;
  }
}
