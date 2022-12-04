import 'package:flutter/material.dart';

import '/View/Cell/Quiz/quiz_element_view.dart';
import '/Model/Cells/sheet.dart';
import '/Model/Cells/cell.dart';

class QuizView extends StatelessWidget {
  final Cell cell;
  final Sheet sheet;

  const QuizView({Key? key, required this.cell, required this.sheet})
      : super(key: key);

  @override
  Widget build(BuildContext context) => QuizElemView(sheet: sheet);
}
