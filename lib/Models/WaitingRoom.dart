import 'dart:convert';
import 'dart:developer';

import 'package:application/Models/User.dart';

class WaitingRoom {
  List<User> waitingUsers;

  WaitingRoom(List<User> users) {
    this.waitingUsers = users;
  }

  getWaitingUsers() {
    return this.waitingUsers;
  }

  factory WaitingRoom.fromJson(Map<String, dynamic> json) {
    var list = json['waitingUsers'] as List;
    List<User> userList = list.map((i) => User.fromJson(i)).toList();

    return new WaitingRoom(userList);
  }

  Map<String, dynamic> toJson() => {
        '"waitingUsers"': waitingUsers,
      };
}
