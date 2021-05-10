import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:message_app/helpers/constants.dart';
import 'package:message_app/screens/loading.dart';
import 'package:message_app/services/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  DatabaseService _databaseService = DatabaseService();
  QuerySnapshot searchResults;
  bool isLoading = false;
  bool hasSearched = false;
  bool toMessageload = false;
  List<dynamic> recipients = [];

  searchUserName(name) async {
    if (name != '') {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot search = await _databaseService.searchByName(name);
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

  sendGroupMessage(context) async {
    recipients.add(Constants.myName);
    List<dynamic> isRead = [];
    recipients.forEach((element) {
      isRead.add('false');
    });

    dynamic crExist = await doesChatRoomExist(recipients);
    if (crExist == null) {
      print('crnull');
      Map<String, dynamic> members = {
        'members': recipients,
        'isRead': isRead,
        'latestMessage': DateTime.now().microsecondsSinceEpoch,
      };
      dynamic result = await _databaseService.addChatroom(members);

      if (result != null) {
        // print('inside not null');
        setState(() => toMessageload = true);
        recipients.remove(Constants.myName);
        String userNames =
            recipients.toString().replaceAll('[', '').replaceAll(']', '');
        Navigator.popAndPushNamed(context, '/Messages',
            arguments: {'uid': result, 'name': userNames});
      } else {
        setState(() => toMessageload = false);
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: SnackBar(content: Text('Error Creating chatroom'))));
    } else {
      print('crnotnull');
      recipients.remove(Constants.myName);
      String userNames =
          recipients.toString().replaceAll('[', '').replaceAll(']', '');
      Navigator.popAndPushNamed(context, '/Messages',
          arguments: {'uid': crExist, 'name': userNames});
    }
  }

  @override
  Widget build(BuildContext context) {
    double dimensions = MediaQuery.of(context).size.width / 4;
    return toMessageload
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Add Participants'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      sendGroupMessage(context);
                    },
                    child: Text('Save'))
              ],
            ),
            body: Material(
              child: ListView(
                children: [
                  Container(
                    height: dimensions,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recipients.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(13),
                          height: dimensions,
                          width: dimensions,
                          child: Center(
                            child: Container(
                              height: double.maxFinite,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text(recipients[index]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: TextField(
                      onChanged: (string) => searchUserName(string),
                      decoration: InputDecoration(
                        hintText: 'Search user...',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Colors.blueGrey[300], width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          borderSide: BorderSide(
                              color: Colors.blueGrey[300], width: 1.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
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
                        ? Container(
                            height: 500,
                            width: double.maxFinite,
                            child: ListView(
                              children: searchResults.docs.map(
                                (DocumentSnapshot document) {
                                  String userName = document.data()['userName'];
                                  bool list = recipients.contains(userName);
                                  bool isUser = userName == Constants.myName;
                                  return ListTile(
                                    title: Text(userName),
                                    trailing: IconButton(
                                        icon: isUser
                                            ? Icon(
                                                Icons.person,
                                                color: Colors.red,
                                              )
                                            : list
                                                ? Icon(
                                                    Icons.person_remove,
                                                    color: Colors.red,
                                                  )
                                                : Icon(
                                                    Icons.person_add,
                                                    color: Colors.blue,
                                                  ),
                                        onPressed: () {
                                          if (!isUser)
                                            setState(() {
                                              list
                                                  ? recipients.remove(userName)
                                                  : recipients.add(userName);
                                            });
                                          print(recipients.toString());
                                        }),
                                  );
                                },
                              ).toList(),
                              // itemBuilder: (context, index) {
                            ),
                          )
                        : Container(),
                ],
              ),
            ));
  }
}
