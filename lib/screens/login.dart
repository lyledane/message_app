import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      margin: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to',
            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),
          Text(
            'Messaging!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 50,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Email'),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Home');
              },
              child: Text('Login')),
          ElevatedButton(onPressed: () {}, child: Text('SignUp')),
        ],
      ),
    )));
  }
}
