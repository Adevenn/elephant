import 'dart:io';
import 'dart:typed_data';

import 'package:image_compression/image_compression.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '/Model/cell.dart';
import '/Model/Elements/element.dart' as elem;
import '/Model/sheet.dart';

import '../ScreenPart/element_screen.dart';
import 'cell_screen.dart';
import '../ScreenPart/floating_buttons.dart';
import '../Interfaces/interaction_to_main_screen.dart';
import '../Interfaces/interaction_to_controller.dart';
import 'option_screen.dart';


class MainScreen extends StatefulWidget{
  final InteractionToController _interController;

  const MainScreen(this._interController, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> implements InteractionToMainScreen{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  InteractionToController get interController => widget._interController;
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
        drawer: Drawer(child: OptionScreen(interController: interController)),
        body: ElementScreen(key: UniqueKey(), interController: interController, interMain: this),
        floatingActionButton: FloatingButtons(this, _currentCell)
      )
    );
  }

  AppBar appBar(){
    return AppBar(
      title: Text(_currentCell.title),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CellScreen(this, _currentCell))),
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
    _currentCell = interController.getDefaultCell();
    _currentSheet = Sheet(-1, -1, 'my_netia', '', 0);
  }

  @override
  Future<Uint8List> selectRawImage(int idImage) async{
    try{ return await interController.getRawImage(idImage); }
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
    try{ return await interController.getCells(matchWord); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<List<Sheet>> updateSheets() async{
    try{
      var sheets = await interController.getSheets(_currentCell.id);
      _currentSheet = sheets[_indexCurrentSheet];
      return sheets;
    }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<List<elem.Element>> updateElements() async{
    try{ return await interController.getElements(_currentSheet.id); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

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
  Future<void> updateElementsOrder(List<elem.Element> elements) async{
    try{ await interController.updateElementOrder(elements); }
    catch(e) { throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> addCell(String title, String subtitle, String type) async{
    try{ await interController.addCell(title, subtitle, type); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> addSheet(String title, String subtitle) async{
    try{ await interController.addSheet(_currentCell.id, title, subtitle); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> addTexts(int type) async{
    try{
      await interController.addTexts(_currentSheet.id, type);
      setState(() {});
    } catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> addImage() async{
    try{
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
      setState(() {});
    } catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> addCheckbox() async{
    try{
      await interController.addCheckbox(_currentSheet.id);
      setState(() {});
    }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> deleteCell(int idCell) async{
    try{ await interController.deleteItem('Cell', idCell); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> deleteSheet(int idSheet) async{
    try{ await interController.deleteItem('Sheet', idSheet); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }

  @override
  Future<void> deleteElement(int index) async{
    try{ await interController.deleteItem('Element', index); }
    catch(e){ throw MainScreenException(interView: interController, context: context, error: e); }
  }
}

class MainScreenException implements Exception{
  InteractionToController interView;
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