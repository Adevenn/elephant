import 'dart:convert';
import 'dart:typed_data';

import '/Model/constants.dart';
import '/Exception/database_exception.dart';
import '/Exception/server_exception.dart';
import '/Model/Elements/element.dart';
import '/Model/Elements/image.dart';
import '/Model/cell.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Network/client.dart';
import '/View/Interfaces/interaction_main.dart';

class Controller implements InteractionMain {
  late Client _client;

  /// VIEW INTERACTION ///

  @override
  Future<void> testConnection(String ip, int port, String database,
      String username, String password) async {
    Constants.username = username;
    _client = Client(ip, port, database, username, password);
    try {
      await _client.request('init', '{}');
    } on DbException {
      throw const DbException('Authentication failed, verify your entries');
    } catch (e) {
      throw const ServerException('404 Not Found');
    }
  }

  @override
  Future<List<Cell>> getCells([String matchWord = '']) async {
    var cells = <Cell>[];
    try {
      var json = jsonEncode({'match_word': matchWord});
      var result = jsonDecode(await _client.request('cells', json));
      cells = List<Cell>.from(result.map((model) => Cell.fromJson(model)));
    } on ServerException catch (e) {
      throw ServerException('$e');
    } on DbException catch (e) {
      throw DbException('$e');
    } catch (e) {
      throw ServerException('$e');
    }
    return cells;
  }

  @override
  Future<List<Sheet>> getSheets(int idCell) async {
    var sheets = <Sheet>[];
    try {
      var json = jsonEncode({'id_cell': idCell});
      var result = jsonDecode(await _client.request('sheets', json));
      sheets = List<Sheet>.from(result.map((model) => Sheet.fromJson(model)));
    } on ServerException catch (e) {
      throw ServerException('$e');
    } on DbException catch (e) {
      throw DbException('$e');
    } catch (e) {
      throw Exception(e);
    }
    return sheets;
  }

  @override
  Future<Sheet> getSheet(int idCell, int sheetIndex) async {
    try {
      var json = jsonEncode({'id_cell': idCell, 'sheet_index': sheetIndex});
      var result = await _client.request('sheet', json);
      return Sheet.fromJson(jsonDecode(result));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Element>> getElements(int idSheet) async {
    var elements = <Element>[];
    try {
      var json = jsonEncode({'id_sheet': idSheet});
      var result = jsonDecode(await _client.request('elements', json));
      elements =
          List<Element>.from(result.map((model) => Element.fromJson(model)));
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
    return elements;
  }

  @override
  Future<Uint8List> getRawImage(int idImage) async {
    try {
      var json = jsonEncode({'id_img': idImage});
      var result = jsonDecode(await _client.request('rawImage', json));
      var imgRaw = jsonDecode(result);
      return Uint8List.fromList(imgRaw['img_raw'].cast<int>());
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addCell(String request, Map<String, dynamic> jsonValues) async {
    try {
      var json = jsonEncode(jsonValues);
      await _client.request(request, json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addSheet(int idCell, String title, String subtitle) async {
    try {
      var json =
          jsonEncode({'id_cell': idCell, 'title': title, 'subtitle': subtitle});
      await _client.request('addSheet', json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addCheckbox(int idSheet) async {
    try {
      var json = jsonEncode({'id_sheet': idSheet});
      await _client.request('addCheckbox', json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addImage(List<Image> images) async {
    try {
      for (var image in images) {
        var json = jsonEncode({
          'id_sheet': image.idSheet,
          'img_preview': image.imgPreview,
          'img_raw': image.imgRaw
        });
        await _client.request('addImage', json);
      }
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addTexts(int idParent, int txtType) async {
    try {
      var json = jsonEncode({'id_sheet': idParent, 'txt_type': txtType});
      await _client.request('addText', json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteItem(String request, int id) async {
    try {
      var json = jsonEncode({'id': id});
      await _client.request(request, json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await _client.request(request, jsonEncode(json));
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateSheetOrder(List<Sheet> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await _client.request('updateSheetOrder', jsonEncode(jsonList));
  }

  @override
  Future<void> updateElemOrder(List<Element> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await _client.request('updateElementOrder', jsonEncode(jsonList));
  }
}
