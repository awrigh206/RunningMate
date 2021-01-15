import 'User.dart';

class Pair {
  User issuingUser;
  User challengedUser;

  Pair(User issuingUser, User challengedUser) {
    this.issuingUser = issuingUser;
    this.challengedUser = challengedUser;
  }

  Pair.fromJson(Map<String, dynamic> json)
      : issuingUser = json['issuingUser'],
        challengedUser = json['challengedUser'];

  Map<String, dynamic> toJson() => {
        'playerOne': issuingUser.toJson(),
        'challengedUser': challengedUser.toJson(),
      };
}
