import 'package:elephant_client/Model/Cells/book.dart';
import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/View/Cell/delete_element_dialog.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class BookView extends StatefulWidget {
  final Book book;
  final int pageIndex;

  const BookView({Key? key, required this.book, required this.pageIndex}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookView();
}

class _StateBookView extends State<BookView> {
  late PageCustom page = widget.book.pages[widget.pageIndex];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: page.getElements(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  page.title,
                                  style: const TextStyle(fontSize: 30, fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  page.subtitle,
                                  style: const TextStyle(fontSize: 25, fontStyle: FontStyle.italic),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Expanded(
                                flex: 5,
                                child: page.elements.isNotEmpty
                                    ? ReorderableListView(
                                        onReorder: (int oldIndex, int newIndex) async {
                                          page.reorderElements(oldIndex, newIndex);
                                          setState(() {});
                                        },
                                        children: [
                                          for (var i = 0; i < page.elements.length; i++)
                                            Dismissible(
                                              key: UniqueKey(),
                                              child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                  child: page.elements[i].toWidget()),
                                              onDismissed: (direction) async {
                                                bool result = await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext context) => DeleteElementDialog(
                                                        elementType: page.elements[i].runtimeType.toString()));
                                                if (result) {
                                                  await page.deleteElement(i);
                                                }
                                                setState(() {});
                                              },
                                              background: Container(color: const Color(0xBCC11717)),
                                            )
                                        ],
                                      )
                                    : const Center(child: Text('No items'))),
                            Expanded(child: Container()),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                floatingActionButton: FloatingButtons(
                  page: page,
                  elementsType: const ['title', 'subtitle', 'text', 'checkbox', 'image'],
                  onElementAdded: () => setState(() {}),
                ));
          } else {
            return const LoadingScreen();
          }
        });
  }
}
