import 'package:flutter/material.dart';

import '/Network/client.dart';
import '../../FloatingBtns/floatings_btns.dart';
import '/View/loading_screen.dart';
import '../../Elements/ElementScreen/VerticalList/vertical_list.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/element.dart' as elem;
import '/View/Interfaces/interaction_view.dart';

class RankElemView extends StatefulWidget {
  final InteractionView interView;
  final Sheet sheet;

  const RankElemView({Key? key, required this.interView, required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateRankElementView();
}

class _StateRankElementView extends State<RankElemView> {
  InteractionView get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  Future<List<elem.Element>> getElements(int idSheet) async {
    var elements = <elem.Element>[];
    try {
      var result =
          await Client.requestResult('elements', {'id_sheet': idSheet});
      elements = List<elem.Element>.from(
          result.map((model) => elem.Element.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return elements;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getElements(sheet.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var elements = snapshot.data!;
          var widgets = interView.elementsToWidgets(elements, interView);

          return Scaffold(
              body: VerticalList(elements: elements, widgets: widgets),
              floatingActionButton: FloatingButtons(
                sheet: sheet,
                elements: const ['checkbox'],
                interView: interView,
                onElementAdded: () {
                  setState(() {});
                },
              ));
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
