import 'package:http/http.dart' as http;
import '/Model/constants.dart';
import 'dart:convert';
import 'dart:io';

import '/Exception/database_exception.dart';
import '/Exception/server_exception.dart';

class Client {
  final String _username;
  String get username => _username;
  final String _password;

  var client = HttpClient();

  Client(this._username, this._password);

  Future<String> request(String request, json) async {
    http.Response response = await http.post(
      Uri.parse('http://${Constants.ip}:${Constants.port}/$request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
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
