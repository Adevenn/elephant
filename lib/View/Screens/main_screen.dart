import 'package:flutter/material.dart';
import '/Model/cell.dart';
import '/Model/Elements/element.dart' as elem;
import '/Model/sheet.dart';

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
        drawer: const Drawer(child: Options()),
        body: ContentSheet(key: UniqueKey(), interView: interView, interMain: this),
        floatingActionButton: FloatingButtonsCustom(this, _currentCell)
      )
    );
  }

  AppBar appBar(){
    return AppBar(
      title: Text(_currentCell.title),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DrawerCustom(this, _currentCell))),
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
    try{
      return await interView.getCells(matchWord);
    }
    catch(e){
      print('updateCells failed:\n$e');
      return [];
    }
  }

  @override
  Future<List<Sheet>> updateSheets() async{
    try{
      var sheets = await interView.getSheets(_currentCell.id);
      _currentSheet = sheets[_indexCurrentSheet];
      return sheets;
    }
    catch(e){
      print('updateSheets failed:\n$e');
      return [];
    }
  }

  @override
  Future<List<elem.Element>> updateElements() async{
    try{
      return await interView.getElements(_currentSheet.id);
    }
    catch(e){
      print('updateElements failed:\n$e');
      return [];
    }
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
    await interView.updateElementOrder(elements);
  }

  @override
  Future<void> addCell(String title, String subtitle, String type) async{
    try{ await interView.addCell(title, subtitle, type); }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add cell failed'))
      );
    }
  }

  @override
  Future<void> addSheet(String title, String subtitle) async{
    try{ await interView.addSheet(_currentCell.id, title, subtitle); }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add sheet failed'))
      );
      print(e);
    }
  }

  @override
  Future<void> addTexts(int type) async{
    try{
      await interView.addTexts(_currentSheet.id, type);
      setState(() {});
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add text failed'))
      );
      print(e);
    }
  }

  @override
  Future<void> addImage() async{
    try{
      //interView.addImage(_currentSheet.id, data);
      //setState(() {});
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add image failed'))
      );
    }

  }

  @override
  Future<void> addCheckbox() async{
    try{
      await interView.addCheckbox(_currentSheet.id);
      setState(() {});
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add checkbox failed'))
      );
      print(e);
    }
  }

  @override
  Future<void> deleteCell(int idCell) async{
    try{ await interView.deleteItem('Cell', idCell); }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete cell failed'))
      );
      print(e);
    }
  }

  @override
  Future<void> deleteSheet(int idSheet) async{
    try{ await interView.deleteItem('Sheet', idSheet); }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete sheet failed'))
      );
      print(e);
    }
  }

  @override
  Future<void> deleteElement(int index) async{
    try{ await interView.deleteItem('Element', index); }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Delete element failed'))
      );
      print(e);
    }
  }
}