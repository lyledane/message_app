import 'package:flutter/material.dart';
import 'package:message_app/helpers/helperfunctions.dart';
import 'package:message_app/screens/loading.dart';
import 'package:message_app/services/auth.dart';
import 'package:message_app/services/database.dart';

class Nickname extends StatefulWidget {
  final Function isNn;
  final String email;
  final String pass;

  const Nickname({Key key, this.email, this.pass, this.isNn}) : super(key: key);

  @override
  _NicknameState createState() => _NicknameState();
}

class _NicknameState extends State<Nickname> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  TextEditingController _nickName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      widget.isNn();
                    },
                  ),
                ),
                body: Container(
                  margin: EdgeInsets.all(50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          'What would you like to be called?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) =>
                                  value.isEmpty ? 'Enter an email' : null,
                              controller: _nickName,
                              decoration: InputDecoration(hintText: 'Nickname'),
                            ),
                            SizedBox(height: 50),
                            ElevatedButton(
                              child: Text('Create Account'),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  Map<String, String> userDataMap = {
                                    "userName": _nickName.text,
                                    "userEmail": widget.email,
                                  };
                                  HelperFunctions.saveEmail(widget.email);
                                  HelperFunctions.saveUserName(_nickName.text);
                                  dynamic result = await _authService.signUp(
                                      widget.email,
                                      widget.pass,
                                      _nickName.text);
                                  if (result != null) {
                                    await _databaseService
                                        .addUserInfo(userDataMap);
                                    HelperFunctions.saveEmail('');
                                    HelperFunctions.saveUserName('');
                                  } else if (result == null) {
                                    setState(() => loading = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error SignUp'),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error Nickname'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          );
  }
}
