import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' as Biometric;

class LocalAuthentication extends StatefulWidget {
  LocalAuthentication({Key key}) : super(key: key);

  @override
  _LocalAuthenticationState createState() => _LocalAuthenticationState();
}

class _LocalAuthenticationState extends State<LocalAuthentication> {
  final Biometric.LocalAuthentication localAuth =
      Biometric.LocalAuthentication();
  bool canCheckBiometrics;
  bool isAuthenticating = false;
  String status = "";

  Future<void> checkBiometrics() async {
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> authenticate() async {
    log('authenticate is called');
    bool authenticated = false;
    try {
      setState(() {
        isAuthenticating = true;
        status = 'Working';
      });
      authenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        isAuthenticating = false;
        status = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      status = message;
    });
  }

  void cancelAuthentication() {
    localAuth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        isAuthenticating = true;
        await authenticate();
      },
      child: Text('Authenticate'),
    );
  }
}
