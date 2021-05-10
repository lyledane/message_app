import 'package:flutter/material.dart';
import 'package:message_app/helpers/authentication.dart';
import 'package:message_app/models/user.dart';
import 'package:message_app/screens/Home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    if (user == null) {
      return Authentication();
    } else {
      return Home();
    }
  }
}
