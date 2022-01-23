import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compression/image_compression.dart';
import '/Model/cell.dart';
import '/Model/sheet.dart';
import '/Model/Elements/element.dart' as elem;

import 'Cell/cell_screen.dart';
import 'Interfaces/interaction_to_controller.dart';
import 'Interfaces/interaction_to_view_controller.dart';
import 'Login/login_screen.dart';

class ControllerView implements InteractionToViewController{

  final InteractionToController interController;
  late Cell _currentCell;
  late Sheet _currentSheet;
  int _indexCurrentSheet = 0;

  ControllerView(this.interController);

  start(){
    runApp(MyApp(this));
  }

  @override
  Future<void> testConnection(String ip, int port, String database, String username, String password) async => await interController.testConnection(ip, port, database, username, password);

  @override
  Future<Uint8List> selectRawImage(int idImage) async{
    try{ return await interController.getRawImage(idImage); }
    catch(e){ throw Exception(e); }
  }

  @override
  Future<void> selectCurrentCell(Cell cell) async{
    _currentCell = cell;
    await setCurrentSheetIndex(0);
  }

  @override
  Future<void> setCurrentSheetIndex(int index) async{
    _indexCurrentSheet = index;
    await updateSheets();
  }

  @override
  Future<List<Cell>> updateCells([String matchWord = '']) async
    => await interController.getCells(matchWord);

  @override
  Future<List<Sheet>> updateSheets() async{
    var sheets = await interController.getSheets(_currentCell.id);
    _currentSheet = sheets[_indexCurrentSheet];
    return sheets;
  }

  @override
  Future<List<elem.Element>> updateElements() async
    => await interController.getElements(_currentSheet.id);

  @override
  Future<void> updateSheetsOrder(List<Sheet> sheets) async{
    for(var i = 0; i < sheets.length; i++){
      if(sheets[i].idOrder != i){
        sheets[i].idOrder = i;
      }
    }
    await interController.updateSheetOrder(sheets);
  }

  @override
  Future<void> updateElementsOrder(List<elem.Element> elements) async
    => await interController.updateElementOrder(elements);

  @override
  Future<void> updateItem(String type, Map<String, dynamic> json) async
    => await interController.updateItem(type, json);

  @override
  Future<void> addCell(String title, String subtitle, String type) async
    => await interController.addCell(title, subtitle, type);

  @override
  Future<void> addSheet(String title, String subtitle) async
    => await interController.addSheet(_currentCell.id, title, subtitle);

  @override
  Future<void> addTexts(int type) async
    => await interController.addTexts(_currentSheet.id, type);

  @override
  Future<void> addImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image, dialogTitle: 'my_netia image selection');
    if(result != null){
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for(var file in files) {
        var img = ImageFile(filePath: file.path, rawBytes: file.readAsBytesSync());
        print('name: ${img.fileName}\nwidth : ${img.width}\nheight : ${img.height}\nweight : ${img.sizeInBytes}');
        final output = compress(ImageFileConfiguration(input: img));
        print('name:${output.fileName}\nwidth : ${output.width}\nheight : ${output.height}\nbytes: ${output.sizeInBytes}');
        await interController.addImage(_currentSheet.id, output.rawBytes, await file.readAsBytes());
      }
    }
  }

  @override
  Future<void> addCheckbox() async
    => await interController.addCheckbox(_currentSheet.id);

  @override
  Future<void> deleteCell(int idCell) async
    => await interController.deleteItem('Cell', idCell);

  @override
  Future<void> deleteSheet(int idSheet) async
    => await interController.deleteItem('Sheet', idSheet);

  @override
  Future<void> deleteElement(int index) async
    => await interController.deleteItem('Element', index);

  @override
  void gotoLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(this),
      ),
      (route) => false,
    );
  }

  @override
  void gotoCellScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CellScreen(this),
      ),
    );
  }
}

class MyApp extends StatelessWidget{
  final InteractionToViewController interactionMain;

  const MyApp(this.interactionMain, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNetia',
      /*theme: ThemeData.(
        primarySwatch: Colors.blue,
      ),*/
      theme: ThemeData.dark(),
      home: LoginScreen(interactionMain),
    );
  }
}

class MainScreenException implements Exception{
  InteractionToViewController interView;
  BuildContext context;

  MainScreenException({required this.interView, required this.context, required Object error}){
    interView.gotoLoginScreen(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion with server lost'))
    );
    print(error);
    //TODO: Send error by mail
  }
}