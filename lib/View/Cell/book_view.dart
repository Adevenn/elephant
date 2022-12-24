import 'package:elephant_client/Model/Cells/book.dart';
import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/View/Cell/ElementManager/vertical_list.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class BookView extends StatefulWidget {
  final Book book;
  final int pageIndex;

  const BookView({Key? key, required this.book, required this.pageIndex})
      : super(key: key);

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
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  page.subtitle,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: VerticalList(page: page),
                      )
                    ],
                  ),
                ),
                floatingActionButton: FloatingButtons(
                  page: page,
                  elementsType: const [
                    'title',
                    'subtitle',
                    'text',
                    'checkbox',
                    'image'
                  ],
                  onElementAdded: () => setState(() {}),
                ));
          } else {
            return const LoadingScreen();
          }
        });
  }
}
