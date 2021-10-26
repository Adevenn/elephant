import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Model/CellComponents/book.dart';
import '/Model/CellComponents/ranking.dart';
import '/Model/CellComponents/to_do_list.dart';
import '/Model/cell.dart';
import '../Interfaces/interaction_to_main_screen.dart';

class CellScreen extends StatefulWidget{

  final InteractionToMainScreen _interMain;
  final Cell _currentCell;

  const CellScreen(this._interMain, this._currentCell, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CellScreenState();
}

class _CellScreenState extends State<CellScreen>{

  InteractionToMainScreen get interMain => widget._interMain;
  Cell get currentCell => widget._currentCell;
  final _controllerResearch = TextEditingController();
  String researchWord = '';

  _CellScreenState();


  void applyResearch([String newWord = '']){
    researchWord = newWord;
    setState(() {});
  }

  bool isCellTitleValid(List<Cell> cells, String title){
    for(int i = 0; i < cells.length; i++){
      if(cells[i].title == title){
        return false;
      }
    }
    return true;
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
                            onPressed: () => applyResearch(),
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
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Remove cell'),
                                  content: Text('Do you really want to remove ${cells[index].title} ?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                )
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
                              builder: (context){
                                var _formKey = GlobalKey<FormState>();
                                var title = TextEditingController();
                                var subtitle = TextEditingController();
                                String type = "Book";
                                return AlertDialog(
                                  title: const Text('Add cell'),
                                  scrollable: true,
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        DropdownButton(
                                          value: type,
                                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                          items: <String>['Book', 'ToDoList', 'Ranking'].map<DropdownMenuItem<String>>((String value){
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value)
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) => setState(() => type = newValue!),
                                        ),
                                        TextFormField(
                                          controller: title,
                                          decoration: const InputDecoration(hintText: 'Title'),
                                          validator: (value){
                                            if(value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            } else if (!isCellTitleValid(cells, value)) {
                                              return 'Title already exist';
                                            }
                                            return null;
                                          },
                                        ),
                                        TextFormField(
                                          controller: subtitle,
                                          decoration: const InputDecoration(hintText: 'Subtitle'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        if(_formKey.currentState!.validate()){
                                          List<String> list = [title.text, subtitle.text, type];
                                          Navigator.pop(context, list);
                                        }
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                );
                              }
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
          else if(snapshot.hasError){
            throw Exception('');
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