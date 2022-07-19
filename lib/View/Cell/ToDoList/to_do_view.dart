import 'package:flutter/material.dart';

import '/Model/Cells/sheet.dart';
import '/Model/Cells/cell.dart';
import '/View/Cell/ToDoList/to_do_element_view.dart';
import '/View/Interfaces/interaction_view.dart';

class ToDoView extends StatelessWidget {
  final InteractionView interView;
  final Cell cell;
  final Sheet sheet;

  const ToDoView(
      {Key? key,
      required this.interView,
      required this.cell,
      required this.sheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToDoElemView(interView: interView, sheet: sheet);
  }
}
