import 'package:flutter/material.dart';
import '/View/Cell/Rank/rank_element_view.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_main.dart';
import '/Model/cell.dart';
import '/View/Interfaces/interaction_view.dart';

class RankView extends StatelessWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Cell cell;
  final Sheet sheet;

  const RankView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.cell,
      required this.sheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RankElemView(
        interMain: interMain, interView: interView, sheet: sheet);
  }
}
