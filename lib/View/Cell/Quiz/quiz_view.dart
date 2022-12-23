import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/Cell/Quiz/quiz_element_view.dart';
import 'package:flutter/material.dart';

class QuizView extends StatelessWidget {
  final Cell cell;

  const QuizView({Key? key, required this.cell}) : super(key: key);

  @override
  Widget build(BuildContext context) => QuizElemView(page: cell.pages[0]);
}
