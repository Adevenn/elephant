import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/Model/Cells/to_do_list.dart';
import 'package:elephant_client/View/Cell/ElementManager/vertical_list.dart';
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
              body: VerticalList(page: page),
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