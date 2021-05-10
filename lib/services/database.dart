import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserInfo(userData) async {
    try {
      _firestore.collection("users").add(userData);
    } catch (e) {}
  }

  addChatroom(userData) async {
    print(userData);
    String id;
    try {
      await _firestore
          .collection("chatRoom")
          .add(userData)
          .then((value) => id = value.id);
      return id;
    } catch (e) {
      return null;
    }
  }

  chatRoomExists(String userData, List<dynamic> groupMembers) async {
    print('inside databse');
    print(userData);
    print(groupMembers);
    try {
      String id = await _firestore
          .collection('chatRoom')
          .where('members', arrayContains: userData)
          .get()
          .then((value) {
        print(value.docs.length);
        for (var i = 0; i < value.docs.length; i++) {
          print('inside for');
          if (value.docs[i].data()['members'].length == groupMembers.length) {
            List<dynamic> mem = value.docs[i].data()['members'];
            bool check = true;
            for (var a = 0; a < groupMembers.length; a++) {
              if (!(mem.contains(groupMembers[a]))) {
                check = false;
              }
            }
            print(check);
            if (check) {
              return value.docs[i].id;
            }
          }
        }
        return null;
      });
      return id;
    } catch (e) {}
  }

  sendMessage(message, chatroom) {
    try {
      _firestore
          .collection('chatRoom')
          .doc(chatroom)
          .collection('chat')
          .add(message);
    } catch (e) {}
  }

  searchByName(String value) {
    try {
      return _firestore
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: value)
          .get();
    } catch (e) {}
  }

  getUserChatList(String itIsMyName) async {
    try {
      return _firestore
          .collection("chatRoom")
          .where("members", arrayContains: itIsMyName)
          .snapshots();
    } catch (e) {
      print('FAILED TO GET CHATLIST');
    }
  }

  getChats(chatroom) {
    try {
      return _firestore
          .collection('chatRoom')
          .doc(chatroom)
          .collection('chat')
          .orderBy('time')
          .snapshots();
    } catch (e) {
      return null;
    }
  }
}
