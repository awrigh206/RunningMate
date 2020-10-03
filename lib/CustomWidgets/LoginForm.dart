import 'dart:developer';

import 'package:application/DTO/Submission.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'package:password_strength/password_strength.dart';

class LoginForm extends StatefulWidget {
  LoginForm(
      {Key key,
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
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isRegistering = false;
  bool processing = false;
  @override
  void dispose() {
    // Clean up the controller
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool getProcessing() {
    return processing;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              controller: userNameController,
              decoration: const InputDecoration(
                hintText: 'User Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your username';
                }
                if (value.contains(' ')) {
                  return 'Please do not use spaces';
                }
                return null;
              },
            ),
            TextFormField(
              autocorrect: false,
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                double passwordStrength =
                    estimatePasswordStrength(passwordController.text);
                if (passwordStrength < 0.3) {
                  return 'Your password is too weak';
                }
                if (value.contains(' ')) {
                  return 'Please do not use spaces';
                }
                return null;
              },
            ),
            Builder(builder: (BuildContext context) {
              if (isRegistering) {
                return Column(
                  children: [
                    TextFormField(
                      autocorrect: false,
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (value) {
                        String email = emailController.text;
                        if (!EmailValidator.validate(email)) {
                          return 'That email is not valid';
                        }
                        if (value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (value.contains(' ')) {
                          return 'Please do not use spaces';
                        }
                        return null;
                      },
                    ),
                    CheckboxListTile(
                        value: isRegistering,
                        title: Text('Register'),
                        onChanged: (bool value) {
                          //so  something  when box is changed
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
                        User user = new User(userNameController.text,
                            passwordController.text, emailController.text);
                        Submission submission = new Submission(isRegistering,
                            user, widget.goToUserPage, widget.play, widget.tcp);
                        compute(processSubmission, submission);
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

Future<void> processSubmission(Submission submission) async {
  bool userExists = await doesUserExist(submission.user, submission.tcpHelper);
  bool authentication = false;
  if (submission.isRegistering && !userExists) {
    register(submission.user, submission.tcpHelper, submission.goToUserPage);
  } else {
    authentication = await login(
        submission.user, submission.tcpHelper, submission.goToUserPage);
  }
  if (userExists && submission.isRegistering) {
    //display message that the user already exists in the  system
    log("user exists");
    //showTheDialog();
  }
  if (authentication) {
    submission.play(false);
    submission.goToUserPage(submission.user);
  }
}

User encryptUser(User user) {
  return User(user.userName, user.password, user.email);
}

Future<bool> doesUserExist(User user, TcpHelper tcpHelper) async {
  user = encryptUser(user);
  bool userExists =
      await tcpHelper.sendPayloadBoolean(new Payload(user.toJson(), 'exists'));
  return userExists;
}

Future<void> register(
    User user, TcpHelper tcpHelper, Function goToUserPage) async {
  User encrypted = encryptUser(user);
  tcpHelper.sendPayload(new Payload(encrypted.toJson(), 'register'));
  login(user, tcpHelper, goToUserPage);
}

Future<bool> login(
    User user, TcpHelper tcpHelper, Function gotToUserPage) async {
  user.password = Password.hash(user.password, new PBKDF2());
  User userEncrypted = User(user.userName, user.password, user.email);
  await userEncrypted.encryptDetails(); //protect user details
  bool authentication = await tcpHelper
      .sendPayloadBoolean(Payload(userEncrypted.toJson(), 'login'));
  return authentication;
}
