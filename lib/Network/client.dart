import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '/Exception/database_exception.dart';
import '/Exception/server_exception.dart';

class Client {
  final String _ip;
  final int _port;
  final String _database;
  final String _username;
  String get username => _username;
  final String _password;

  var client = HttpClient();

  Client(this._ip, this._port, this._database, this._username, this._password);

  Future<String> request(String request, json) async {
    http.Response response = await http.post(
      Uri.parse('http://$_ip:$_port/$request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'database': _database,
        'username': _username,
        'password': _password,
        'json': json
      }),
    );

    switch (response.statusCode) {
      case HttpStatus.ok:
        return response.body;
      case HttpStatus.notFound:
        throw Exception(response.body);
      case HttpStatus.serviceUnavailable:
        throw DbException(response.body);
      case HttpStatus.internalServerError:
        throw ServerException(response.body);
      default:
        throw Exception('Not handled error code : ${response.statusCode}'
            '\n${response.body}');
    }
  }
}
