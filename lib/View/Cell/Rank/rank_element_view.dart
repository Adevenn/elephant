import 'package:flutter/material.dart';

import '/Network/client.dart';
import '../FloatingBtns/floatings_btns.dart';
import '/View/loading_screen.dart';
import '../ElementScreen/vertical_list.dart';
import '/Model/Cells/sheet.dart';
import '/Model/Elements/element_custom.dart';
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
    return FutureBuilder(
      future: getElements(sheet.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var elements = snapshot.data!;

          return Scaffold(
              body: VerticalList(elements: elements),
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
