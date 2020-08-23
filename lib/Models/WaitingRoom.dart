import 'package:application/Models/User.dart';

class WaitingRoom {
  List<User> waitingUsers;

  WaitingRoom(List<User> users) {
    this.waitingUsers = users;
  }

  WaitingRoom.fromJson(Map<String, dynamic> json)
      : waitingUsers = json['"waitingUsers"'];

  Map<String, dynamic> toJson() => {
        '"waitingUsers"': waitingUsers,
      };
}
