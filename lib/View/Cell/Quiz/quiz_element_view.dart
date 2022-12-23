import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/Model/Elements/element_custom.dart';
import 'package:elephant_client/Network/client.dart';
import 'package:elephant_client/View/Cell/ElementScreen/horizontal_list.dart';
import 'package:elephant_client/View/Cell/FloatingBtns/floatings_btns.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

class QuizElemView extends StatefulWidget {
  final PageCustom page;

  const QuizElemView({Key? key, required this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateQuizElemView();
}

class _StateQuizElemView extends State<QuizElemView> {
  PageCustom get page => widget.page;

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
      future: getElements(page.id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var elements = snapshot.data!;

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
