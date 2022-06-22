import 'package:flutter/material.dart';

import '/View/FloatingBtns/floatings_btns.dart';
import '/Network/client.dart';
import '../../Elements/ElementScreen/VerticalList/vertical_list.dart';
import '/View/loading_screen.dart';
import '/Model/Elements/element.dart' as elem;
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_view.dart';

class ToDoListElemView extends StatefulWidget {
  final InteractionView interView;
  final Sheet sheet;

  const ToDoListElemView(
      {Key? key,
      required this.interView,
      required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateToDoListElemView();
}

class _StateToDoListElemView extends State<ToDoListElemView> {
  InteractionView get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  Future<List<elem.Element>> getElements(int idSheet) async {
    var elements = <elem.Element>[];
    try {
      var result =
          await Client.requestResult('elements', {'id_sheet': idSheet});
      elements = List<elem.Element>.from(
          result.map((model) => elem.Element.fromJson(model)));
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
          var widgets = interView.elementsToWidgets(elements, interView);

          return Scaffold(
              body: VerticalList(elements: elements, widgets: widgets),
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
