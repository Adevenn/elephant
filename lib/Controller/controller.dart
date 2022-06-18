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
  /// VIEW INTERACTION ///

  @override
  Future<void> trySignIn(String username, String password) async {
    Constants.username = username;
    Constants.password = password;
    try {
      await Client.request('sign_in', {});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> tryAddAccount(String username, String password) async {
    Constants.username = username;
    Constants.password = password;
    try {
      await Client.request('add_account', {});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Cell>> getCells([String matchWord = '']) async {
    var cells = <Cell>[];
    try {
      var result =
          await Client.requestResult('cells', {'match_word': matchWord});
      cells = List<Cell>.from(result.map((model) => Cell.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return cells;
  }

  @override
  Future<List<Sheet>> getSheets(int idCell) async {
    var sheets = <Sheet>[];
    try {
      var result = await Client.requestResult('sheets', {'id_cell': idCell});
      sheets = List<Sheet>.from(result.map((model) => Sheet.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return sheets;
  }

  @override
  Future<Sheet> getSheet(int idCell, int sheetIndex) async {
    try {
      var result = await Client.requestResult(
          'sheet', {'id_cell': idCell, 'sheet_index': sheetIndex});
      return Sheet.fromJson(result);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<Element>> getElements(int idSheet) async {
    var elements = <Element>[];
    try {
      var result =
          await Client.requestResult('elements', {'id_sheet': idSheet});
      elements =
          List<Element>.from(result.map((model) => Element.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return elements;
  }

  @override
  Future<Uint8List> getRawImage(int idImage) async {
    try {
      var result = await Client.requestResult('rawImage', {'id_img': idImage});
      var imgRaw = jsonDecode(result);
      return Uint8List.fromList(imgRaw['img_raw'].cast<int>());
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addCell(String request, Map<String, dynamic> jsonValues) async {
    try {
      await Client.request(request, jsonValues);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addSheet(int idCell, String title, String subtitle) async {
    try {
      await Client.request('addSheet',
          {'id_cell': idCell, 'title': title, 'subtitle': subtitle});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addCheckbox(int idSheet) async {
    try {
      await Client.request('addCheckbox', {'id_sheet': idSheet});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addImage(List<Image> images) async {
    try {
      for (var image in images) {
        await Client.request('addImage', {
          'id_sheet': image.idSheet,
          'img_preview': image.imgPreview,
          'img_raw': image.imgRaw
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addTexts(int idParent, int txtType) async {
    try {
      await Client.request(
          'addText', {'id_sheet': idParent, 'txt_type': txtType});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> deleteItem(String request, int id) async {
    try {
      await Client.request(request, {'id': id});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await Client.request(request, json);
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
    await Client.request('updateSheetOrder', {'sheet_order': jsonList});
  }

  @override
  Future<void> updateElemOrder(List<Element> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await Client.request('updateElementOrder', {'elem_order': jsonList});
  }
}
