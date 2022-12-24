import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/Cell/book_view.dart';
import 'package:elephant_client/View/Cell/Page/page_screen.dart';
import 'package:elephant_client/View/Cell/quiz_view.dart';
import 'package:elephant_client/View/Cell/to_do_view.dart';
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
  final PageController controller = PageController();
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      endDrawer: const Drawer(child: OptionScreen()),
      body: FutureBuilder(
          future: cell.getPages(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (cell.multiPage) {
                return PageView.builder(
                  controller: controller,
                  itemCount: cell.pages.length,
                  itemBuilder: (context, index) {
                    pageIndex = index;
                    return _cellViewFactory();
                  },
                );
              }
              return _cellViewFactory();
            } else {
              return const LoadingScreen();
            }
          }),
      bottomSheet: (() {
        if (cell.multiPage) {
          return Container(
            margin: const EdgeInsets.all(15),
            child: Tooltip(
              message: 'Pages',
              child: FloatingActionButton(
                heroTag: 'pagesBtn',
                onPressed: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageScreen(
                                cell: cell,
                                selectedPageIndex: pageIndex,
                              )));
                  if (pageIndex != result) {
                    pageIndex = result;
                  }
                  setState(() {});
                },
                child: const Icon(Icons.text_snippet),
              ),
            ),
          );
        }
      }()),
    );
  }

  Widget _cellViewFactory() {
    switch (cell.type) {
      case 'Book':
        return BookView(cell: cell, pageIndex: pageIndex);
      case 'ToDoList':
        return ToDoView(cell: cell);
      case 'Quiz':
        return QuizView(cell: cell);
      default:
        throw Exception();
    }
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Expanded(child: Text(cell.title), flex: 9),
          Expanded(child: Text(cell.subtitle)),
          Expanded(
              child: Icon(cell.isPublic == false
                  ? Icons.lock_rounded
                  : Icons.public_rounded))
        ],
      ),
    );
  }
}
