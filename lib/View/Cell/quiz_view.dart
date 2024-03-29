import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/Model/Cells/quiz.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class QuizView extends StatefulWidget {
  final Quiz quiz;

  const QuizView({Key? key, required this.quiz}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateQuizView();
}

class _StateQuizView extends State<QuizView> {
  late PageCustom page = widget.quiz.pages[0];
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: page.getElements(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var elements = page.elements;

          return Scaffold(
              body: PageView.builder(
                controller: controller,
                itemCount: elements.length,
                itemBuilder: (context, index) {
                  return elements[index].toWidget();
                },
              ),
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
