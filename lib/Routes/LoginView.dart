import 'dart:developer';
import 'package:application/Helpers/LocationHelper.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/Payload.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'MapView.dart';
import 'UserView.dart';
import 'package:password_strength/password_strength.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key, this.title}) : super(key: key);

  final String title;
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final locationHelper = LocationHelper();
  final TcpHelper tcp = TcpHelper();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isRegistering = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool authentication = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // FutureBuilder<Placemark>(
              //     future: position,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState != ConnectionState.done) {
              //         return CircularProgressIndicator();
              //       }
              //       if (snapshot.hasError) {
              //         return Icon(Icons.error);
              //       }

              //       if (position == null) {
              //         return new Text('Do not have location permission');
              //       }

              //       Placemark loadedPlace = snapshot.data ?? Placemark;
              //       if (position != null) {
              //         loadedLocation = loadedPlace;
              //         return new Text('You are in the: ' +
              //             loadedPlace.country +
              //             '\n more precisely: ' +
              //             loadedPlace.administrativeArea +
              //             '\n even more precisely: ' +
              //             loadedPlace.subAdministrativeArea +
              //             '\n with the postcode: ' +
              //             loadedPlace.postalCode +
              //             '\n with the streetname: ' +
              //             loadedPlace.thoroughfare);
              //       } else {
              //         Future<LocationData> basicLocation =
              //             locationHelper.getLocationBasic();
              //         return FutureBuilder<LocationData>(
              //             future: basicLocation,
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState !=
              //                   ConnectionState.done) {
              //                 return Icon(Icons.gps_not_fixed);
              //               }

              //               if (basicLocation == null) {
              //                 return new Text(
              //                     'Do not have location permission');
              //               }
              //               LocationData loadedBasic =
              //                   snapshot.data ?? LocationData;
              //               return new Text("Lat: " +
              //                   loadedBasic.latitude.toString() +
              //                   " Lng: " +
              //                   loadedBasic.longitude.toString());
              //             });
              //       }
              //     }),
              Form(
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
                                  String password = Password.hash(
                                      passwordController.text, new PBKDF2());
                                  User user = User(userNameController.text,
                                      password, emailController.text);
                                  bool userExists = await tcp
                                      .userExists(userNameController.text);
                                  if (isRegistering && !userExists) {
                                    tcp.sendPayload(
                                        new Payload(user.toJson(), "register"));
                                    // tcp.sendToServer(
                                    //     new User(userNameController.text,
                                    //         password, emailController.text),
                                    //     "register",
                                    //     true);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserView(
                                                currentUser: user,
                                              )),
                                    );
                                  } else {
                                    log("trying to login");
                                    // authentication = await tcp.login(user);
                                    authentication = await tcp.sendPayload(
                                        new Payload(user.toJson(), "login"));
                                    if (authentication) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserView(
                                                  currentUser: user,
                                                )),
                                      );
                                    } else {
                                      log("no authentication");
                                    }
                                  }
                                  if (userExists && isRegistering) {
                                    //display message that the user already exists in the  system
                                    log("user exists");
                                    showTheDialog();
                                  }
                                }
                              },
                              child: Text('Submit')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapView()),
          );
        },
        tooltip: "Go to google maps with your location",
        child: Icon(Icons.map),
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
