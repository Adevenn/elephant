import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/Model/Cells/to_do_list.dart';
import 'package:elephant_client/View/Cell/delete_element_dialog.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class ToDoView extends StatefulWidget {
  final ToDoList todolist;

  const ToDoView({Key? key, required this.todolist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateToDoView();
}

class _StateToDoView extends State<ToDoView> {
  late PageCustom page = widget.todolist.pages[0];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: page.getElements(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              body: Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                      flex: 5,
                      child: page.elements.isNotEmpty
                          ? ReorderableListView(
                              onReorder: (int oldIndex, int newIndex) async {
                                page.reorderElements(oldIndex, newIndex);
                                setState(() {});
                              },
                              children: [
                                for (var i = 0; i < page.elements.length; i++)
                                  Dismissible(
                                    key: UniqueKey(),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: page.elements[i].toWidget()),
                                    onDismissed: (direction) async {
                                      bool result = await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              DeleteElementDialog(elementType: page.elements[i].runtimeType.toString()));
                                      if (result) {
                                        await page.deleteElement(i);
                                      }
                                      setState(() {});
                                    },
                                    background: Container(color: const Color(0xBCC11717)),
                                  )
                              ],
                            )
                          : const Center(child: Text('No items'))),
                  Expanded(child: Container()),
                ],
              ),
              floatingActionButton: FloatingButtons(
                page: page,
                elementsType: const ['checkbox'],
                onElementAdded: () {
                  setState(() {});
                },
              ));
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
