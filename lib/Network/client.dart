import 'package:elephant_client/Exception/database_exception.dart';
import 'package:elephant_client/Exception/server_exception.dart';
import 'package:elephant_client/Model/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Client {
  ///Make a request to the web server
  static Future<String> request(String stringRequest, Map json) async {
    http.Response response = await http.post(
      Uri.parse('http://${Constants.ip}:${Constants.port}/$stringRequest'),
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

  ///Make a request to the web server
  ///
  ///And extract the json from the answer
  static Future<dynamic> requestResult(String stringRequest, Map json) async {
    try {
      return jsonDecode(await request(stringRequest, json));
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Request a delete query to the server
  static Future<void> deleteItem(int id, String type) async {
    try {
      await request('deleteItem', {'id': id, 'item_type': type});
    } catch (e) {
      throw Exception(e);
    }
  }
}
