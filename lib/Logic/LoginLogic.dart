import 'dart:io';

import 'package:application/DTO/Submission.dart';
import 'package:application/Helpers/HttpHelper.dart';
import 'package:application/HttpSetting.dart';
import 'package:application/Models/User.dart';

class LoginLogic {}

Future<User> userFromServer(User user) async {
  HttpHelper helper = HttpHelper(user);
  final res = await helper.getRequest(
      'https://192.168.0.45:9090/' + 'user/email?name=' + user.userName, true);
  User gotUser = User.empty();
  gotUser.userName = res.data['name'];
  gotUser.password = user.password;
  gotUser.email = res.data['email'];
  print(gotUser.toString());
  return gotUser;
}

Future<bool> processSubmission(Submission submission) async {
  //enable self signed certificate
  HttpOverrides.global = new HttpSetting();
  User user = submission.user;
  bool userExists = await doesUserExist(user);
  bool authentication = false; //auth is false by default
  if (submission.isRegistering && !userExists) {
    authentication = await register(user);
  } else {
    authentication = await login(user);
  }
  return authentication;
}

Future<User> encryptUser(User user) async {
  await user.encryptDetails();
  return user;
}

Future<bool> doesUserExist(User user) async {
  bool userExists = false;
  HttpHelper helper = HttpHelper(user);
  final response = await helper.postRequest(
      'https://192.168.0.45:9090/' + 'user/exists', user.toJson());
  //userExists = jsonDecode(response.data);
  //TODO: fix this check
  userExists = false;
  return userExists;
}

Future<bool> register(User user) async {
  HttpHelper helper = HttpHelper(user);
  final response = await helper.postRequest(
      'https://192.168.0.45:9090/' + 'user', user.toJson());
  return true;
}

Future<bool> login(User user) async {
  HttpHelper helper = HttpHelper(user);
  bool auth = await helper.login('https://192.168.0.45:9090/user/auth', true);
  return auth;
}
