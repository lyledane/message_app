import 'package:flutter/material.dart';
import 'package:message_app/screens/loading.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Stream chatRooms;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
            // title: snapshot.data.documents[index].data['chatName']
            );
      },
    );
  }
}
