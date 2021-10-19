import 'package:flutter/material.dart';
import '../../Model/cell.dart';
import '../../Model/Elements/element.dart' as elem;
import '../../Model/sheet.dart';

import '../ScreenElements/content_sheet.dart';
import '../ScreenElements/drawer_custom.dart';
import '../ScreenElements/floating_buttons_custom.dart';
import '../Interfaces/interaction_to_main_screen.dart';
import '../Interfaces/interaction_view.dart';
import '../ScreenElements/options.dart';


class MainScreen extends StatefulWidget{
  final InteractionView _interView;

  const MainScreen(this._interView, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainScreen> implements InteractionToMainScreen{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  InteractionView get interView => widget._interView;
  var _cells = <Cell>[];
  var _sheets = <Sheet>[];
  var _elements = <elem.Element>[];
  late Cell _currentCell;
  late Sheet _currentSheet;


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
        drawer: DrawerCustom(this, _currentCell),
        endDrawer: const Drawer(child: Options()),
        body: ContentSheet(key: UniqueKey(), elements: _elements, interView: interView, interMain: this),
        floatingActionButton: FloatingButtonsCustom(this, _currentCell, _sheets)
      )
    );
  }

  AppBar appBar(){
    return AppBar(
      title: Text(_currentCell.title),
      actions: [
        IconButton(
          onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
          icon: const Icon(Icons.miscellaneous_services)
        )
      ],
    );
  }

  int selectCellFromTitle(String title) {
    for(var i = 0; i < _cells.length; i++){
      if(_cells[i].title == title){
        return _cells[i].id;
      }
    }
    throw Exception('(MainScreen)_selectCellFromTitle: Cell not found from title ($title)');
  }

  /***************************/
  /* InteractionToMainScreen */
  /***************************/

  @override
  void getDefaultCell(){
    _currentCell = interView.getDefaultCell();
    _elements = interView.getDefaultElements();
    setState(() {});
  }

  @override
  bool isCellTitleValid(String title){
    for(int i = 0; i < _cells.length; i++){
      if(_cells[i].title == title){
        return false;
      }
    }
    return true;
  }

  @override
  bool isSheetTitleValid(String title){
    for(int i = 0; i < _sheets.length; i++){
      if(_sheets[i].title == title){
        return false;
      }
    }
    return true;
  }

  @override
  Future<void> selectCurrentCell(int index) async{
    _currentCell = _cells[index];
    await updateSheets();
    await setCurrentSheet(0);
  }

  @override
  List<Sheet> getSheets() => _sheets;

  @override
  Future<void> setCurrentSheet(int index) async{
    _currentSheet = _sheets[index];
    await updateElements();
  }

  @override
  Future<List<Cell>> updateCells([String matchWord = '']) async{
    try{
      return _cells = await interView.getCells(matchWord);
    }
    catch(e){
      print('updateCells failed\n$e');
      return _cells = [];
    }
  }

  @override
  Future<void> updateSheets() async{
    try{
      _sheets = await interView.getSheets(_currentCell.id);
      setState(() {});
    }
    catch(e){
      print('updateSheets failed\n$e');
    }
  }

  @override
  Future<void> updateElements() async{
    try{
      _elements = await interView.getElements(_currentSheet.id);
      setState(() {});
    }
    catch(e){
      print('updateElements failed\n$e');
    }
  }

  @override
  Future<void> updateSheetsOrder() async{
    //TODO: Implement drag and drop of sheets
    throw UnimplementedError();
  }

  @override
  Future<void> updateElementsOrder() async{
    for(var element in _elements){
      print(element.idOrder);
    }
  }

  @override
  Future<void> addCell(String title, String subtitle, String type) async{
    String msg = 'Cell added';
    try{
      await interView.addCell(title, subtitle, type);
      await updateCells();
    } catch(e){ msg = 'addCell Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> addSheet(String title, String subtitle) async{
    String msg = 'Sheet added';
    try{
      await interView.addSheet(_currentCell.id, title, subtitle, _sheets.length);
      await updateSheets();
    } catch(e){ msg = 'addSheet Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> addTexts(int type) async{
    String msg = 'Text added';
    try{
      await interView.addTexts(_currentSheet.id, type, _currentSheet.elements.length);
      await updateElements();
    } catch(e){ msg = 'addTexts Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> addImage() async{
    String msg = 'Image added';
    try{
      //interView.addImage(_currentSheet.id, data, _currentSheet.elements.length);
      //updateElements(idSheet);
    } catch(e){ msg = 'addImageFailed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> addCheckbox() async{
    String msg = 'Checkbox added';
    try{
      await interView.addCheckbox(_currentSheet.id, _currentSheet.elements.length);
      await updateElements();
    } catch(e){ msg = 'addCheckbox Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> deleteCell(int idCell) async{
    String msg = 'Cell deleted';
    try{
      await interView.deleteObject('Cell', idCell);
      await updateCells();
    } catch(e){ msg = 'deleteCell Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> deleteSheet(int idSheet) async{
    String msg = 'Sheet deleted';
    try{
      await interView.deleteObject('Sheet', idSheet);
      await updateSheets();
      if(_sheets.isEmpty || _currentSheet.id == idSheet){
        setCurrentSheet(0);
      }
    } catch(e){ msg = 'deleteSheet Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> deleteElement(String type, int index) async{
    String msg = 'Element deleted';
    try{
      await interView.deleteObject(type, index);
      await updateElements();
    } catch(e){ msg = 'deleteElement Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }
}