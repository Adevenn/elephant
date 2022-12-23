import 'package:elephant_client/Model/Cells/book.dart';
import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/Model/Cells/quiz.dart';
import 'package:elephant_client/Model/Cells/to_do_list.dart';
import 'package:elephant_client/Model/constants.dart';
import 'package:elephant_client/Network/client.dart';
import 'package:elephant_client/View/Cell/cell_view.dart';
import 'package:elephant_client/View/option_screen.dart';
import 'package:elephant_client/View/SelectCell/add_cell_dialog.dart';
import 'package:elephant_client/View/SelectCell/delete_cell_dialog.dart';
import 'package:elephant_client/View/SelectCell/edit_cell_dialog.dart';
import 'package:flutter/material.dart';

class SelectCellScreen extends StatefulWidget {
  const SelectCellScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectCellScreenState();
}

class _SelectCellScreenState extends State<SelectCellScreen> {
  final _controllerResearch = TextEditingController();
  var researchWord = '';

  void applyResearch([String newWord = '']) {
    researchWord = newWord;
    setState(() {});
  }

  Icon selectIconByCell(Type type) {
    switch (type) {
      case Book:
        return const Icon(Icons.menu_book_rounded);
      case ToDoList:
        return const Icon(Icons.playlist_add_check_rounded);
      case Quiz:
        return const Icon(Icons.question_mark_rounded);
      default:
        throw Exception('Unknown type');
    }
  }

  ///Return cells that match with the [researchWord]
  Future<List<Cell>> getCells() async {
    var result =
        await Client.requestResult('cells', {'match_word': researchWord});
    return List<Cell>.from(result.map((model) => Cell.fromJson(model)));
  }

  Future<void> addCell(Map args) async {
    await Client.request('addCell', args);
    setState(() {});
  }

  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await Client.request(request, json);
      setState(() {});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Cells')),
        endDrawer: const Drawer(child: OptionScreen()),
        body: FutureBuilder<List<Cell>>(
            future: getCells(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Cell>> snapshot) {
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
                            borderRadius: BorderRadius.circular(5)),
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
                                  }),
                            ),
                          ),
                        ),
                      ),
                      /* CELL ITEMS */
                      Expanded(
                        child: ListView(
                          children: [
                            for (var index = 0; index < cells.length; index++)
                              Dismissible(
                                key: UniqueKey(),
                                background:
                                    Container(color: const Color(0xBCC11717)),
                                child: ListTile(
                                  leading: selectIconByCell(
                                      cells[index].runtimeType),
                                  title: Text(cells[index].title),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(cells[index].subtitle),
                                      Icon(cells[index].isPublic == false
                                          ? Icons.lock_rounded
                                          : Icons.public_rounded)
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      var cell = await showDialog<Cell?>(
                                          context: context,
                                          builder: (context) {
                                            var cell = cells[index];
                                            return EditCellDialog(
                                                cells: cells,
                                                id: cell.id,
                                                title: cell.title,
                                                subtitle: cell.subtitle,
                                                type: cell.type,
                                                author: cell.author,
                                                visibility:
                                                    cell.isPublic == true
                                                        ? 'public'
                                                        : 'private');
                                          });
                                      if (cell != null) {
                                        await updateItem(
                                            'updateCell', cell.toJson());
                                        setState(() => {});
                                      }
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CellView(cell: cells[index])));
                                  },
                                ),
                                /* DELETE CELL*/
                                onDismissed: (direction) async {
                                  bool result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DeleteCellDialog(
                                              cellTitle: cells[index].title));
                                  if (result) {
                                    await Client.deleteItem(
                                        cells[index].id, 'cell');
                                    cells.removeAt(index);
                                  }
                                  setState(() {});
                                },
                              )
                          ],
                        ),
                      ),
                      /* ADD CELL DIALOG */
                      Column(
                        children: [
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.add_rounded),
                            title: const Text('Add cell'),
                            onTap: () async {
                              var cell = await showDialog<Cell?>(
                                context: context,
                                builder: (context) => AddCellDialog(
                                    cells: cells, author: Constants.username),
                              );
                              if (cell != null) {
                                addCell(cell.toJson());
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
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
                      child: Text('Awaiting 1 ...'),
                    )
                  ],
                ));
                //return const LoadingScreen();
              }
            }));
  }
}
