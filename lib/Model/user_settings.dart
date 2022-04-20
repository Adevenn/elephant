import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static late SharedPreferences _prefs;

  static Future<bool> getTheme() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('theme') ?? true;
  }

  static Future<void> setTheme(bool isDark) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('theme', isDark);
  }

  static Future<String> getUsername() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('username') ?? '';
  }

  static Future<void> setUsername(String username) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('username', username);
  }
}
