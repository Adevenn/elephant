import 'package:flutter/material.dart';
import '../Model/cell.dart';
import '../Model/Elements/element.dart' as elem;
import '../Model/sheet.dart';

import 'content_sheet.dart';
import 'drawer_custom.dart';
import 'floating_buttons_custom.dart';
import 'interaction_to_main_screen.dart';
import 'interaction_view.dart';
import 'options.dart';


class MainScreen extends StatefulWidget{
  final InteractionView _interView;

  const MainScreen(this._interView, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainState(_interView);
}

class _MainState extends State<MainScreen> implements InteractionToMainScreen{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final InteractionView interView;
  var _cells = <Cell>[];
  var _sheets = <Sheet>[];
  var _elements = <elem.Element>[];
  late Cell _currentCell;
  late Sheet _currentSheet;

  _MainState(this.interView);


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
        drawer: DrawerCustom(this, _cells, _currentCell),
        endDrawer: Drawer(child: Options(context)),
        body: ContentSheet(key: UniqueKey(), sheetContent: _elements, interView: interView),
        floatingActionButton: FloatingButtonsCustom(this, _currentCell, _sheets)//floatingActionBtn(),
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
  Future<void> setCurrentSheet(int index) async{
    _currentSheet = _sheets[index];
    await updateElements();
    setState(() {});
  }

  @override
  Future<void> updateCells([String matchWord = '']) async{
    try{
      _cells = await interView.getCells(matchWord);
      setState(() {});
    }
    catch(e){
      print('updateCells failed\n$e');
    }
  }

  @override
  Future<void> updateElements() async{
    try{
      _elements = await interView.getElements(_currentSheet.id);
    }
    catch(e){
      print('updateElements failed\n$e');
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
  Future<void> addCell(String title, String subtitle, String type) async{
    String msg = 'Cell added';
    try{
      //TODO: Add a default sheet that refer to this cell
      await interView.addCell(title, subtitle, type);
      await updateCells();
    } catch(e){ msg = 'Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> addSheet(String title, String subtitle) async{
    String msg = 'Sheet added';
    try{
      await interView.addSheet(_currentSheet.id, title, subtitle, _sheets.length);
      await updateSheets();
    } catch(e){ msg = 'Failed'; }
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
    } catch(e){ msg = 'Failed'; }
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
    } catch(e){ msg = 'Failed'; }
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
    } catch(e){ msg = 'Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> deleteCell(int index) async{
    String msg = 'Cell deleted';
    try{
      await interView.deleteObject('Cell', index);
      await updateCells();
    } catch(e){ msg = 'Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }

  @override
  Future<void> deleteSheet(int index) async{
    String msg = 'Sheet deleted';
    try{
      
      //TODO: If -> currentSheet.id == index => select the first Sheet
      //TODO: If -> last sheet is deleted => Create a default one
      await interView.deleteObject('Sheet', index);
      await updateSheets();
    } catch(e){ msg = 'Failed'; }
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
    } catch(e){ msg = 'Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }
}