import 'package:http/http.dart' as http;
import '/Model/constants.dart';
import 'dart:convert';
import 'dart:io';

import '/Exception/database_exception.dart';
import '/Exception/server_exception.dart';

class Client {
  ///Make a request to the http server
  static Future<String> request(String request, Map json) async {
    http.Response response = await http.post(
      Uri.parse('http://${Constants.ip}:${Constants.port}/$request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': Constants.username,
        'password': Constants.password,
        'json': jsonEncode(json)
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

  ///Make a request to the http server
  ///
  ///And extract the json
  static Future<dynamic> requestResult(String request, Map json) async {
    try {
      return jsonDecode(await Client.request(request, json));
    } catch (e) {
      throw Exception(e);
    }
  }
}
