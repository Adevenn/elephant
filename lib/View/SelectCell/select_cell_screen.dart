import 'package:elephant_client/Model/Cells/book.dart';
import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/Model/Cells/cell_list.dart';
import 'package:elephant_client/Model/Cells/quiz.dart';
import 'package:elephant_client/Model/Cells/to_do_list.dart';
import 'package:elephant_client/Model/constants.dart';
import 'package:elephant_client/View/Cell/cell_view.dart';
import 'package:elephant_client/View/loading_screen.dart';
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
  CellList cellList = CellList();
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
        body: FutureBuilder<void>(
            future: cellList.getCells(researchWord),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var cells = cellList.cells;
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
                        child: cellList.cells.isNotEmpty
                            ? ListView.builder(
                                itemCount: cellList.cells.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Cell cell = cellList.cells[index];
                                  return Dismissible(
                                    key: UniqueKey(),
                                    background: Container(
                                        color: const Color(0xBCC11717)),
                                    child: ListTile(
                                      leading:
                                          selectIconByCell(cell.runtimeType),
                                      title: Text(cell.title),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(cell.subtitle),
                                          Icon(cell.isPublic == false
                                              ? Icons.lock_rounded
                                              : Icons.public_rounded)
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () async {
                                          var cellEdited =
                                              await showDialog<Cell?>(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditCellDialog(
                                                        cells: cells,
                                                        id: cell.id,
                                                        title: cell.title,
                                                        subtitle: cell.subtitle,
                                                        type: cell.type,
                                                        author: cell.author,
                                                        visibility:
                                                            cell.isPublic ==
                                                                    true
                                                                ? 'public'
                                                                : 'private');
                                                  });
                                          if (cellEdited != null) {
                                            await cellList
                                                .updateCell(cellEdited);
                                            setState(() => {});
                                          }
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CellView(
                                                    cell: cell.fastFactory())));
                                      },
                                    ),
                                    /* DELETE CELL*/
                                    onDismissed: (direction) async {
                                      bool result = await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              DeleteCellDialog(
                                                  cellTitle: cell.title));
                                      if (result) {
                                        await cellList.deleteCell(index);
                                      }
                                      setState(() {});
                                    },
                                  );
                                },
                              )
                            : const Center(child: Text('No items')),
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
                                    cells: cellList,
                                    author: Constants.username),
                              );
                              if (cell != null) {
                                await cellList.addCell(cell);
                                setState(() {});
                              }
                            },
                          )
                        ],
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
