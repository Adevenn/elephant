import 'package:flutter/material.dart';

import '/View/Cell/Rank/rank_element_view.dart';
import '/Model/Cells/sheet.dart';
import '/Model/Cells/cell.dart';

class RankView extends StatelessWidget {
  final Cell cell;
  final Sheet sheet;

  const RankView({Key? key, required this.cell, required this.sheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RankElemView(sheet: sheet);
  }
}
