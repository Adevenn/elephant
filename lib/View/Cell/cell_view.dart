import 'package:flutter/material.dart';
import '/View/Options/option_screen.dart';
import '/View/Cell/Book/book_view.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/Model/cell.dart';
import 'Rank/rank_view.dart';
import 'ToDoList/to_do_list_view.dart';

class CellView extends StatelessWidget {
  final Cell cell;
  final InteractionToViewController interView;

  const CellView({Key? key, required this.cell, required this.interView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      endDrawer: Drawer(child: OptionScreen(interView: interView)),
      body: (() {
        switch (cell.type) {
          case 'Book':
            return BookView(interView: interView, cell: cell);
          case 'ToDoList':
            return ToDoListView(interView: interView, cell: cell);
          case 'Rank':
            return RankView(interView: interView);
        }
      }()),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Expanded(child: Text(cell.title), flex: 3),
          Expanded(child: Text(cell.subtitle)),
        ],
      ),
    );
  }
}
