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
  Future<void> trySignIn(String username, String password) async {
    Constants.username = username;
    _client = Client(username, password);
    try {
      await _client.request('sign_in', {});
    } on DbException {
      throw const DbException('Incorrect identifiers');
    } catch (e) {
      throw const ServerException('404 Not Found');
    }
  }

  @override
  Future<void> tryAddAccount(String username, String password) async{
    _client = Client(username, password);
    try {
      await _client.request('add_account', {});
    } on DbException {
      throw const DbException('Username already used');
    } catch (e) {
      throw const ServerException('404 Not Found');
    }
  }

  @override
  Future<List<Cell>> getCells([String matchWord = '']) async {
    var cells = <Cell>[];
    try {
      var result = jsonDecode(await _client.request('cells', {'match_word': matchWord}));
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
      var result = jsonDecode(await _client.request('sheets', {'id_cell': idCell}));
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
      var result = await _client.request('sheet', {'id_cell': idCell, 'sheet_index': sheetIndex});
      return Sheet.fromJson(jsonDecode(result));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Element>> getElements(int idSheet) async {
    var elements = <Element>[];
    try {
      var result = jsonDecode(await _client.request('elements', {'id_sheet': idSheet}));
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
      var result = jsonDecode(await _client.request('rawImage', {'id_img': idImage}));
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
      await _client.request(request, jsonValues);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception('Controller.addCell :\n$e\nrequest : $request\njson : '
          '$jsonValues');
    }
  }

  @override
  Future<void> addSheet(int idCell, String title, String subtitle) async {
    try {
      await _client.request('addSheet', {'id_cell': idCell, 'title': title, 'subtitle': subtitle});
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addCheckbox(int idSheet) async {
    try {
      await _client.request('addCheckbox', {'id_sheet': idSheet});
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
        await _client.request('addImage', {
          'id_sheet': image.idSheet,
          'img_preview': image.imgPreview,
          'img_raw': image.imgRaw
        });
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
      await _client.request('addText', {'id_sheet': idParent, 'txt_type': txtType});
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteItem(String request, int id) async {
    try {
      await _client.request(request, {'id': id});
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await _client.request(request, json);
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
    await _client.request('updateSheetOrder', {'sheet_order' : jsonList});
  }

  @override
  Future<void> updateElemOrder(List<Element> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await _client.request('updateElementOrder', {'elem_order' : jsonList});
  }
}
