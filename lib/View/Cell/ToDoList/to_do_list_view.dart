import 'package:flutter/material.dart';

import '../../../Model/Cells/sheet.dart';
import '../../../Model/Cells/cell.dart';
import '/View/Cell/ToDoList/to_do_list_element_view.dart';
import '/View/Interfaces/interaction_view.dart';

class ToDoListView extends StatelessWidget {
  final InteractionView interView;
  final Cell cell;
  final Sheet sheet;

  const ToDoListView(
      {Key? key,
      required this.interView,
      required this.cell,
      required this.sheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToDoListElemView(interView: interView, sheet: sheet);
  }
}
