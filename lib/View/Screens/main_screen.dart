import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import '/Model/Elements/image.dart' as img_model;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '/Model/cell.dart';
import '/Model/Elements/element.dart' as elem;
import '/Model/sheet.dart';

import '../ScreenPart/element_screen.dart';
import 'cell_screen.dart';
import '../ScreenPart/floating_buttons.dart';
import '../Interfaces/interaction_main_screen.dart';
import '../Interfaces/interaction_view.dart';
import 'option_screen.dart';


class MainScreen extends StatefulWidget{
  final InteractionMain _interView;

  const MainScreen(this._interView, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> implements InteractionMainScreen{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  InteractionMain get interView => widget._interView;
  late Cell _currentCell;
  late Sheet _currentSheet;
  int _indexCurrentSheet = 0;


  @override
  initState(){
    super.initState();
    getDefaultCell();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBar(),
        drawer: const Drawer(child: OptionScreen()),
        body: ElementScreen(key: UniqueKey(), interView: interView, interMain: this),
        floatingActionButton: FloatingButtons(this, _currentCell)
      )
    );
  }

  AppBar appBar(){
    return AppBar(
      title: Text(_currentCell.title),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(this.context, MaterialPageRoute(builder: (context) => CellScreen(this, _currentCell))),
          icon: const Icon(Icons.sort)
        )
      ],
    );
  }

  /***************************/
  /* InteractionToMainScreen */
  /***************************/

  @override
  void getDefaultCell(){
    _currentCell = interView.getDefaultCell();
    _currentSheet = Sheet(-1, -1, 'my_netia', '', 0);
  }

  @override
  Future<Uint8List> selectRawImage(int idImage) async{
    try{ return await interView.getRawImage(idImage); }
    catch(e){ throw Exception(e); }
  }

  @override
  Future<void> selectCurrentCell(Cell cell) async{
    _currentCell = cell;
    setCurrentSheetIndex(0);
  }

  @override
  void setCurrentSheetIndex(int index) async{
    _indexCurrentSheet = index;
    await updateSheets();
    setState(() {});
  }

  @override
  Future<List<Cell>> updateCells([String matchWord = '']) async{
    try{ return await interView.getCells(matchWord); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<List<Sheet>> updateSheets() async{
    try{
      var sheets = await interView.getSheets(_currentCell.id);
      _currentSheet = sheets[_indexCurrentSheet];
      return sheets;
    }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<List<elem.Element>> updateElements() async{
    try{ return await interView.getElements(_currentSheet.id); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> updateSheetsOrder(List<Sheet> sheets) async{
    for(var i = 0; i < sheets.length; i++){
      if(sheets[i].idOrder != i){
        sheets[i].idOrder = i;
      }
    }
    await interView.updateSheetOrder(sheets);
  }

  @override
  Future<void> updateElementsOrder(List<elem.Element> elements) async{
    try{ await interView.updateElementOrder(elements); }
    catch(e) { throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> addCell(String title, String subtitle, String type) async{
    try{ await interView.addCell(title, subtitle, type); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> addSheet(String title, String subtitle) async{
    try{ await interView.addSheet(_currentCell.id, title, subtitle); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> addTexts(int type) async{
    try{
      await interView.addTexts(_currentSheet.id, type);
      setState(() {});
    } catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> addImage() async{
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, allowedExtensions: ['jpg, png, jpeg']);
      if(result != null){
        List<File> files = result.paths.map((path) => File(path!)).toList();
        for(var file in files) {
          var image = img.decodeImage(await file.readAsBytes())!;
          var imgResize = img.encodePng(img.copyResize(image, height: 500));
          var fileResize = File(basename(file.path))..writeAsBytes(imgResize);
          await interView.addImage(_currentSheet.id, await fileResize.readAsBytes(), await file.readAsBytes());
        }
      }
      setState(() {});
    } catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> addCheckbox() async{
    try{
      await interView.addCheckbox(_currentSheet.id);
      setState(() {});
    }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> deleteCell(int idCell) async{
    try{ await interView.deleteItem('Cell', idCell); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> deleteSheet(int idSheet) async{
    try{ await interView.deleteItem('Sheet', idSheet); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }

  @override
  Future<void> deleteElement(int index) async{
    try{ await interView.deleteItem('Element', index); }
    catch(e){ throw MainScreenException(interView: interView, context: this.context, error: e); }
  }
}

class MainScreenException implements Exception{
  InteractionMain interView;
  BuildContext context;

  MainScreenException({required this.interView, required this.context, required Object error}){
    interView.gotoLoginScreen(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion with server lost'))
    );
    print(error);
    //TODO: Send error to server
  }
}