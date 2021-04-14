import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  EmailField({Key key}) : super(key: key);
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
