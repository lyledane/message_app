import 'package:flutter/material.dart';
import 'package:message_app/screens/login.dart';
import 'package:message_app/screens/home.dart';
import 'package:message_app/screens/messages.dart';
import 'package:message_app/screens/newGroup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/Messages': (context) => Messages(),
        '/Home': (context) => Home(),
        '/NewGroup': (context) => NewGroup(),
      },
    );
  }
}
