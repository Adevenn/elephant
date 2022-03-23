import 'dart:convert';
import 'dart:typed_data';

import '/Exception/database_exception.dart';
import '/Exception/server_exception.dart';
import '/Model/Elements/checkbox.dart';
import '/Model/Elements/element.dart';
import '/Model/Elements/image.dart';
import '/Model/Elements/text.dart';
import '/Model/Elements/text_type.dart';
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
      print(result);
      return Uint8List.fromList(jsonDecode(result['img_raw']).cast<int>());
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<void> addCell(String title, String subtitle, String type) async {
    try {
      var json =
          jsonEncode({'title': title, 'subtitle': subtitle, 'type': type});
      await _client.request('addCell', json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> addSheet(int idCell, String title, String subtitle) async {
    try {
      var json = jsonEncode({'id_cell': idCell, 'title': title, 'subtitle':
      subtitle});
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
          'id_sheet': image.idParent,
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
      await _client.request('addTexts', json);
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
      await _client.request(request, json);
    } on ServerException catch (e) {
      throw ServerException('$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateOrder(String type, List<Object> list) async {
    try {
      var jsonList = <String>[];
      switch (type) {
        case 'Sheet':
          list = list as List<Sheet>;
          break;
        case 'Element':
          list = list as List<Element>;
          break;
        default:
          throw Exception('Type not implemented\nType : $type');
      }
      for (var i = 0; i < list.length; i++) {
        jsonList.add(jsonEncode(list[i]));
      }
      await _client.request('updateOrder', [type, jsonEncode(jsonList)]);
    } catch (e) {
      throw Exception(e);
    }
  }
}
