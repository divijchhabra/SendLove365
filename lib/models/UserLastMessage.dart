import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserLastMessage {
  static SharedPreferences? _preferences;

  static const _keyLastMsg = 'lastMessage';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLastMsg(List<Map<String, String>> msg) async {
    var data = json.encode(msg);

    return await _preferences!.setString(_keyLastMsg, data);
  }

  static Future<List<Map<String, String>>> getLastMsg() async {
    final lastMsg = _preferences!.getString(_keyLastMsg);
    var mapMsg = json.decode(lastMsg!);

    return mapMsg;
  }
}
