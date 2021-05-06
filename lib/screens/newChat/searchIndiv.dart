import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:message_app/helpers/constants.dart';
import 'package:message_app/screens/loading.dart';
import 'package:message_app/services/database.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool toMessageload = false;
  bool isLoading = false;
  QuerySnapshot searchResults;
  bool hasSearched = false;
  DatabaseService _databaseService = DatabaseService();

  searchUserName(_search) async {
    if (_search != '') {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot search = await _databaseService.searchByName(_search);
      // search.docs.length;
      setState(() {
        searchResults = search;
        isLoading = false;
        hasSearched = true;
      });
    }
  }

  doesChatRoomExist(group) async {
    return await _databaseService.chatRoomExists(Constants.myName, group);
  }

  sendMessage(String userName, context) async {
    List<dynamic> recipients = [userName, Constants.myName];
    Map<String, List<dynamic>> members = {'members': recipients};
    dynamic crExist = await doesChatRoomExist(recipients);
    print(crExist);
    if (crExist == null) {
      dynamic result = await _databaseService.addChatroom(members);

      if (result != null) {
        print('inside not null');
        setState(() => toMessageload = true);
        Navigator.popAndPushNamed(context, '/Messages',
            arguments: {'uid': result, 'name': userName});
      } else {
        setState(() => toMessageload = false);
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: SnackBar(content: Text('Error Creating chatroom'))));
    } else {
      Navigator.popAndPushNamed(context, '/Messages',
          arguments: {'uid': crExist, 'name': userName});
    }
  }

  @override
  Widget build(BuildContext context) {
    return toMessageload
        ? Loading()
        : Scaffold(
            appBar: AppBar(),
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (string) {
                            searchUserName(string);
                          },
                        ),
                      ),
                    ],
                  ),
                  if (isLoading)
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Center(
                          child: SpinKitChasingDots(
                        color: Colors.blue,
                        size: 50.0,
                      )),
                    )
                  else
                    hasSearched
                        ? Expanded(
                            child: ListView(
                              children: searchResults.docs
                                  .map((DocumentSnapshot document) {
                                return ListTile(
                                  onTap: () {
                                    sendMessage(
                                        document.data()['userName'], context);
                                  },
                                  leading: Icon(Icons.person),
                                  trailing: IconButton(
                                    icon: Icon(Icons.chat),
                                    onPressed: () {
                                      sendMessage(
                                          document.data()['userName'], context);
                                    },
                                  ),
                                  title: Text(document.data()['userName']),
                                );
                              }).toList(),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Center(
                              child: Text(
                                "It's quiet here...try using the Search bar",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                ],
              ),
            ),
          );
  }
}
