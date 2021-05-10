import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:message_app/helpers/constants.dart';
import 'package:message_app/services/database.dart';
import 'package:message_app/services/storage.dart';
import 'package:image_picker/image_picker.dart';

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
  String _imageFile;

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
                            child: Column(children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  document.data()['sender'],
                                  textAlign: isSender
                                      ? TextAlign.right
                                      : TextAlign.left,
                                ),
                              ),
                              Bubble(
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
                                child:
                                    document.data()['message_type'] == "String"
                                        ? Text(
                                            document.data()['message'],
                                            textAlign: isSender
                                                ? TextAlign.right
                                                : TextAlign.left,
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(5),
                                            child: Image.network(
                                                document.data()['message']),
                                            constraints: BoxConstraints(
                                              maxHeight: (MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2),
                                              maxWidth: (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3) *
                                                  2,
                                              minWidth: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              minHeight: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                            ),
                                          ),
                              ),
                            ]),
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
                IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () async {
                      await _pickImage();
                      if (_imageFile != null) {
                        print(_imageFile);
                        Map<String, dynamic> mess = {
                          'time': DateTime.now().microsecondsSinceEpoch,
                          'message': _imageFile,
                          'sender': Constants.myName,
                          'message_type': 'Image'
                        };
                        await _service.sendMessage(mess, arguments['uid']);
                      }
                    }),
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
                          'time': DateTime.now().microsecondsSinceEpoch,
                          'message': message.text,
                          'sender': Constants.myName,
                          'message_type': 'String'
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

  Future<void> _pickImage() async {
    setState(() {
      _imageFile = null;
    });
    final selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      print(selected.path);
      String filestring =
          await StorageService().startUpload(File(selected.path));
      setState(() {
        _imageFile = filestring;
      });
    }
  }
}
