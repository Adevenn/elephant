import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/View/ScreenPart/add_cell_dialog.dart';
import '/View/ScreenPart/delete_cell_dialog.dart';
import '/Model/CellComponents/book.dart';
import '/Model/CellComponents/ranking.dart';
import '/Model/CellComponents/to_do_list.dart';
import '/Model/cell.dart';
import '../Interfaces/interaction_main_screen.dart';

class CellScreen extends StatefulWidget{

  final InteractionMainScreen _interMain;
  final Cell _currentCell;

  const CellScreen(this._interMain, this._currentCell, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CellScreenState();
}

class _CellScreenState extends State<CellScreen>{

  InteractionMainScreen get interMain => widget._interMain;
  Cell get currentCell => widget._currentCell;
  final _controllerResearch = TextEditingController();
  var researchWord = '';

  _CellScreenState();


  void applyResearch([String newWord = '']){
    researchWord = newWord;
    setState(() {});
  }

  Icon selectIconByCell(Type type){
    switch(type){
      case Book:
        return const Icon(Icons.menu_book_rounded);
      case ToDoList:
        return const Icon(Icons.playlist_add_check_rounded);
      case Ranking:
        return const Icon(Icons.format_list_numbered_rounded);
      default:
        throw Exception('Unknown type');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cells')
      ),
      body: FutureBuilder<List<Cell>>(
        future: interMain.updateCells(researchWord),
        builder: (BuildContext context, AsyncSnapshot<List<Cell>> snapshot) {
          if (snapshot.hasData) {
            var cells = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  /* RESEARCH */
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Center(
                      child: TextField(
                        onSubmitted: (value) => applyResearch(value),
                        controller: _controllerResearch,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _controllerResearch.text = '';
                              applyResearch();
                            }
                          ),
                        ),
                      ),
                    ),
                  ),
                  /* CELL ITEMS */
                  Expanded(
                    child: ListView(
                      children: [
                        for(var index = 0; index < cells.length; index++)
                          Dismissible(
                            key: UniqueKey(),
                            background: Container(color: const Color(0xBCC11717)),
                            child: ListTile(
                              leading: selectIconByCell(cells[index].runtimeType),
                              title: Text(cells[index].title),
                              subtitle: Text(cells[index].subtitle),
                              onTap: (){
                                Navigator.pop(context);
                                interMain.selectCurrentCell(cells[index]);
                              },
                            ),
                            /* DELETE CELL*/
                            onDismissed: (direction) async{
                              bool result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context)
                                  => DeleteCellDialog(cellTitle: cells[index].title)
                              );
                              if(result){
                                if(currentCell.id == cells[index].id){
                                  interMain.getDefaultCell();
                                }
                                await interMain.deleteCell(cells[index].id);
                              }
                              setState(() {});
                            },
                          )
                      ],
                    ),
                  ),
                  /* ADD CELL DIALOG */
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.add_rounded),
                          title: const Text('Add cell'),
                          onTap: () async{
                            var list = await showDialog<List<String>?>(
                              context: context,
                              builder: (context) => AddCellDialog(cells: cells),
                            );
                            if(list != null){
                              await interMain.addCell(list[0], list[1], list[2]);
                              setState(() {});
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting ...'),
                  )
                ],
              ),
            );
          }
        }
      )
    );
  }
}