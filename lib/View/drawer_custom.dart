import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/CellComponents/book.dart';
import '../Model/CellComponents/ranking.dart';
import '../Model/CellComponents/to_do_list.dart';
import '../Model/cell.dart';
import 'interaction_to_main_screen.dart';

class DrawerCustom extends StatefulWidget{

  final InteractionToMainScreen _interMain;
  final List<Cell> _cells;
  final Cell _currentCell;

  const DrawerCustom(this._interMain, this._cells, this._currentCell, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom>{
  InteractionToMainScreen get interMain => widget._interMain;
  final _controllerResearch = TextEditingController();

  _DrawerCustomState();


  Future<void> applyResearch([String research = '']) async{
    if(research == '') {
      _controllerResearch.clear();
    }
    await interMain.updateCells(research);
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
  void initState() {
    super.initState();
    applyResearch();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
                itemCount: widget._cells.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    leading: selectIconByCell(widget._cells[index].runtimeType),
                    title: Text(widget._cells[index].title),
                    subtitle: Text(widget._cells[index].subtitle),
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
                              content: Text('Do you really want to remove ${widget._cells[index].title} ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async{
                                    if(widget._currentCell.title == widget._cells[index].title){
                                      interMain.getDefaultCell();
                                    }
                                    await interMain.deleteCell(widget._cells[index].id);
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
                    onTap: () async{
                      Navigator.pop(context);
                      await interMain.selectCurrentCell(index);
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
                                      } else if (!interMain.isCellTitleValid(value)) {
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
      ),
    );
  }
}