import 'package:application/CustomWidgets/LoginForm.dart';
import 'package:application/Helpers/LocationHelper.dart';
import 'package:application/Helpers/TcpHelper.dart';
import 'package:application/Models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MapView.dart';
import 'package:lottie/lottie.dart';

import 'UserView.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key, this.title}) : super(key: key);

  final String title;
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  final locationHelper = LocationHelper();
  final TcpHelper tcp = TcpHelper();
  Color currentColor = Colors.white;
  Future<LottieComposition> composition;
  AnimationController loginAnimation;
  Lottie animation;
  LoginForm form;
  bool processing;

  @override
  void initState() {
    super.initState();
    processing = false;
    composition = fetchAnimation();
    form = new LoginForm(
      tcp: tcp,
      play: playAnimation,
      goToUserPage: goToUserPage,
    );
  }

  playAnimation(bool play) async {
    setState(() {
      processing = play;
    });
  }

  void goToUserPage(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UserView(
                currentUser: user,
              )),
    );
  }

  Future<LottieComposition> fetchAnimation() async {
    var assetData =
        await rootBundle.load('Assets/Animations/world-locations.json');
    return await LottieComposition.fromByteData(assetData);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    loginAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Builder(builder: (BuildContext context) {
                if (processing) {
                  return FutureBuilder(
                      future: composition,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            child: Lottie(composition: snapshot.data),
                            color: Colors.deepPurple,
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                } else {
                  return form;
                }
              }),
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
}
