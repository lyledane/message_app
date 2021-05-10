import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:message_app/helpers/wrapper.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/screens/Messages/messages.dart';
import 'package:message_app/screens/authentication/nickname.dart';
import 'package:message_app/screens/newChat/newGroup.dart';
import 'package:message_app/screens/newChat/searchIndiv.dart';
import 'package:message_app/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/Messages': (context) => Messages(),
          '/NewGroup': (context) => NewGroup(),
          '/Search': (context) => Search(),
          '/Nickname': (context) => Nickname(),
        },
      ),
    );
  }
}
