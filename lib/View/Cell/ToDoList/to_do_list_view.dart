import 'package:flutter/material.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_to_controller.dart';
import '/View/loading_screen.dart';
import '/Model/cell.dart';
import '/View/Cell/ToDoList/to_do_list_element_view.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';

class ToDoListView extends StatefulWidget {
  final InteractionToController interMain;
  final InteractionToViewController interView;
  final Cell cell;

  const ToDoListView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.cell})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateToDoListView();
}

class _StateToDoListView extends State<ToDoListView> {
  InteractionToController get interMain => widget.interMain;

  InteractionToViewController get interView => widget.interView;

  Cell get cell => widget.cell;
  Sheet? sheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: interMain.getSheet(cell.id, 0),
        builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
          if (snapshot.hasData && sheet != snapshot.data) {
            sheet = snapshot.data;
            return ToDoListElemView(interMain: interMain, interView: interView,sheet: sheet!);
          } else {
            return const LoadingScreen();
          }
        });
  }
}
