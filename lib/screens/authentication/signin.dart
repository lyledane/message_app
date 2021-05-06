import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_app/helpers/helperfunctions.dart';
import 'package:message_app/screens/loading.dart';
import 'package:message_app/services/auth.dart';
import 'package:message_app/services/database.dart';

class SignUp extends StatefulWidget {
  final String email;
  final String pass;
  final Function isNn;
  final Function setArgs;

  const SignUp({Key key, this.isNn, this.setArgs, this.email, this.pass})
      : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _authService = AuthService();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool toggleObscure = true;

  @override
  void initState() {
    super.initState();
    if (widget.email != "" || widget.pass != "") {
      _email.text = widget.email;
      _pass.text = widget.pass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            value.isEmpty ? 'Enter an email' : null,
                        controller: _email,
                        decoration: InputDecoration(hintText: 'Email'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) => value.length < 6
                                  ? 'Enter a password 6+ long'
                                  : null,
                              controller: _pass,
                              decoration: InputDecoration(hintText: 'Password'),
                              obscureText: toggleObscure,
                            ),
                          ),
                          IconButton(
                              icon: toggleObscure
                                  ? Icon(Icons.remove_red_eye_outlined)
                                  : Icon(Icons.remove_red_eye),
                              onPressed: () {
                                setState(() {
                                  toggleObscure = !toggleObscure;
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic userName = await DatabaseService()
                                .getUserInfo(_email.text);
                            await HelperFunctions.saveEmail(_email.text);
                            await HelperFunctions.saveUserName(
                                userName == null ? '' : userName);
                            dynamic result = await _authService.logIn(
                                _email.text, _pass.text);

                            if (result == null) {
                              await HelperFunctions.saveEmail('');
                              await HelperFunctions.saveUserName('');
                              setState(() => loading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error Login')));
                            }
                          }
                        },
                        child: Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.setArgs(_email.text, _pass.text);
                            widget.isNn();
                          }
                        },
                        child: Text('SignUp'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )));
  }
}
