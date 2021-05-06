import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:message_app/helpers/constants.dart';
import 'package:message_app/services/database.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  bool isInit = false;
  TextEditingController message = TextEditingController();
  Map arguments;
  Stream<QuerySnapshot> _chats;
  DatabaseService _service = DatabaseService();

  @override
  void initState() {
    isInit = true;
    super.initState();
  }

  getUserChats() async {
    Stream th = await _service.getChats(arguments['uid']);
    setState(() => _chats = th);
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments as Map;
    if (isInit) {
      getUserChats();
      isInit = false;
    }
    return Scaffold(
      appBar: AppBar(title: Text(arguments['name'].toString())),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _chats,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          bool isSender =
                              document.data()['sender'] == Constants.myName;
                          return Container(
                            padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                            child: Bubble(
                              elevation: 3,
                              alignment: isSender
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              // nipWidth: 8,
                              // nipHeight: 24,
                              nip: isSender
                                  ? BubbleNip.rightTop
                                  : BubbleNip.leftTop,
                              color: isSender
                                  ? Colors.green[200]
                                  : Colors.blue[200],
                              child: Text(
                                document.data()['message'],
                                textAlign:
                                    isSender ? TextAlign.right : TextAlign.left,
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Container();
              }),
          //
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: message,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  minLines: 1,
                )),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (message.text != "") {
                        Map<String, dynamic> mess = {
                          'time': DateTime.now().millisecondsSinceEpoch,
                          'message': message.text,
                          'sender': Constants.myName,
                        };
                        await _service.sendMessage(mess, arguments['uid']);
                        setState(() {
                          message.text = '';
                        });
                      }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Scaffold(
//       appBar: AppBar(
//         title: Text('UserName'),
//       ),
//       body: ListView.builder(
//         itemBuilder: (context, index) {
//           return Bubble(
//             margin: BubbleEdges.all(10),
//             child: Text(
//               '',
//               textAlign: TextAlign.end,
//             ),
//           );
//         },
//         itemCount: 0,
//       ),
//     );
