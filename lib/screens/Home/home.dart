import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_app/helpers/constants.dart';
import 'package:message_app/helpers/helperfunctions.dart';
import 'package:message_app/services/auth.dart';
import 'package:message_app/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _authService = AuthService();
  DatabaseService _databaseService = DatabaseService();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Stream _chatlist;
  String myName;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getRecipient(members) {
    List<dynamic> recipients = members;
    recipients.remove(Constants.myName);
    return recipients.toString().replaceAll('[', '').replaceAll(']', '');
  }

  getUserInfo() async {
    var newName = await HelperFunctions.getUserName();
    setState(() {
      Constants.myName = newName;
    });
    print(Constants.myName);
    dynamic that = await _databaseService.getUserChatList(Constants.myName);
    setState(() {
      _chatlist = that;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.myName),
        actions: [IconButton(icon: Icon(Icons.border_color), onPressed: () {})],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(Constants.myName),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(color: Colors.amberAccent)),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('New Direct Message'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Search');
              },
            ),
            ListTile(
              leading: Icon(Icons.group_add),
              title: Text('New Group'),
              onTap: () {
                Navigator.pushNamed(context, '/NewGroup');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Constants.myName = "";
                _authService.signOut();
              },
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                String recipientList = getRecipient(document.data()['members']);
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/Messages',
                        arguments: {'uid': document.id, 'name': recipientList});
                  },
                  leading: Icon(Icons.person),
                  title: Text(recipientList),
                );
              }).toList(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
