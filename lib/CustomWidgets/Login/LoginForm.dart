import 'dart:developer';

import 'package:application/CustomWidgets/Login/EmailField.dart';
import 'package:application/CustomWidgets/Login/PasswordField.dart';
import 'package:application/CustomWidgets/Login/UserNameField.dart';
import 'package:application/DTO/Submission.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';

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
                            new Submission(isRegistering, user, widget.tcp);
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
  User user = submission.user;
  user.password = Password.hash(user.password, new PBKDF2());
  User userEncrypted = await encryptUser(user);
  bool userExists = await doesUserExist(userEncrypted, submission.tcpHelper);
  bool authentication = false;
  log("user exists: " + userExists.toString());
  log("authenticated: " + authentication.toString());
  if (submission.isRegistering && !userExists) {
    register(userEncrypted, submission.tcpHelper);
  } else {
    authentication = await login(
      userEncrypted,
      submission.tcpHelper,
    );
  }
  return authentication;
}

Future<User> encryptUser(User user) async {
  await user.encryptDetails();
  return user;
}

Future<bool> doesUserExist(User user, TcpHelper tcpHelper) async {
  bool userExists =
      await tcpHelper.sendPayloadBoolean(new Payload(user.toJson(), 'exists'));
  return userExists;
}

Future<void> register(User user, TcpHelper tcpHelper) async {
  tcpHelper.sendPayload(new Payload(user.toJson(), 'register'));
  login(user, tcpHelper);
}

Future<bool> login(User user, TcpHelper tcpHelper) async {
  bool authentication =
      await tcpHelper.sendPayloadBoolean(Payload(user.toJson(), 'login'));
  return authentication;
}
