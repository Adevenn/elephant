import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/View/Cell/ElementManager/horizontal_list.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  final Cell cell;

  const QuizView({Key? key, required this.cell}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateQuizView();
}

class _StateQuizView extends State<QuizView> {
  late PageCustom page = widget.cell.pages[0];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: page.getElements(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var elements = page.elements;

          return Scaffold(
              body: HorizontalList(elements: elements),
              floatingActionButton: FloatingButtons(
                page: page,
                elementsType: const ['flashcard'],
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
