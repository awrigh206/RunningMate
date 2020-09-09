import 'User.dart';

class Pair {
  User playerOne;
  User playerTwo;

  Pair(User playerOne, User playerTwo) {
    this.playerOne = playerOne;
    this.playerTwo = playerTwo;
  }

  Pair.fromJson(Map<String, dynamic> json)
      : playerOne = json['"playerOne"'],
        playerTwo = json['"playerTwo"'];

  Map<String, dynamic> toJson() => {
        '"playerOne"': playerOne.toJson(),
        '"playerTwo"': playerTwo.toJson(),
      };
}
