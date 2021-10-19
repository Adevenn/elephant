import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/../Model/CellComponents/book.dart';
import '/../Model/CellComponents/ranking.dart';
import '/../Model/CellComponents/to_do_list.dart';
import '/../Model/cell.dart';
import '../Interfaces/interaction_to_main_screen.dart';

class DrawerCustom extends StatefulWidget{

  final InteractionToMainScreen _interMain;
  final Cell _currentCell;

  const DrawerCustom(this._interMain, this._currentCell, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom>{

  InteractionToMainScreen get interMain => widget._interMain;
  Cell get currentCell => widget._currentCell;
  final _controllerResearch = TextEditingController();

  _DrawerCustomState();


  Future<void> applyResearch([String research = '']) async{
    if(research == '') {
      _controllerResearch.clear();
    }
    await interMain.updateCells(research);
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
    return Drawer(
      child: FutureBuilder<List<Cell>>(
        future: interMain.updateCells(),
        builder: (BuildContext context, AsyncSnapshot<List<Cell>> snapshot) {
          if (snapshot.hasData) {
            var cells = snapshot.data!;
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  /* RESEARCH */
                  Column(
                    children: [
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
                    ],
                  ),
                  /* CELL ITEMS */
                  Expanded(
                    child: ListView.builder(
                      itemCount: cells.length,
                      itemBuilder: (BuildContext context, int index){
                        return ListTile(
                          leading: selectIconByCell(cells[index].runtimeType),
                          title: Text(cells[index].title),
                          subtitle: Text(cells[index].subtitle),
                          trailing: Row(
                            /* DELETE CELL */
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.delete_forever_rounded),
                                  onPressed: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Remove cell'),
                                      content: Text('Do you really want to remove ${cells[index].title} ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async{
                                            if(currentCell.id == cells[index].id){
                                              interMain.getDefaultCell();
                                            }
                                            await interMain.deleteCell(cells[index].id);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  )
                              )
                            ],
                          ),
                          onTap: (){
                            Navigator.pop(context);
                            interMain.selectCurrentCell(cells[index]);
                          },
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.add_rounded),
                          title: const Text('Add cell'),
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                var _formKey = GlobalKey<FormState>();
                                var _title = TextEditingController();
                                var _subtitle = TextEditingController();
                                String _type = "Book";
                                /* ADD CELL DIALOG */
                                return AlertDialog(
                                  title: const Text('Add cell'),
                                  scrollable: true,
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        DropdownButton(
                                          value: _type,
                                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                          items: <String>['Book', 'ToDoList', 'Ranking'].map<DropdownMenuItem<String>>((String value){
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) => setState(() => _type = newValue!),
                                        ),
                                        TextFormField(
                                          controller: _title,
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
                                          controller: _subtitle,
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
                                      onPressed: () async {
                                        if(_formKey.currentState!.validate()){
                                          await interMain.addCell(_title.text, _subtitle.text, _type);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Add'),
                                    ),
                                  ],
                                );
                              }
                            );
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