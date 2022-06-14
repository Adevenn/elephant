import 'package:flutter/material.dart';
import '/View/Cell/Rank/rank_element_view.dart';
import '/View/loading_screen.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_main.dart';
import '/Model/cell.dart';
import '/View/Interfaces/interaction_view.dart';

class RankView extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Cell cell;

  const RankView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.cell})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateRankView();
}

class _StateRankView extends State<RankView> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;

  Cell get cell => widget.cell;
  Sheet? sheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: interMain.getSheet(cell.id, 0),
        builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
          if (snapshot.hasData && sheet != snapshot.data) {
            sheet = snapshot.data;
            return RankElemView(
                interMain: interMain, interView: interView, sheet: sheet!);
          } else {
            return const LoadingScreen();
          }
        });
  }
}
