import 'package:flutter/material.dart';
import 'package:message_app/screens/authentication/nickname.dart';
import 'package:message_app/screens/authentication/signin.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String _email = "";
  String _pass = "";
  bool isNn = false;

  nickNameSreen() {
    setState(() {
      isNn = !isNn;
    });
  }

  setArguments(String email, String pass) {
    setState(() {
      _email = email;
      _pass = pass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isNn
        ? Nickname(
            email: _email,
            pass: _pass,
            isNn: nickNameSreen,
          )
        : SignUp(
            email: _email,
            pass: _pass,
            isNn: nickNameSreen,
            setArgs: setArguments,
          );
  }
}
