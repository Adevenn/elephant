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
          onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
          icon: const Icon(Icons.miscellaneous_services)
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
      return _sheets = await interView.getSheets(_currentCell.id);
    }
    catch(e){
      print('updateSheets failed:\n$e');
      return _sheets = [];
    }
  }

  @override
  Future<List<elem.Element>> updateElements() async{
    try{
      return _elements = await interView.getElements(_currentSheet.id);
    }
    catch(e){
      print('updateElements failed:\n$e');
      return _elements = [];
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
      setState(() {});
    } catch(e){ msg = 'addCell failed'; }
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
      setState(() {});
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
      setState(() {});
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
      //setState(() {});
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
      setState(() {});
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
      setState(() {});
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
      setState(() {});
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
      setState(() {});
    } catch(e){ msg = 'deleteElement Failed'; }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }
}