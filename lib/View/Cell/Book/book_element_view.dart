import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/View/Cell/ElementScreen/vertical_list.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class BookElemView extends StatefulWidget {
  final PageCustom page;

  const BookElemView({Key? key, required this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookElemView();
}

class _StateBookElemView extends State<BookElemView> {
  PageCustom get page => widget.page;

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
