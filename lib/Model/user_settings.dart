import 'package:shared_preferences/shared_preferences.dart';

class UserSettings{

  static late SharedPreferences _prefs;

  static Future<String> getIp() async{
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('ip') ?? '';
  }

  static Future<void> setIp(String ip) async{
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('ip', ip);
  }

  static Future<int> getPort() async{
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getInt('port') ?? 0;
  }

  static Future<void> setPort(int port) async{
    _prefs = await SharedPreferences.getInstance();
    _prefs.setInt('port', port);
  }

  static Future<String> getDatabase() async{
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('database') ?? '';
  }

  static Future<void> setDatabase(String database) async{
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('database', database);
  }

  static Future<String> getUsername() async{
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('username') ?? '';
  }

  static Future<void> setUsername(String username) async{
    _prefs = await SharedPreferences.getInstance();
    _prefs.setString('username', username);
  }
}