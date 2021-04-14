import 'package:flutter/material.dart';

class UserNameField extends StatelessWidget {
  UserNameField({Key key}) : super(key: key);
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
    );
  }
}
