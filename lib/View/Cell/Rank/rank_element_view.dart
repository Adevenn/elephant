import 'package:flutter/material.dart';

import '../../FloatingBtns/floatings_btns.dart';
import '/View/loading_screen.dart';
import '../../Elements/ElementScreen/VerticalList/vertical_list.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_main.dart';
import '/View/Interfaces/interaction_view.dart';

class RankElemView extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Sheet sheet;

  const RankElemView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateRankElementView();
}

class _StateRankElementView extends State<RankElemView> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: interMain.getElements(sheet.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var elements = snapshot.data!;
          var widgets = interView.elementsToWidgets(elements, interView);

          return Scaffold(
              body: VerticalList(
                  inter: interMain, elements: elements, widgets: widgets),
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
