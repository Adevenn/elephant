import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/Cell/ToDoList/to_do_element_view.dart';
import 'package:flutter/material.dart';

class ToDoView extends StatelessWidget {
  final Cell cell;

  const ToDoView({Key? key, required this.cell}) : super(key: key);

  @override
  Widget build(BuildContext context) => ToDoElemView(page: cell.pages[0]);
}
