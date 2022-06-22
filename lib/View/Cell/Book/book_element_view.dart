import 'package:flutter/material.dart';
import 'package:my_netia_client/View/FloatingBtns/floatings_btns.dart';
import '/Network/client.dart';
import '/View/Interfaces/interaction_view.dart';
import '/View/Interfaces/interaction_main.dart';
import '../../Elements/ElementScreen/VerticalList/vertical_list.dart';
import '/View/loading_screen.dart';
import '/Model/Elements/text_type.dart';
import '../../FloatingBtns/animation_floating_btns.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/element.dart' as elem;

class BookElemView extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Sheet sheet;

  const BookElemView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookElemView();
}

class _StateBookElemView extends State<BookElemView> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  Future<void> addCheckbox(int idSheet) async {
    try {
      await Client.request('addCheckbox', {'id_sheet': idSheet});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<elem.Element>>(
        future: interMain.getElements(sheet.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<elem.Element>> snapshot) {
          if (snapshot.hasData) {
            var elements = snapshot.data!;
            var widgets = interView.elementsToWidgets(elements, interView);

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
                        child: VerticalList(
                            inter: interMain,
                            elements: elements,
                            widgets: widgets),
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
                    'readonly',
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
