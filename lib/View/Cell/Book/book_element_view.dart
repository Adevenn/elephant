import 'package:flutter/material.dart';

import '../FloatingBtns/floatings_btns.dart';
import '/Network/client.dart';
import '/View/Interfaces/interaction_view.dart';
import '../ElementScreen/VerticalList/vertical_list.dart';
import '/View/loading_screen.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/element_custom.dart';

class BookElemView extends StatefulWidget {
  final InteractionView interView;
  final Sheet sheet;

  const BookElemView({Key? key, required this.interView, required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookElemView();
}

class _StateBookElemView extends State<BookElemView> {
  InteractionView get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  Future<List<ElementCustom>> getElements(int idSheet) async {
    var elements = <ElementCustom>[];
    try {
      var result =
          await Client.requestResult('elements', {'id_sheet': idSheet});
      elements = List<ElementCustom>.from(
          result.map((model) => ElementCustom.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return elements;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ElementCustom>>(
        future: getElements(sheet.id),
        builder: (BuildContext context,
            AsyncSnapshot<List<ElementCustom>> snapshot) {
          if (snapshot.hasData) {
            var elements = snapshot.data!;

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
                                  sheet.title,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  sheet.subtitle,
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
                        child: VerticalList(elements: elements),
                      )
                    ],
                  ),
                ),
                floatingActionButton: FloatingButtons(
                  sheet: sheet,
                  elements: const [
                    'title',
                    'subtitle',
                    'text',
                    'checkbox',
                    'image'
                  ],
                  interView: interView,
                  onElementAdded: () => setState(() {}),
                ));
          } else {
            return const LoadingScreen();
          }
        });
  }
}
