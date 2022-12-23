import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/Cell/Book/book_element_view.dart';
import 'package:elephant_client/View/Cell/Page/page_screen.dart';
import 'package:flutter/material.dart';

typedef PageIndexCallBack = void Function(int sheetIndex);

class BookView extends StatelessWidget {
  final Cell cell;
  final int pageIndex;
  final PageIndexCallBack onPageIndexChange;

  const BookView(
      {Key? key,
      required this.cell,
      required this.pageIndex,
      required this.onPageIndexChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookElemView(page: cell.pages[pageIndex]),
      bottomSheet: Container(
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
                            index: pageIndex,
                            selectedPageId: cell.pages[pageIndex].id,
                          )));
              if (pageIndex != result) {
                //Call the function defined by the parent (parent setState)
                onPageIndexChange(result);
              }
            },
            child: const Icon(Icons.text_snippet),
          ),
        ),
      ),
    );
  }
}
