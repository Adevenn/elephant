import 'package:shared_preferences/shared_preferences.dart';

class UserSettings {
  static late SharedPreferences _prefs;

  static Future<String> getDatabase() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('database') ?? '';
  }

  static Future<void> setDatabase(String database) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('database', database);
  }

  static Future<String> getIp() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('ip') ?? '';
  }

  static Future<void> setIp(String ip) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('ip', ip);
  }

  static Future<int> getPort() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('port') ?? 0;
  }

  static Future<void> setPort(int port) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('port', port);
  }

  static Future<bool> getReadOnly() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('read_only') ?? false;
  }

  static Future<void> setReadOnly(bool isReadOnly) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('read_only', isReadOnly);
  }

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
