import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:application/CustomWidgets/Login/EmailField.dart';
import 'package:application/CustomWidgets/Login/PasswordField.dart';
import 'package:application/CustomWidgets/Login/UserNameField.dart';
import 'package:application/DTO/Submission.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/HttpSetting.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  LoginForm(
      {key,
      @required this.tcp,
      @required this.play,
      @required this.goToUserPage})
      : super(key: key);

  final TcpHelper tcp;
  final Function play;
  final Function goToUserPage;
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final userNameField = UserNameField();
  final passwordField = PasswordField();
  final emailField = EmailField();
  final formKey = GlobalKey<FormState>();
  bool isRegistering = false;
  bool processing = false;
  @override
  void dispose() {
    // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            userNameField,
            passwordField,
            Builder(builder: (BuildContext context) {
              if (isRegistering) {
                return Column(
                  children: [
                    emailField,
                    CheckboxListTile(
                        value: isRegistering,
                        title: Text('Register'),
                        onChanged: (bool value) {
                          setState(() {
                            isRegistering = value;
                          });
                        }),
                  ],
                );
              } else {
                return CheckboxListTile(
                    value: isRegistering,
                    title: Text('Register'),
                    onChanged: (bool value) {
                      //so  something  when box is changed
                      setState(() {
                        isRegistering = value;
                      });
                    });
              }
            }),
            Builder(builder: (BuildContext context) {
              return Column(
                children: [
                  //LocalAuthentication(),
                ],
              );
            }),
            ButtonBar(
              children: [
                RaisedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        widget.play(true);
                        User user = new User(
                            userNameField.userNameController.text,
                            passwordField.passwordController.text,
                            emailField.emailController.text);
                        Submission submission =
                            new Submission(isRegistering, user);
                        bool auth =
                            await compute(processSubmission, submission);
                        if (auth) {
                          widget.play(false);
                          widget.goToUserPage(user);
                        } else {
                          widget.play(false);
                        }
                      }
                    },
                    child: Text('Submit')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showTheDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User already exists'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please choose a different user name'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Future<bool> processSubmission(Submission submission) async {
  HttpOverrides.global = new HttpSetting();
  User user = submission.user;
  user.password = Password.hash(user.password, new PBKDF2());
  // User userEncrypted = await encryptUser(user);
  bool userExists = await doesUserExist(user);
  bool authentication = false;
  if (submission.isRegistering && !userExists) {
    register(user);
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
  log(user.toJson().toString());
  final response = await http.post('https://192.168.0.45:9090/user/exists',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Basic QWRtaW46cGFzc3dvcmQ=',
      },
      body: user.toJson());
  //bool authentication = jsonDecode(response.body);
  print(response.body.toString());
  bool authentication = true;
  log("auth status " + authentication.toString());
  return userExists;
}

Future<void> register(User user) async {
  final response = await http.post('https://192.168.0.45:9090/user',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Basic QWRtaW46cGFzc3dvcmQ=',
      },
      body: jsonEncode(user.toJson()));
  login(user);
}

Future<bool> login(User user) async {
  final response = await http.get('https://192.168.0.45:9090/user/auth');
  //bool authentication = jsonDecode(response.body);
  bool authentication = true;
  log("auth status " + authentication.toString());
  return authentication;
}
