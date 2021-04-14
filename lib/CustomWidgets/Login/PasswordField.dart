import 'package:flutter/material.dart';
import 'package:password_strength/password_strength.dart';

class PasswordField extends StatelessWidget {
  PasswordField({Key key}) : super(key: key);
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
