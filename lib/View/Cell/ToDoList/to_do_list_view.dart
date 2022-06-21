import 'package:flutter/material.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_main.dart';
import '/Model/cell.dart';
import '/View/Cell/ToDoList/to_do_list_element_view.dart';
import '/View/Interfaces/interaction_view.dart';

class ToDoListView extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
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
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;

  Cell get cell => widget.cell;
  Sheet? sheet;

  @override
  Widget build(BuildContext context) {
    return ToDoListElemView(
        interMain: interMain, interView: interView, sheet: sheet!);
  }
}
