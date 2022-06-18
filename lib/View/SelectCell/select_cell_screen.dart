import 'package:flutter/material.dart';
import 'package:my_netia_client/Network/client.dart';
import '/Model/constants.dart';
import '../Interfaces/interaction_main.dart';
import '/View/loading_screen.dart';
import '/View/Cell/cell_view.dart';
import '/View/Options/option_screen.dart';
import 'add_cell_dialog.dart';
import 'edit_cell_dialog.dart';
import 'delete_cell_dialog.dart';
import '/Model/Cells/Book/book.dart';
import '/Model/Cells/Ranking/ranking.dart';
import '/Model/Cells/ToDoList/to_do_list.dart';
import '/Model/cell.dart';
import '../Interfaces/interaction_view.dart';

class SelectCellScreen extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;

  const SelectCellScreen(
      {required this.interMain, required this.interView, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectCellScreenState();
}

class _SelectCellScreenState extends State<SelectCellScreen> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;
  final _controllerResearch = TextEditingController();
  var researchWord = '';

  _SelectCellScreenState();

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
      case Ranking:
        return const Icon(Icons.format_list_numbered_rounded);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => interView.gotoLoginScreen(context),
            ),
            title: const Text('Cells')),
        endDrawer: Drawer(child: OptionScreen(interView: interView)),
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
                                        await interMain.updateItem(
                                            'updateCell', cell.toJson());
                                        setState(() {});
                                      }
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CellView(
                                                interMain: interMain,
                                                interView: interView,
                                                cell: cells[index])));
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
                                    await interMain.deleteItem(
                                        'deleteCell', cells[index].id);
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
                      ),
                    ],
                  ),
                );
              } else {
                return const LoadingScreen();
              }
            }));
  }
}
