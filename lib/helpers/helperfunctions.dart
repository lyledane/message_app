import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String emailKey = "EMAIL";
  static String userNameKey = "USERNAME";

  static String uidkey = "UID";
  static Future<bool> saveUserName(String name) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return await _sharedPreferences.setString(userNameKey, name);
  }

  static Future<bool> saveEmail(String email) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return await _sharedPreferences.setString(emailKey, email);
  }

  static Future<String> getUserName() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return await _sharedPreferences.getString(userNameKey);
  }

  static Future<String> getEmail() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    return _sharedPreferences.getString(emailKey);
  }
}
