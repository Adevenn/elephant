import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/Cell/Book/book_view.dart';
import 'package:elephant_client/View/Cell/Quiz/quiz_view.dart';
import 'package:elephant_client/View/Cell/ToDoList/to_do_view.dart';
import 'package:elephant_client/View/option_screen.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class CellView extends StatefulWidget {
  final Cell cell;

  const CellView({Key? key, required this.cell}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateCellView();
}

class _StateCellView extends State<CellView> {
  Cell get cell => widget.cell;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: cell.getPages(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const LoadingScreen();
            case ConnectionState.active:
            case ConnectionState.done:
              return Scaffold(
                appBar: appBar(context),
                endDrawer: const Drawer(child: OptionScreen()),
                body: (() {
                  switch (cell.type) {
                    case 'Book':
                      return BookView(
                        cell: cell,
                        pageIndex: pageIndex,
                        onPageIndexChange: (int newPageIndex) {
                          setState(() => pageIndex = newPageIndex);
                        },
                      );
                    case 'ToDoList':
                      return ToDoView(cell: cell);
                    case 'Quiz':
                      return QuizView(cell: cell);
                  }
                }()),
              );
          }
        });
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
          //TODO: Add isPublic icon
          Expanded(child: Text(cell.subtitle)),
        ],
      ),
    );
  }
}
