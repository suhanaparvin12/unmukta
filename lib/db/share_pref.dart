import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefference {
  static SharedPreferences? _preferences;
  static const String key = 'usertype';
  static const String key1 = "isToggled";

  static init() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUserType(String type) async {
    return await _preferences!.setString(key, type);
  }

  static Future saveLocation(bool isSet) async {
    await _preferences!.setBool(key1, isSet);
  }

  static Future<bool> getLocation() async {
    return _preferences!.getBool('isToggled') ?? false;
  }

  static Future<String>? getUserType() async =>
      await _preferences!.getString(key) ?? "";

  static clear() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
