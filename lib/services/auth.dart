import 'package:firebase_auth/firebase_auth.dart';
import 'package:message_app/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userName(User user) {
    return user != null
        ? AppUser(uid: user.uid, email: user.email, name: user.displayName)
        : null;
  }

  //auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userName);
  }

  Future signUp(String email, String password, String displayName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await user.updateProfile(displayName: displayName);
      await user.getIdToken(true);
      return _userName(user);
    } catch (e) {
      return null;
    }
  }

  Future userReload() async {
    User user = _auth.currentUser;
    await user.reload();
  }

  Future logIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userName(user);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
