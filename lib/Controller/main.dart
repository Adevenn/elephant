import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../Exception/database_exception.dart';
import '../Exception/database_timeout_exception.dart';
import '../Exception/server_exception.dart';
import '../Model/Elements/checkbox.dart';
import '../Model/Elements/element.dart' as elem;
import '../Model/sheet.dart';
import '../Network/client.dart';
import '../Model/cell.dart';
import '../Model/CellComponents/info.dart';
import '../Model/Elements/texts.dart';
import '../Model/Elements/text_type.dart';
import '../View/interaction_view.dart';
import '../View/login_screen.dart';
import '../View/main_screen.dart';

void main() {
  Controller controller = Controller();
  controller.start();
}

class Controller implements InteractionView{
  late Client _client;
  late final Info _defaultCell;
  final _defaultCellElements = <elem.Element>[];

  start() async{
    createDefaultCell();
    runApp(MyApp(this));
    //TODO: Disable some actions when _readOnly = true (inside Options)
    //TODO: Themes
  }

  void createDefaultCell() {
    _defaultCell = Info(title: 'MyNetia');
    _defaultCellElements.add(Texts(text: '<- Select a cell on the left', idParent: -1, txtType: TextType.readonly, id: -1, idOrder: 0));
  }

  /// VIEW INTERACTION ///

  @override
  Cell getDefaultCell() => _defaultCell;

  @override
  List<elem.Element> getDefaultElements() => _defaultCellElements;

  @override
  Future<void> testConnection(String ip, int port, String database, String username, String password) async {
    print('/* testConnection */');
    _client = Client(ip, port, database, username, password);
    try{ await _client.testConnection(); }
    on ServerException catch (e) { throw ServerException(e.toString()); }
    on DatabaseException catch(e) { throw DatabaseException(e.toString()); }
    on DatabaseTimeoutException catch(e) { throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
    finally{
      print('/* testConnection done */');
    }
  }

  @override
  Future<List<Cell>> getCells([String research = '']) async {
    print('/* getCells */');
    var cells = <Cell>[];
    try{
      var jsonList = jsonDecode(await _client.cells(research));
      jsonList.forEach((json) {
        var cell = Cell.fromJson(jsonDecode(json));
        cells.add(cell);
      });
      print('/* getCells done */');
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    catch(e) { throw Exception(e); }
    return cells;
  }

  @override
  Future<List<Sheet>> getSheets(int idCell) async{
    print('/* getSheets */');
    var sheets = <Sheet>[];
    try{
      var jsonList = jsonDecode(await _client.sheetsFromIdCell(idCell));
      jsonList.forEach((json) {
        var sheet = Sheet.fromJson(jsonDecode(json));
        sheets.add(sheet);
      });
      print('/* getSheets done */');
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    catch(e) { throw Exception(e); }
    return sheets;
  }

  @override
  Future<List<elem.Element>> getElements(int idSheet) async{
    print('/* getElements */');
    var elements = <elem.Element>[];
    try{
      var jsonList = jsonDecode(await _client.elementsFromIdSheet(idSheet));
      jsonList.forEach((json) {
        var element = elem.Element.fromJson(jsonDecode(json));
        elements.add(element);
      });
      print('/* getElements done */');
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    catch(e) { throw Exception(e); }
    return elements;
  }

  @override
  Future<void> addCell(String title, String subtitle, String type) async{
    try{
      var cell = Cell.factory(id: -1, title: title, subtitle: subtitle, type: type);
      await _client.addCell(jsonEncode(cell.toJson()));
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  Future<void> addSheet(int idCell, String title, String subtitle, int idOrder) async{
    try{
      var json = jsonEncode(Sheet(-1, idCell, title, subtitle, idOrder).toJson());
      await _client.addObject('Sheet', jsonEncode(json));
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  Future<void> addCheckbox(int idParent, int idOrder) async{
    try{
      var json = CheckBox(id: -1, idParent: idParent, text: '', idOrder: idOrder).toJson();
      await _client.addObject('CheckBox', jsonEncode(json));
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  Future<void> addImage(int idParent, Uint8List data, int idOrder) async{
    try{
      //var json = Images().toJson();
      // TODO: implement addImage
      throw UnimplementedError();
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  Future<void> addTexts(int idParent, int txtType, int idOrder) async{
    try{
      var json = Texts(text:'', idParent: idParent, txtType: TextType.values[txtType], id: -1, idOrder: idOrder).toJson();
      await _client.addObject('Texts', jsonEncode(json));
    }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  Future<void> deleteObject(String type, int index) async{
    try{ await _client.deleteObject(type, index); }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  Future<void> updateObject(String type, Map<String, dynamic> jsonValues) async{
    try{ await _client.updateObject(type, jsonEncode(jsonValues)); }
    on ServerException catch(e){ throw ServerException(e.toString()); }
    on DatabaseTimeoutException catch(e){ throw DatabaseTimeoutException(e.toString()); }
    catch(e) { throw Exception(e); }
  }

  @override
  void gotoLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => LoginScreen(this),
      ),
    );
  }

  @override
  void gotoMainScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MainScreen(this),
      ),
    );
  }
}

class MyApp extends StatelessWidget{
  final InteractionView interactionView;

   const MyApp(this.interactionView, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNetia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(interactionView),
    );
  }
}
